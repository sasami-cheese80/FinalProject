//
//  NavigateBar.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

enum TabBar: String, CaseIterable {
    case house
    case car
case person
}

struct NavigateBar: View {
    @Binding var selectedTab: TabBar
    private var fillImage : String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack{
            HStack{
                ForEach(TabBar.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(tab == selectedTab ? 1.25: 1.0)
                        .foregroundColor(selectedTab == tab ?  .green : .gray)
                        .font(.system(size: 22))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(20)
            .padding()
        }
        
    }
}

#Preview {
    NavigateBar(selectedTab: .constant(.house))
}
