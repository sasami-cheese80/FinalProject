//
//  Home.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//


import SwiftUI

struct Home: View {
    @ObservedObject var fetchPlans = FetchPlans()
    
    var body: some View {
        NavigationView {
            ZStack{
                List(fetchPlans.plans, id: \.id) { plans in
                    NavigationLink {
//                        GroupUsers()
                    } label: {
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
                .navigationTitle("予定List")
            }
            
        }
    }
}

#Preview {
    Home()
}
