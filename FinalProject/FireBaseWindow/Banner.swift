//
//  Banner.swift
//  FinalProject
//
//  Created by yamada on 2024/07/05.
//

import SwiftUI

struct Banner: View {
    let message: String
    let backgroundColor: Color
    let textColor: Color

    var body: some View {
        Text(message)
            .padding()
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(10)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.3), value: UUID())
    }
}
