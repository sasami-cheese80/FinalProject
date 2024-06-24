//
//  ContentView.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("HOME")
                        
                }
            Ainori()
                .tabItem {
                    Image(systemName: "car")
                    Text("アイノリ")
                }
            Account()
                .tabItem {
                    Image(systemName: "person")
                    Text("ACCOUNT")
                }
        }
        .accentColor(.yellow)
    }
}

#Preview {
    ContentView()
}
