//
//  FetchProfile.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/29.
//

import Foundation

class FetchProfile: ObservableObject {
    @Published var profiles = [ProfileType]()

    func getProfile(userId: Int) async throws -> ProfileType {

        guard let url = URL(string: "\(Configuration.shared.apiUrl)/users/user_id/\(userId)") else {
//        guard let url = URL(string: "http://localhost:3000/users/user_id/\(userId)") else {
//            guard let url = URL(string: "https://megry-app-88b135b9cdab.herokuapp.com/users/user_id/\(userId)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let profile = try JSONDecoder().decode(ProfileType.self, from: data)
        DispatchQueue.main.async {
            self.profiles = [profile]
        }
        return profile
    }


    //patchする
    func patchProfile(patchData: ProfilePatchType, userId: Int) async throws {
        let url = URL(string:"\(Configuration.shared.apiUrl)/users/\(userId)")!
//        let url = URL(string:"http://localhost:3000/users/\(userId)")!
//        let url = URL(string:"https://megry-app-88b135b9cdab.herokuapp.com/users/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        //bodyに設定
        do {
            request.httpBody = try JSONEncoder().encode(patchData)
        } catch {
            print("bodyをエンコードできませんでした。")
            return
        }

        let (_, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
    }
}
