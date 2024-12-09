//
//  AppNavigation.swift
//  DogLike
//
//  Created by Lars Nicodemus on 09.12.24.
//

import SwiftUI

struct AppNavigation: View {
    @StateObject private var viewModel = DogViewModel()
    @Binding var isNotificationLaunch: Bool

    
    var body: some View {
        
        TabView {
            Tab("Home", systemImage: "house") {
                DogView(dogVM: viewModel, isNotificationLaunch: $isNotificationLaunch)
            }
            Tab("Settings", systemImage: "wrench") {
                Settings()
            }
        }
        
        .onAppear {
            
            NotificationService.shared.requestAuthorization()
        }
    }
}

#Preview {
    AppNavigation(isNotificationLaunch: .constant(false))
}
