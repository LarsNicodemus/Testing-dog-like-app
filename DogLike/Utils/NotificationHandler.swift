//
//  Notificationhandler.swift
//  DogLike
//
//  Created by Lars Nicodemus on 09.12.24.
//
import SwiftUI
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationHandler()
    var isNotificationLaunch = false

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let fromNotification = userInfo["fromNotification"] as? String, fromNotification == "true" {
                NotificationHandler.shared.isNotificationLaunch = true
                }
        if response.notification.request.content.categoryIdentifier == "TIMED_CATEGORY" {
            print("TIMED_CATEGORY Benachrichtigung erkannt.")

            switch response.actionIdentifier {
            case "OPEN_APP_ACTION":
                print("Aktion 'Öffnen' ausgewählt")
                break

            case "DISMISS_ACTION":
                print("Aktion 'Schließen' ausgewählt")
                break

            case UNNotificationDefaultActionIdentifier:
                print("Benutzer hat auf die Benachrichtigung getippt")
                break

            case UNNotificationDismissActionIdentifier:
                print("Benachrichtigung wurde abgelehnt")
                break

            default:
                print("Andere Aktion erkannt: \(response.actionIdentifier)")
                break
            }
        } else {
            print("Andere Kategorie erkannt: \(response.notification.request.content.categoryIdentifier)")
        }

        completionHandler()
    }
    
    
    func setupNotificationCategories() {
        let openAppAction = UNNotificationAction(
            identifier: "OPEN_APP_ACTION",
            title: "Öffnen",
            options: [.foreground]
        )
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Schließen",
            options: [.destructive]
        )
        
        let timedCategory = UNNotificationCategory(
            identifier: "TIMED_CATEGORY",
            actions: [openAppAction, dismissAction], 
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([timedCategory])
    }
}
