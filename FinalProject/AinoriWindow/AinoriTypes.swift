//
//  AinoriTypes.swift
//  FinalProject
//
//  Created by Yuta Sasaki  on 2024/07/02.
//

import Foundation

struct waitingType: Codable, Identifiable {
    var id: Int
    var date: String
    var state: String
    var users_count: Int
    }
