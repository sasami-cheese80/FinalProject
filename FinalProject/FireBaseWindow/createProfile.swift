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
        NavigationView {
            VStack(alignment: .leading,spacing: 20) {
                Text("プロフィール設定")
                    .font(.title)
                    .fontWeight(.bold)
                TextField("名前",text:$name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("ニックネーム（任意）",text:$nickname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("所属部署名（部）",text:$Department)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("所属部署名（室/課）",text:$division)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Picker("性別",selection:$gender) {
                    Text("男性").tag("男性")
                    Text("女性").tag("女性")
                }
                .pickerStyle(.segmented)
                List{
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
                }.listStyle(.plain)
            }
            .padding()
            .font(.system(size: 20))
            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
               print("ボタンが押されました")
                // usersにポストして欲しいよー
            }
        }
            
        }
    }
#Preview {
    createProfile()
}
