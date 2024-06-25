//
//  Home.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct Home: View {
    @ObservedObject var groupData: GroupData
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupData.groups) { group in
                    HStack {
                        Text(group.destination)
                            .padding()
                        Spacer()
                        Text("\(group.startTime)")
                    }
                }
            }
            .navigationBarTitle(Text("HOME"))
            
        }
    }
}


#Preview {
    Home(groupData: GroupData())
}


//let url = URL(string: "http://localhost:3000/users")!  //URLを生成
//
////Requestを生成
//var request = URLRequest(url: url)
//request.httpMethod = "GET"
//
//
//let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
//    guard let data = data else { return }
//    do {
//        let object = try JSONSerialization.jsonObject(with: data, options: [])  // DataをJsonに変換
//        print(object)
//    } catch let error {
//        print(error)
//    }
//}
//task.resume()


