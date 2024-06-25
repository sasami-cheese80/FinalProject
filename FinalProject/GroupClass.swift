//
//  GroupClass.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//

import SwiftUI

struct Group: Identifiable, Equatable {
    let id = UUID()
    var destination: String
    var startTime: Int
    
    init(destination: String, startTime: Int) {
        self.destination = destination
        self.startTime = startTime
    }
}
