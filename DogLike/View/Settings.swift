//
//  Settings.swift
//  DogLike
//
//  Created by Lars Nicodemus on 09.12.24.
//

import SwiftUI

struct Settings: View {
    @AppStorage("selection") var selection: Date = Date()
    func extractHourAndMinute(from date: Date) -> (Int, Int) {
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0
            return (hour, minute)
        }
    var body: some View {
        VStack{
            Text("Zur welchen Uhrzeit sollen wir Sie erinnern?")
            DatePicker("",selection: $selection,displayedComponents: .hourAndMinute)
            
                
        }
        .onChange(of: selection) { old, new in
            let(hour,minute) = extractHourAndMinute(from: selection)
            NotificationService.shared.scheduleDailyNotification(hour: hour, minute: minute)
        }
    }
}

#Preview {
    Settings()
}
