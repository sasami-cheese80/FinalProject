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
                            Text(user.name)
                                .font(.headline)
                            Text("ニックネーム: \(user.nickname)")
                            Text("性別: \(user.gender)")
                            Text("部署: \(user.department)")
                        }
                        .padding()
                    }
                }
                .navigationBarTitle(Text("相乗りメンバー"))
                .background(Color.white.opacity(0.3))
                
            }
            .onAppear() {
                fetchUsers.getUsers(planId: planId)
            }
        }
        VStack {
            Text("豊田市駅西口タクシー乗り場")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                .background(.white)
                .cornerRadius(8)
                .foregroundColor(Color.customTextColor)
                .padding(.init(top: 0, leading: 50, bottom: 60, trailing: 50))
                .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
            Button(action: {
                print("ここでdeleteします")
                fetchUsers.deletePlan(user_id: userId, plan_id: planId)
                dismiss() //現在のビューを閉じる
            }, label: {
                Text("グループから抜ける")
                    .foregroundColor(.black)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.init(top: 15, leading: 70, bottom: 15, trailing: 70))
                    .background(Color(red: 1.0, green: 0.96, blue: 0.93))
                    .cornerRadius(10)
                    .border(.black, width: 1)
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
