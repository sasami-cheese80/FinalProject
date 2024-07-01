//
//  ainori.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct Ainori: View {
    //    @Binding var tabSelection: Int
    
    @ObservedObject var viewModel: FirebaseModel
    @State var date: Date? = nil
    @State var textValue:String = ""
    @State var showDatePicker: Bool = false
    
    var body: some View {
        
        ZStack{
            Color.customlightGray
                VStack{
                    
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
                        .padding(.init(top: 0, leading: 50, bottom: 60, trailing: 50))
                        .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)

                    
                    Button(action: {
                        //                        tabSelection = 3
                        //unrap処理
                        guard let unwrapDate = date else {
                            print("nilです")
                            return
                        }
                        //post処理
                        if let userId = viewModel.userId{
                            postData(date: unwrapDate, userId: userId)
                        }else{
                            print("userIdがありませんでした。")
                        }
                        //textfeeld初期化
                        textValue = ""
                        
                    }, label: {
                        Text("探す")
                            .frame(width: 300, height: 50)
                            .background(Color.customMainColor)
                            .foregroundColor(Color.customTextColor)
                            .fontWeight(.semibold)
                            .cornerRadius(24)
                    })
                    .shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)
                }
                //datepicker表示制御
                if showDatePicker {
                    CustomDatePicker(
                        showDatePicker: $showDatePicker,
                        savedDate: $date,
                        sevedString: $textValue,
                        selectedDate: date ?? Date()
                    )
                    .animation(.linear, value: date)
                    .transition(.opacity)
                }
        }
        .background(Color.customlightGray)
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
private func postData(date: Date, userId: Int) -> String {
    let formatDate = dateToString(date: date)
    print("postする日時 → \(formatDate)")
    
    let url = URL(string:"http://localhost:3000/plans")!
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


#Preview {
    Ainori(viewModel: FirebaseModel())
}
