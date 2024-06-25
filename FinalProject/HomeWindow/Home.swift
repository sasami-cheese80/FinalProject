//
//  Home.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//


import SwiftUI

struct Plans: Codable {
    var id: Int
    var date: String
    var user_id: Int
}

class FetchPlans: ObservableObject {
    @Published var plans = [Plans]()

    init() {
        guard let url = URL(string: "http://localhost:3000/plans") else {
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

struct Home: View {
    @ObservedObject var fetchPlans = FetchPlans()

    var body: some View {
        List(fetchPlans.plans, id: \.id) { plans in
            VStack(alignment: .leading, spacing: 8) {
                Text(String(plans.id))
                    .font(.headline)
                Text(plans.date)
                    .font(.subheadline)
                Text(String(plans.user_id))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    Home()
}
