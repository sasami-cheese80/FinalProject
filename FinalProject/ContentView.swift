//
//  ContentView.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct ContentView: View {
    @State var tabSelection: Int = 0
    
    var body: some View {
        TabView {
            Home(groupData: GroupData())
            //            TabView(selection: $tabSelection) {
            //                Home(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "house")
                    Text("HOME")
                }
                .tag(1)
            //                Ainori(tabSelection: $tabSelection)
            Ainori()
                .tabItem {
                    Image(systemName: "car")
                    Text("アイノリ")
                }
                .tag(2)
            //                Account(tabSelection: $tabSelection)
            Account()
                .tabItem {
                    Image(systemName: "person")
                    Text("ACCOUNT")
                }
                .tag(3)
        }
        .accentColor(.yellow)
    }
}

#Preview {
    ContentView()
}
