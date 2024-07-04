//
//  Users.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//

import Foundation

struct Users: Codable {
    var id: Int
    var plan_id: Int
    var user_id: Int
    var date: String
    var state: String
    var users_count: Int
    var name: String
    var nickname: String
    var gender: String
    var department: String
    var division: String
    var address: String
    var hobby: String
    var message: String
    var tags: Array<String>
}
