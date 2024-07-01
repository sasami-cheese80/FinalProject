//
//  Account.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var viewModel: FirebaseModel
    @ObservedObject var fetchProfile = FetchProfile()
    
    @State private var name: String = ""
    @State private var nickname:String = ""
    @State private var gender:String = ""
    @State private var department:String = ""
    @State private var division:String = ""
    @State private var address:String = ""
    
    var body: some View {
        VStack{
            NavigationView {
                List(fetchProfile.profiles) { profile in
                    Section {
                        TextField("名前", text: $name)
                            .onAppear {
                                name = profile.name
                            }
                    }
                    
                    Section {
                        TextField("ニックネーム（任意）",text:$nickname)
                            .onAppear {
                                nickname = profile.nickname
                            }
                    } header: {
                        Text("ニックネーム")
                    }
                    
                    Section{
                        TextField("所属部署名（部）",text:$department)
                            .onAppear {
                                department = profile.department
                            }
                        TextField("所属部署名（室/課）",text:$division)
                            .onAppear {
                                division = profile.division
                            }
                    } header: {
                        Text("所属部署")
                    }
                    
                    Section{
                        Picker("性別",selection:$gender) {
                            Text("男性").tag("男性")
                            Text("女性").tag("女性")
                        }
                        .pickerStyle(.segmented)
                        .onAppear {
                            gender = profile.gender
                        }
                    } header: {
                        Text("性別")
                    }
                    
                    Section{
                        Picker("帰宅方面", selection: $address) {
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
                        .onAppear {
                            address = profile.address
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
            }
            .onAppear() {

                if let userId = viewModel.userId{
                    fetchProfile.getProfile(userId: userId)
                } else {
                    print("userIdがありませんでした。getProfileできません。")
                }
            }
            
            Button(action: {
                
                
                let patchData = ProfilePatchType(name: name, nickname: nickname, gender: gender, department: department, division: division, address: address)

                if let userId = viewModel.userId{
                    fetchProfile.patchProfile(patchData: patchData, userId: userId)
                } else {
                    print("userIdがありませんでした。patchProfileできません。")
                }
                print("patchしました。")
                
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            
            //logout処理ーーーーーーーーーーーーーーーーーーーーーーーーーー
                                    Button("Log Out") {
                                        // ログアウトしてログイン画面へ遷移する
                                        viewModel.signOut()
                                    }
                                    //firebase_id取得方法↓↓
//                                    Text(viewModel.uid ?? "User")
//                                        .padding()
            //logout処理ーーーーーーーーーーーーーーーーーーーーーーーーーー
        }
    }
}

#Preview {
    Profile(viewModel: FirebaseModel())
}

