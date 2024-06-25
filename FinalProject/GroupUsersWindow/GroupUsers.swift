//
//  GroupMember.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//



import SwiftUI



struct GroupUsers: View {
    
    @ObservedObject var fetchUsers = FetchUsers()
    
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
        
                }
        Text("")
    }
}

#Preview {
    GroupUsers()
}
