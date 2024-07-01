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
        TabView {
            //            TabView(selection: $tabSelection) {
            //                Home(tabSelection: $tabSelection)
            Home(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("HOME")
                }
                .tag(1)
            //                Ainori(tabSelection: $tabSelection)
            Ainori(viewModel: FirebaseModel())
                .tabItem {
                    Image(systemName: "car")
                    Text("アイノリ")
                }
                .tag(2)
            //                Account(tabSelection: $tabSelection)
            Profile(viewModel: FirebaseModel())
                .tabItem {
                    Image(systemName: "person")
                    Text("ACCOUNT")
                }
                .tag(3)
        }
        .accentColor(Color.customMainColor)
    }
}

#Preview {
    ContentView(viewModel: FirebaseModel())
}
