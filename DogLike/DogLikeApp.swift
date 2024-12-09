import SwiftUI

@main
struct DogLikeApp: App {
    @State private var isNotificationLaunch = false
    init() {
        UNUserNotificationCenter.current().delegate = NotificationHandler.shared
        NotificationHandler.shared.setupNotificationCategories()
        isNotificationLaunch = NotificationHandler.shared.isNotificationLaunch

    }
    var body: some Scene {
        WindowGroup {
            AppNavigation(isNotificationLaunch: $isNotificationLaunch)
                .onAppear {
                                    DispatchQueue.main.async {
                                        isNotificationLaunch = NotificationHandler.shared.isNotificationLaunch
                                    }

                                }
        }
    }
}
