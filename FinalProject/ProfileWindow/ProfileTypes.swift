//
//  ProfileTypes.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/29.
//

import Foundation

import Foundation

struct ProfileType: Codable, Identifiable {
    var id: Int
    var name: String
    var nickname: String
    var gender: String
    var department: String
    var division: String
    var address: String
    var addressOfHouse: String
    var firebase_id: String
    var hobby: String
    var message: String
    var tags: Array<String>
}

struct ProfilePatchType: Codable {
    var name: String
    var nickname: String
    var gender: String
    var department: String
    var division: String
    var address: String
    var addressOfHouse:String
    var hobby: String
    var message: String
    var tags: Array<String>
}
