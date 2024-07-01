
//
//  FetchPlans.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/25.
//

import Foundation

class FetchPlans: ObservableObject {
    @Published var plans = [Plans]()
    
    func getPlans(userId: Int) {
//        guard let url = URL(string: "http://localhost:3000/plans_users?user_id=1") else {
             guard let url = URL(string: "http://localhost:3000/plans_users?user_id=\(userId)") else {
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
                let plans = try decoder.decode([Plans].self, from: data)
                DispatchQueue.main.async {
                    self.plans = plans
                }
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
