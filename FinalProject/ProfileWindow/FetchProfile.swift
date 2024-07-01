//
//  FetchProfile.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/29.
//

import Foundation

class FetchProfile: ObservableObject {
    @Published var profiles = [ProfileType]()

    func getProfile(userId: Int) {

//        guard let url = URL(string: "http://localhost:3000/users/user_id/1") else {
        guard let url = URL(string: "http://localhost:3000/users/user_id/\(userId)") else {
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
                let profiles = try decoder.decode(ProfileType.self, from: data)
                DispatchQueue.main.async {
                    self.profiles = [profiles]
                }
//                print(profiles)
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    //patchする
    func patchProfile(patchData: ProfilePatchType, userId: Int) {

//        let url = URL(string:"http://localhost:3000/users/1")!
        let url = URL(string:"http://localhost:3000/users/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        //bodyに設定
        do {
            print(patchData)
            request.httpBody = try JSONEncoder().encode(patchData)
        } catch {
            print("bodyをエンコードできませんでした。")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }

            do {
                try JSONSerialization.jsonObject(with: data, options: [])
                //response見れるここで
//                print(object)
            } catch let error {
                print("Error parsing JSON response: \(error)")
            }
        }

        task.resume()
    }
}
