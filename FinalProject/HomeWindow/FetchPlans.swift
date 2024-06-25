
//
//  FetchPlans.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/25.
//

import Foundation

class FetchPlans: ObservableObject {
    @Published var plans = [Plans]()

    init() {
        guard let url = URL(string: "https://megry-app-88b135b9cdab.herokuapp.com/plans") else {
            //        guard let url = URL(string: "http://localhost:3000/plans") else {
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
