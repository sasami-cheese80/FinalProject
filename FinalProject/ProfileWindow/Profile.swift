//
//  Account.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var viewModel: FirebaseModel

    //    @Binding var tabSelection: Int
    var body: some View {
        VStack {
            
            
            
            
            Text("profile")
            
            
            
            
            
//logout処理ーーーーーーーーーーーーーーーーーーーーーーーーーー
            Button("Log Out") {
                // ログアウトしてログイン画面へ遷移する
                viewModel.signOut()
            }
            Text(viewModel.uid ?? "User")
                .padding()
            
            if let userId = viewModel.userId{
                Text("\(userId)")
            }
            
//logout処理ーーーーーーーーーーーーーーーーーーーーーーーーーー
        }
    }
}

#Preview {
    Profile(viewModel: FirebaseModel())
}


