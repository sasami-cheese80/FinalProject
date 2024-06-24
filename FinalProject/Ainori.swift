//
//  ainori.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI

struct Ainori: View {
    @State private var date = Date()
    
    var body: some View {
        VStack{
            Text("利用日時")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .fontWeight(.medium)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

                
            DatePicker("Dates", selection: $date)
                .environment(\.locale, Locale(identifier:"ja_JP"))
                .frame(width:337.0, height:300)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .background(.white)
            
            Button(action: {
                print($date)
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
        }

    }
    
}


#Preview {
    Ainori()
}
