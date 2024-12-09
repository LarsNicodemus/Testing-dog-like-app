//
//  NotificationService.swift
//  DogLike
//
//  Created by Lars Nicodemus on 09.12.24.
//

import UserNotifications
import SwiftUI


class NotificationService {
    private init() {}
    static let shared = NotificationService()

    func requestAuthorization() {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { success, error in
                if success {
                    print("Notification permission granted")
                    Task { @MainActor in
                        try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                    }
                } else if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
            }
        }


    func sendNotificationWithDelay(
        title: String, message: String, delay: Double, repeating: Bool = false
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = message
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: delay, repeats: repeating)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func scheduleMilestoneNotification(milestoneCount: Int) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("❌ Notifications not authorized")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "Super, du hast einen Meilenstein erreicht!"
            content.body = "Du hast bereits für \(milestoneCount) Hunde abgestimmt."
            content.categoryIdentifier = "BASIC_CATEGORY"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

            let request = UNNotificationRequest(identifier: "BASIC_NOTIFICATION", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Fehler beim Planen der Benachrichtigung: \(error.localizedDescription)")
                } else {
                    print("✅ Milestone-Benachrichtigung erfolgreich geplant für \(milestoneCount)")
                }
            }
        }
    }

    func scheduleDailyNotification(hour: Int, minute: Int) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("❌ Notifications not authorized")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Hast du heute schon deinen Like gegeben?"
            content.body = "Vergiss nicht, du kannst den coolsten Hund der Welt mitbestimmen, gib täglich deine Stimme ab!"
            content.sound = .default
            content.categoryIdentifier = "TIMED_CATEGORY"
            content.userInfo = ["fromNotification": "true"]


            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "TIMED_NOTIFICATION", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Fehler beim Planen der Benachrichtigung: \(error.localizedDescription)")
                } else {
                    print("✅ Benachrichtigung erfolgreich geplant für \(hour):\(minute) Uhr")
                }
            }
        }
    }
    
    
}
