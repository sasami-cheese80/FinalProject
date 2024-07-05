//
//  ainori.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct Ainori: View {
    @Binding var tabSelection: Int
    
    @ObservedObject var viewModel: FirebaseModel
    @State var date: Date? = nil
    @State var textValue:String = ""
    @State var showDatePicker: Bool = false
    @State var waitingDate:[waitingType] = []
    
    
    var body: some View {
        
        ZStack{
            Color.customlightGray
            VStack{
                Spacer()
                    .frame(height: 200)
                Text("利用日時を選択")
                    .font(.title)
                    .fontWeight(.bold)
                    .disabled(true)
                    .foregroundColor(Color.customTextColor)
                
                
                HStack(alignment: .top){
                    TextField("日時を選択", text: $textValue)
                        .padding(.top,3)
                        .background(.white)
                        .foregroundColor(Color.customTextColor)
                        .onChange(of: textValue){ value in
                            Task{
                                try await getWaiting(date: textValue)
                                print(Configuration.shared.apiUrl)
                            }
                        }
                    
                    Button(action: {
                        showDatePicker.toggle()
                    }, label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.customTextColor)
                            .background(.white)
                    })
                    
                }
                
                .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(.white)
                .cornerRadius(8)
                .padding(.init(top: 50, leading: 50, bottom: 30, trailing: 50))
                .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                
                Text("豊田市駅西口タクシー乗り場")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                    .background(.white)
                    .cornerRadius(8)
                    .foregroundColor(Color.customTextColor)
                    .padding(.init(top: 0, leading: 50, bottom: 30, trailing: 50))
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                
                if !waitingDate.isEmpty{
                    
                    VStack(spacing: 0){
                        Text("こちらの候補日が見つかりました")
                            .fontWeight(.bold)
                            .foregroundColor(Color.customTextColor)
                        ScrollView(.horizontal){
                            HStack {
                                
                                ForEach(0 ..< waitingDate.count, id: \.self) { index in
                                    let viewJpDate = stringToStringDate(stringDate: waitingDate[index].date,format:"HH:mm")
                                    
                                    let formJpDate = stringToStringDate(stringDate: waitingDate[index].date,format:"yyyy-MM-dd HH:mm")
                                    Button(
                                        action:{
                                            self.textValue = formJpDate
                                        },
                                        label: {
                                            VStack{
                                                Text("\(viewJpDate)")
                                                    .font(.largeTitle)
                                                    .lineLimit(1)
                                                Text("現在の利用者：\(waitingDate[index].users_count)人")
                                            }
                                            .frame(alignment: .leading)
                                            .padding(.all,20)
                                            .background(.white)
                                            .cornerRadius(8)
                                        })
                                } // Foreach
                                
                                
                            }.padding()
                        }
                    }
                }
                Spacer()
                Button(action: {
                    
//                    //unrap処理
//                    guard let unwrapDate = date else {
//                        print("nilです")
//                        return
//                    }
                    //post処理
                    if let userId = viewModel.userId{
                        postData(date: textValue, userId: userId)
                        print("dataをpostしました")
                    }else{
                        print("userIdがありませんでした。")
                    }
                    //textfeeld初期化
                    textValue = ""
                    tabSelection = 1
                }, label: {
                    Text("探す")
                        .frame(width: 300, height: 50)
                        .background(Color.customMainColor)
                        .foregroundColor(Color.customTextColor)
                        .fontWeight(.semibold)
                        .cornerRadius(24)
                })
                .shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)
                .padding(.bottom, 20)
            }
            
            //datepicker表示制御
            if showDatePicker {
                CustomDatePicker(
                    showDatePicker: $showDatePicker,
                    savedDate: $date,
                    savedString: $textValue,
                    selectedDate: date ?? Date()
                )
                .animation(.linear, value: date)
                .transition(.opacity)
            }
        }
        .background(Color.customlightGray)
        .onAppear(){
            waitingDate = []
        }
    }
    
    
    func getWaiting(date:String) async throws -> [waitingType]{
        guard let url = URL(string: "\(Configuration.shared.apiUrl)/plans?date=\(date)&userId=\(viewModel.userId!)") else {
//        guard let url = URL(string: "http://localhost:3000/plans?date=\(date)") else {
//            guard let url = URL(string: "https://megry-app-88b135b9cdab.herokuapp.com/plans?date=\(date)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let profile = try JSONDecoder().decode([waitingType].self, from: data)
        
        DispatchQueue.main.async {
            self.waitingDate = profile
        }
        return profile
    }
    
    
    func stringToStringDate(stringDate: String, format:String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" //変換元のStringのDateの型に合わせる必要あり
            let newDate =  dateFormatter.date(from: stringDate)!
            dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ja_JP") //日本のタイムゾーン設定をする
            let getDate = dateFormatter.string(from: newDate)
            return getDate
        }
}

//dataをフォーマットする
private func dateToString(date: Date) -> String {
    let calendar = Calendar(identifier: .gregorian)
    let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    guard let year = dateComponents.year,
          let month = dateComponents.month,
          let day = dateComponents.day,
          let hour = dateComponents.hour,
          let minute = dateComponents.minute
    else {
        return "無効な日付"
    }
    
    let select_date = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day)) \(String(format: "%02d", hour)):\(String(format: "%02d", (minute/15)*15)):00"

    return select_date
}

//postする
    private func postData(date: String, userId: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strToDate = formatter.date(from: date)
        print(strToDate!)
        let ISOformatter = ISO8601DateFormatter()
        let formatDate = ISOformatter.string(from: strToDate!)
        print(formatDate)
//    print("postする日時 → \(formatDate)")
    
    let url = URL(string:"\(Configuration.shared.apiUrl)/plans")!
//    let url = URL(string:"http://localhost:3000/plans")!
//    let url = URL(string:"https://megry-app-88b135b9cdab.herokuapp.com/plans")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    //bodyに設定
    request.httpBody = "user_id=\(userId)&date=\(formatDate)".data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else { return }
        
        do {
            try JSONSerialization.jsonObject(with: data, options: [])
            //response見れるここで
            //            print(object)
        } catch let error {
            print("Error parsing JSON response: \(error)")
        }
    }
    
    task.resume()
    return "ポストしたよ"
}
