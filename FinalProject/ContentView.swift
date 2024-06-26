//
//  ContentView.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct ContentView: View {
    @State var tabSelection: Int = 0
    var viewModel: FirebaseModel
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Home(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("HOME")
                }
                .tag(1)
            
            Ainori(tabSelection: $tabSelection, viewModel: viewModel)
                .tabItem {
                    Image(systemName: "car")
                    Text("アイノリ")
                }
                .tag(2)
            
            Profile(tabSelection: $tabSelection, viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("ACCOUNT")
                }
                .tag(3)
//            otamesi()
//                .tabItem {
//                    Image(systemName: "testtube.2")
//                    Text("お試し")
//                }
//                .tag(4)
//            otamesi2()
//                .tabItem {
//                    Image(systemName: "testtube.2")
//                    Text("お試し2")
//                }
//                .tag(5)
        }
        .accentColor(Color.customTextColor)
    }
}

