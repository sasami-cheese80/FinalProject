//
//  createProfile.swift
//  FinalProject
//
//  Created by Yuta Sasaki  on 2024/06/27.
//

import SwiftUI

struct createProfileType: Codable{
    var name: String
    var nickname: String
    var gender: String
    var department: String
    var division: String
    var address: String
    var firebase_id: String
}


class CreateProfileClass: ObservableObject {
    @Published var profiles = [createProfileType]()
    func postProfile(postData: createProfileType, viewModel: FirebaseModel) {
        let url = URL(string:"http://localhost:3000/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        //bodyに設定
        do {
            request.httpBody = try JSONEncoder().encode(postData)
        } catch {
            print("bodyをエンコードできませんでした。")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }

            do {
                let object = try JSONDecoder().decode([String: Int].self, from: data)
                if let id = object["id"] {
                    DispatchQueue.main.async{
                        print(object,id)
                        viewModel.userId = id
                }
                }
            } catch let error {
                print("Error parsing JSON response: \(error)")
            }
        }
        task.resume()
    }
}


struct CreateProfile: View {
    @ObservedObject var viewModel: FirebaseModel
    @ObservedObject var createProfileClass = CreateProfileClass()
    @State private var name:String = ""
    @State private var nickname:String = ""
    @State private var gender:String = ""
    @State private var department:String = ""
    @State private var division:String = ""
    @State private var address:String = ""
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section {
                    TextField("名前",text:$name)
                    
                } header: {
                    Text("name")
                }
                
                Section {
                    TextField("ニックネーム（任意）",text:$nickname)
                } header: {
                    Text("ニックネーム")
                }
                
                Section{
                    TextField("所属部署名（部）",text:$department)
                    TextField("所属部署名（室/課）",text:$division)
                } header: {
                    Text("所属部署")
                }
                
                Section{
                    Picker("性別",selection:$gender) {
                        Text("男性").tag("男性")
                        Text("女性").tag("女性")
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("性別")
                }
                
                Section{
                    Picker("帰宅方面", selection: $address) {
                        Text("").tag("")
                        Text("岡崎方面").tag("岡崎方面")
                        Text("名古屋・日進方面").tag("名古屋・日進方面")
                        Text("知立・安城方面").tag("知立・安城方面")
                        Text("長久手方面").tag("長久手方面")
                        Text("瀬戸方面").tag("瀬戸方面")
                        Text("岐阜方面").tag("岐阜方面")
                        Text("碧南・西尾方面").tag("碧南・西尾方面")
                        Text("豊川・豊橋方面").tag("豊川・豊橋方面")
                        Text("新城方面").tag("碧南・西尾方面")
                    }
                } header: {
                    Text("帰宅方面")
                }
                
            }
            .padding()
            .font(.system(size: 18))
            .navigationBarTitle("プロフィール設定")
            .listSectionSpacing(5)
            .scrollContentBackground(.hidden)
            .background(Color.customlightGray)
            
            Button(action: {
                print("ボタンが押されました")
                viewModel.isAuthenticated = true
                viewModel.isSignedUp = false
                if viewModel.uid != nil{
                    let postData = createProfileType(name: name, nickname: nickname, gender: gender, department: department, division: division, address: address, firebase_id: viewModel.uid!)
                    createProfileClass.postProfile(postData: postData, viewModel: viewModel)
                } else {
                    print("firebase_idが取得できませんでした。createProfileできません。")
                }
       

            }, label: {
                Text("決定")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.init(top: 13, leading: 70, bottom: 13, trailing: 70))
                    .background(.black)
                    .cornerRadius(5)

            })
        }
        
    }
}


