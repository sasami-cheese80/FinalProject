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
        NavigationStack {
            ZStack{
                List(fetchPlans.plans, id: \.id) { plan in
                    
                    NavigationLink {
                        GroupUsers(planId: plan.plan_id)
                    } label: {
                        HStack() {
                            VStack(alignment: .leading, spacing: 0) {
                                
                                Text(String(plan.address))
                                    .font(.subheadline)
                                Text(stringToStringDate(stringDate: plan.date, format: "MM/dd　HH:mm"))
                                    .font(.title)
                            }
                            .padding(.trailing, 20)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                switch plan.state {
                                case "募集中":
                                    Text("\(plan.state)...")
                                        .font(.subheadline)
//                                        .foregroundColor(Color.customMainColor)
                                case "確定":
                                    Text("\(plan.state)")
                                        .font(.subheadline)
                                case "終了":
                                    Text("\(plan.state)...")
                                        .font(.subheadline)
                                default:
                                    Text("\(plan.state)")
                                        .font(.subheadline)
                                }
                                Text("\(plan.users_count) / 4人")
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("HOME")
                    .foregroundColor(plan.state == "終了" ? Color.customDarkGray : Color.customTextColor)
                    .padding(.all, 5)
                    .background(Color.white.opacity(0.3))
                    .background(plan.state == "終了" ? Color.customDarkGray : Color.customlightGray)
                    .cornerRadius(10)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.customlightGray)
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                }
                .listStyle(.plain)
                .background(Color.customlightGray)
                
            }
            .onAppear() {
                fetchPlans.getPlans()
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
