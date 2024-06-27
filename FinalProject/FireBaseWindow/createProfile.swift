//
//  createProfile.swift
//  FinalProject
//
//  Created by Yuta Sasaki  on 2024/06/27.
//

import SwiftUI

struct createProfile: View {
    @State private var name:String = ""
    @State private var nickname:String = ""
    @State private var gender:String = "男性"
    @State private var Department:String = ""
    @State private var division:String = ""
    @State private var goHome:String = "岡崎方面"
    
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
                    TextField("所属部署名（部）",text:$Department)
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
                    Picker("帰宅方面", selection: $goHome) {
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
                // usersにポストして欲しいよー
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
#Preview {
    createProfile()
}
