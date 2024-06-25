//
//  Home.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//


import SwiftUI

struct Home: View {
    @ObservedObject var fetchPlans = FetchPlans()
    
    var body: some View {
        NavigationView {
            ZStack{
                List(fetchPlans.plans, id: \.id) { plans in
                    NavigationLink {
                        GroupUsers()
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text(String(plans.address))
                                .font(.headline)
                            Text(stringToStringDate(stringDate: plans.date, format: "MM/dd　HH:mm"))
                                .font(.subheadline)
                            Text(String(plans.state))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("予定List")
            }
            
        }
    }
}

func stringToStringDate(stringDate: String, format:String) -> String {
 
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" //変換元のStringのDateの型に合わせる必要あり
        let newDate =  dateFormatter.date(from: stringDate)!
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ja_JP")//日本のタイムゾーン設定をする
        let getDate = dateFormatter.string(from: newDate)
   
        return getDate
    }




#Preview {
    Home()
}
