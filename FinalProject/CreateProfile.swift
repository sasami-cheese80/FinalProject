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
    var addressOfHouse: String
    var firebase_id: String
    var hobby: String
    var message: String
    var tags: Array<String>
}


class CreateProfileClass: ObservableObject {
    @Published var profiles = [createProfileType]()

    func postProfile(postData: createProfileType, viewModel: FirebaseModel) {
        let url = URL(string:"\(Configuration.shared.apiUrl)/users")!
//        let url = URL(string:"http://localhost:3000/users")!
//        let url = URL(string:"https://megry-app-88b135b9cdab.herokuapp.com/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        //bodyに設定
        do {
            print(postData)
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
//                        print(object,id)
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
    @State private var addressOfHouse:String = ""
    @State private var hobby:String = ""
    @State private var message:String = ""
    @State private var stringTags:String = ""
    
    var body: some View {
        VStack{
            NavigationStack {
                List {
                    
                    Section {
                        TextField("名前",text:$name)
                            .accentColor(Color.customTextColor)
                    } header: {
                        Text("name")
                    }
                    
                    Section {
                        TextField("ニックネーム（任意）",text:$nickname)
                            .accentColor(Color.customTextColor)
                    } header: {
                        Text("ニックネーム")
                    }
                    
                    Section{
                        TextField("所属部署名（部）",text:$department)
                            .accentColor(Color.customTextColor)
                        TextField("所属部署名（室/課）",text:$division)
                            .accentColor(Color.customTextColor)
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
                            Text("新城方面").tag("新城方面")
                        }
                    } header: {
                        Text("帰宅方面")
                    }
                    
                    Section {
                        TextField("〇〇県〇〇市〇〇町１−１",text:$addressOfHouse)
                            .accentColor(Color.customTextColor)
                    } header: {
                        Text("家の住所")
                    }
                    
                    Section {
                        TextField("趣味(任意)",text:$hobby)
                            .accentColor(Color.customTextColor)
                    } header: {
                        Text("趣味")
                    }
                    
                    Section {
                        TextField("アイノリ相手へ一言メッセージ(任意)",text:$message)
                            .accentColor(Color.customTextColor)
                    } header: {
                        Text("アイノリ相手へ一言メッセージ")
                    }
                    
                    Section {
                        TextField("タグ(任意)",text:$stringTags)
                            .accentColor(Color.customTextColor)
                    } header: {
                        Text("タグ ※全角スペース区切り")
                    }
                    
                }
                .padding()
                .font(.system(size: 18))
                .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                .listSectionSpacing(5)
                .scrollContentBackground(.hidden)
                .background(Color.customlightGray)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("プロフィール設定")
                            .font(.system(size: 30))
                            .foregroundColor(Color.customTextColor)
                            .fontWeight(.heavy)
                            .padding(.top,100)
                    }
                }
            }
                
                Button(action: {
                    viewModel.isAuthenticated = true
                    viewModel.isSignedUp = false
                    withAnimation{
                        viewModel.bannerMessage = "アカウント登録出来ました！"
                        viewModel.showBanner = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation{
                            viewModel.showBanner = false
                        }
                        }
                    if viewModel.uid != nil{
                        let tagConvert = stringTags.components(separatedBy: " ")
                        let postData = createProfileType(
                            name: name,
                            nickname: nickname,
                            gender: gender,
                            department: department,
                            division: division,
                            address: address,
                            addressOfHouse: addressOfHouse,
                            firebase_id: viewModel.uid!,
                            hobby: hobby,
                            message: message,
                            tags: tagConvert
                        )

                        createProfileClass.postProfile(postData: postData, viewModel: viewModel)
                    } else {
                        print("firebase_idが取得できませんでした。createProfileできません。")
                    }
                }, label: {
                    Text("決定")
                        .frame(width: 300, height: 50)
                        .background(Color.customMainColor)
                        .foregroundColor(Color.customTextColor)
                        .fontWeight(.semibold)
                        .cornerRadius(24)
                })
                .padding(.bottom, 30)
                .shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)

        }
        .background(Color.customlightGray)
        .overlay(
                  VStack {
                      if viewModel.showBanner {
                          Banner(message: viewModel.bannerMessage, backgroundColor: .green, textColor: .white)
                              .padding(.top, 50)
                      }
                      Spacer()
                  }
              )
    }
}
