//
//  Home.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//


import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: FirebaseModel
    @ObservedObject var fetchPlans = FetchPlans()
    
    @State private var isPresented: Bool = false
    // @State private var textView: Bool = false
    var body: some View {
        ZStack{
            NavigationStack {
                
                ZStack{
                    List(fetchPlans.plans, id: \.id) { plan in
                        NavigationLink {
                            if let userId = viewModel.userId {
                                GroupUsers(planId: plan.plan_id, userId: userId)
                            } else {
                                //                            print("userIdがありませんでした")
                            }
                            
                            
                        } label: {
                            HStack() {
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    Text(String(plan.address))
                                        .font(.subheadline)
                                    
                                    if (plan.state == "確定") {
                                        Text(stringToStringDate(stringDate: plan.date, format: "MM/dd　HH:mm"))
                                            .font(.title)
                                            .foregroundColor(Color.customMainColor)
                                    } else {
                                        Text(stringToStringDate(stringDate: plan.date, format: "MM/dd　HH:mm"))
                                            .font(.title)
                                    }
                                    
                                }
                                .padding(.trailing, 20)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    switch plan.state {
                                    case "募集中":
                                        Text("\(plan.state)...")
                                            .font(.subheadline)
                                    case "確定":
                                        Text("\(plan.state)")
                                            .font(.subheadline)
                                    case "終了":
                                        Text("\(plan.state)")
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
                        .foregroundColor(Color.customTextColor)
                        .padding(.all, 5)
                        .background(Color.white.opacity(0.3))
                        .background(plan.state == "終了" ? Color.customlightGray : Color.white)
                        .cornerRadius(10)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.customlightGray)
                        .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(plan.state == "確定" ? Color.customMainColor : Color.clear, lineWidth: 1.0)
                        )
                    }
                    .listStyle(.plain)
                    .background(Color.customlightGray)
                    
                }
                .onAppear() {
                    if let userId = viewModel.userId{
                        //                    Text("id:\(userId)")
                        fetchPlans.getPlans(userId: userId)
                        // textView = false
                    }else{
                        // textView = false
                        print("userIdがありませんでした。")
                    }
                }
            }
            .accentColor(Color.customTextColor)
            // if (textView == false) {
            //     Text("現在予定はありません。")
            //         .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            //         .font(.title3)
            // }
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
    Home(viewModel: FirebaseModel())
}

