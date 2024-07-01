//
//  GroupMember.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//



import SwiftUI



struct GroupUsers: View {
    
    var planId: Int
    var userId: Int
    
    @ObservedObject var fetchUsers = FetchUsers()
    
    @Environment(\.dismiss) private var dismiss
    
//    init(planId: Int) {
//        self.planId = planId
//        self.fetchUsers = FetchUsers(planId: planId)
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                List {
                    ForEach(fetchUsers.users, id: \.id) { user in
                        VStack(alignment: .leading) {
                            Text(user.department)
                                .font(.headline)
                                .foregroundColor(Color.customTextColor)
                            Text("    \(user.division)")
                                .font(.footnote)
                            Text("       \(user.name)")
                                .font(.title)
                            Text("     ニックネーム：\(user.nickname)")
                                .font(.footnote)
                        }
                        .frame(width: 340)
                        .foregroundColor(Color.customTextColor)
                        .padding(.all, 1)
                        .background(Color.white.opacity(0.3))
                        .background(Color.white)
                        .cornerRadius(10)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.customlightGray)
                        .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( Color.clear, lineWidth: 1.0)
                        )
                    }
                }
                .listStyle(.plain)
                .background(Color.customlightGray)
                .navigationBarTitle(Text("相乗りメンバー"))
                
                
            }
            .onAppear() {
                fetchUsers.getUsers(planId: planId)
            }
            .onDisappear() {
                dismiss()
            }
        }
        VStack {
            Text("<待ち合わせ場所>")
                .font(.subheadline)
            Text("豊田市駅西口タクシー乗り場")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                .background(.white)
                .cornerRadius(8)
                .foregroundColor(Color.customTextColor)
                .padding(.init(top: 0, leading: 50, bottom: 20, trailing: 50))
                .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
            Button(action: {
                print("ここでdeleteします")
                fetchUsers.deletePlan(user_id: userId, plan_id: planId)
                dismiss() //現在のビューを閉じる
            }, label: {
                Text("相乗りをキャンセル")
                    .frame(maxWidth: 200, alignment: .center)
                    .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(Color.customlightGray)
                    .cornerRadius(15)
                    .foregroundColor(Color(red: 0.104, green: 0.551, blue: 1.0))
                    .padding(.init(top: 0, leading: 50, bottom: 15, trailing: 50))
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
            })
        }
    }
}

#Preview {
    GroupUsers(planId: 1, userId: 1)
}


//Button(action: {
//    //                        tabSelection = 1
//    //unrap処理
//    guard let unwrapDate = date else {
//        print("nilです")
//        return
//    }
//    //post処理
//    if let userId = viewModel.userId{
//        postData(date: unwrapDate, userId: userId)
//    }else{
//        print("userIdがありませんでした。")
//    }
//    //textfeeld初期化
//    textValue = ""
//    
//}, label: {
//    Text("探す")
//        .frame(width: 300, height: 50)
//        .background(Color.customMainColor)
//        .foregroundColor(Color.customTextColor)
//        .fontWeight(.semibold)
//        .cornerRadius(24)
//})
//.shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)
