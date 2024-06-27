//
//  Home.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//


import SwiftUI

struct Home: View {
    @ObservedObject var fetchPlans = FetchPlans()

    
    @State var isDisabled = true

    var body: some View {
        NavigationView {
            ZStack{
                List(fetchPlans.plans, id: \.id) { plan in
//                    NavigationLink (
//                        destination: GroupUsers(planId: plan.plan_id)
//                    ) {
                        switch plan.state {
                        case "募集中":
                            NavigationLink {
                            GroupUsers(planId: plan.plan_id)
                            } label: {
                                //                            print("募集中")
                                HStack() {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(String(plan.address))
                                        .font(.subheadline)
                                    Text(stringToStringDate(stringDate: plan.date, format: "MM/dd　HH:mm"))
                                        .font(.title)
                                    

                                }
                                .padding(.trailing, 20)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(String("\(plan.state)..."))
                                            .font(.subheadline)
                                        Text(String("\(plan.users_count) / 4人"))
                                    }
                                }
                            }
                            .padding()
                        case "確定":
                            NavigationLink {
                            GroupUsers(planId: plan.plan_id)
                            } label: {
                                //                            print("募集中")
                                HStack() {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(String(plan.address))
                                        .font(.subheadline)
                                    Text(stringToStringDate(stringDate: plan.date, format: "MM/dd　HH:mm"))
                                        .font(.title)
                                    

                                }
                                .padding(.trailing, 20)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(String("\(plan.state)..."))
                                            .font(.subheadline)
                                        Text(String("\(plan.users_count) / 4人"))
                                    }
                                }
                            }
                            .padding()
//                            print("確定")
                                  case "終了":
                            NavigationLink {
                            GroupUsers(planId: plan.plan_id)
                            } label: {
                                //                            print("募集中")
                                HStack() {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(String(plan.address))
                                        .font(.subheadline)
                                    Text(stringToStringDate(stringDate: plan.date, format: "MM/dd　HH:mm"))
                                        .font(.title)
                                    

                                }
                                .padding(.trailing, 20)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(String("\(plan.state)..."))
                                            .font(.subheadline)
                                        Text(String("\(plan.users_count) / 4人"))
                                    }
                                }
                            }
                            .padding()
                            .foregroundColor(.gray)
//                                    print("終了")
                                  default:
                            NavigationLink (
                                destination: GroupUsers(planId: plan.plan_id)
                            ) {
                            VStack(alignment: .leading, spacing: 8) {
                                
                                Text(String(plan.address))
                                    .font(.headline)
                                Text(stringToStringDate(stringDate: plan.date, format: "MM/dd　HH:mm"))
                                    .font(.subheadline)
                                Text(String(plan.state))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
//                                    print("それ以外です")
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
