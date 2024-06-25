//
//  GroupData.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//

import SwiftUI



class GroupData: ObservableObject {
    @Published var groups = [
        Group(destination: "岡崎方面", startTime: 1),
        Group(destination: "岡崎方面", startTime: 1),
        Group(destination: "岡崎方面", startTime: 1)
    ]
    
    
}
