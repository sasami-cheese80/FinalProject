//
//  CustomDatePicker.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/25.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @Binding var sevedString: String
    @State var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showDatePicker = false
                }
            VStack {
                DatePicker("Select Date",
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "ja"))
                .onAppear {
                               UIDatePicker.appearance().minuteInterval = 15
                           }
                
                
                Divider()
                HStack {
                    Button("キャンセル") {
                        showDatePicker = false
                    }
                    Spacer()
                    Button("保存") {
                        savedDate = selectedDate
                        sevedString = dateToString(date: selectedDate)
                        showDatePicker = false
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 20)
            .background(
                Color.white
                    .cornerRadius(30)
            )
            .padding(.horizontal, 20)
        }
    }
    
    func dateToString(date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let select_date:String = "\(dateComponents.year!)-\(String(format: "%02d", dateComponents.month!))-\(String(format: "%02d", dateComponents.day!)) \(String(format: "%02d", dateComponents.hour!)):\(String(format: "%02d", dateComponents.minute!))"
        return select_date
    }
    
}
