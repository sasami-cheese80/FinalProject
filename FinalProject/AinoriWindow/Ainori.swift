//
//  ainori.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct Ainori: View {
    //    @Binding var tabSelection: Int
    @State var date: Date? = nil
    @State var textValue:String = ""
    @State var showDatePicker: Bool = false
    
    var body: some View {
        
        ZStack{
            VStack{
                
                Text("利用日時を選択")
                    .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                    .fontWeight(.medium)
                    .padding(.leading, 40.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .disabled(true)
                
                HStack(alignment: .top){
                    TextField("日時を選択", text: $textValue)
                        .padding(.top,3)
                    
                    Button(action: {
                        showDatePicker.toggle()
                    }, label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    })
                    
                }
                .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.init(top: 50, leading: 50, bottom: 100, trailing: 50))
                
                Button(action: {
                    //                        tabSelection = 3
                    //unrap処理
                    guard let unwrapDate = date else {
                        print("nilです")
                        return
                    }
                    
                    //post処理
                    print(postData(date: unwrapDate))
                    //textfeeld初期化
                    textValue = ""
                    
                }, label: {
                    Text("探す")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.init(top: 15, leading: 70, bottom: 15, trailing: 70))
                        .background(.black)
                        .cornerRadius(5)
                })
                
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
          let minute = dateComponents.minute,
          let second = dateComponents.second else {
        return "無効な日付"
    }
    
    let select_date = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day)) \(String(format: "%02d", hour)):\(String(format: "%02d", (minute/15)*15)):00"
    
    return select_date
}

//postする
private func postData(date: Date) -> String {
    let formatDate = dateToString(date: date)
    print("postする日時 → \(formatDate)")
    
    let url = URL(string:"http://localhost:3000/plans_users")!
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { (data, response, erro) in
        guard let data = data else { return }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            print(object)
        } catch let error {
            print(error)
        }
    }
    task.resume()
    return "ポストしたよ"
}



#Preview {
    Ainori()
}
