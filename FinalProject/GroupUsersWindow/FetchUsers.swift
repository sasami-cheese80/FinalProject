//
//  FetchUsers.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//

import Foundation

class FetchUsers: ObservableObject {
    @Published var users = [Users]()


    func getUsers(planId: Int) {
        guard let url = URL(string: "\(Configuration.shared.apiUrl)/plans_users?plan_id=\(planId)") else {
//        guard let url = URL(string: "http://localhost:3000/plans_users?plan_id=\(planId)") else {
//        guard let url = URL(string: "https://megry-app-88b135b9cdab.herokuapp.com/plans_users?plan_id=\(planId)") else {
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
    
    func deletePlan(user_id: Int, plan_id: Int) -> String {
        
//        let url = URL(string:"http://localhost:3000/plans/?userId=\(user_id)&planId=\(plan_id)")!
//        let url = URL(string:"https://megry-app-88b135b9cdab.herokuapp.com/plans/?userId=\(user_id)&planId=\(plan_id)")!
        let url = URL(string:"\(Configuration.shared.apiUrl)/plans/?userId=\(user_id)&planId=\(plan_id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Invalid data")
                return
            }
            
            do {
                let deleteObject = try JSONSerialization.jsonObject(with: data, options: [])
                //response見れるここで
                print(deleteObject)
            } catch let error {
                print("Error parsing JSON response: \(error)")
            }
        }
        task.resume()
        return "deleteしたよ"
    }
}
