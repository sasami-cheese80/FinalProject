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
        NavigationView {
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
                    .navigationBarItems(trailing: Button(action: {
//                        DeleteTask()
                    })
                                        {
                        Text("グループから抜ける")
                    }
                    )
        
                }
        Text("")
    }
}

//#Preview {
//    GroupUsers(planId: 1)
//}
