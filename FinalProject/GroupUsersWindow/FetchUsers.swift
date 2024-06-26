//
//  FetchUsers.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//

import Foundation

class FetchUsers: ObservableObject {
    @Published var users = [Users]()

    init(planId: Int) {
//        guard let url = URL(string: "https://megry-app-88b135b9cdab.herokuapp.com/users") else {
//            print("Invalid URL")
//            return
        guard let url = URL(string: "http://localhost:3000/plans_users?plan_id=\(planId)") else {
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
