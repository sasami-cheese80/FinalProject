//
//  GroupMember.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//



import SwiftUI



struct GroupUsers: View {
    
    var planId: Int
    
    @ObservedObject var fetchUsers: FetchUsers
    
    init(planId: Int) {
        self.planId = planId
        self.fetchUsers = FetchUsers(planId: planId)
    }
    
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
                //                    .navigationBarItems(trailing: Button(action: {
                ////                        DeleteTask()
                //                    })
                //                                        {
                //                        Text("グループから抜ける")
                //                    }
                //                    )
                
            }
        }
        Button(action: {
            print("ここでdeleteします")
            deletePlan(user_id: 1, plan_id: 1)
//                        tabSelection = 3
        }, label: {
            Text("グループから抜ける")
                .foregroundColor(.black)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.init(top: 15, leading: 70, bottom: 15, trailing: 70))
                .background(Color(red: 1.0, green: 0.96, blue: 0.93))
                .cornerRadius(10)
                .border(.black, width: 1)
        })
        Text("")
    }
}

#Preview {
    GroupUsers(planId: 1)
}
