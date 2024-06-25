//
//  GroupMember.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//



import SwiftUI

struct Users: Codable {
    var id: Int
    var name: String
    var nickname: String
    var gender: String
    var department: String
    var address: String
}

class FetchUsers: ObservableObject {
    @Published var users = [Users]()

    init() {
        guard let url = URL(string: "http://localhost:3000/users") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Invalid data")
                return
            }

            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode([Users].self, from: data)
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}



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
    }
}

#Preview {
    GroupUsers()
}
