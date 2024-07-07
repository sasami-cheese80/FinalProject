//
//  PlansModel.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/25.
//

import Foundation
//
//struct Plans: Codable {
//    var id: Int
//    var date: String
//    var user_id: Int
//}

struct Plans: Codable, Comparable {
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
    var address: String
    var addressOfHouse:String
    
    static func < (lhs: Plans, rhs: Plans) -> Bool {
        return lhs.date < rhs.date
    }
}
