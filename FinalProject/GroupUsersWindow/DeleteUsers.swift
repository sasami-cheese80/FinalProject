//
//  DeleteUsers.swift
//  FinalProject
//
//  Created by user on 2024/06/27.
//

import Foundation

//--------------------------------------------------------------
//deleteはFetchUsersの中に移しました
//--------------------------------------------------------------

//deleteする
//func deletePlan(user_id: Int, plan_id: Int) -> String {
//    
//    let url = URL(string:"http://localhost:3000/plans/?userId=\(user_id)&planId=\(plan_id)")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "DELETE"
//    
//    
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//            return
//        }
//        
//        guard let data = data else {
//            print("Invalid data")
//            return
//        }
//        
//        do {
//            let deleteObject = try JSONSerialization.jsonObject(with: data, options: [])
//            //response見れるここで
//            print(deleteObject)
//        } catch let error {
//            print("Error parsing JSON response: \(error)")
//        }
//    }
//    task.resume()
//    return "deleteしたよ"
//}
