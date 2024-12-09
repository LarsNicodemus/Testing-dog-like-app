//
//  DogView.swift
//  DogLike
//
//  Created by Lars Nicodemus on 09.12.24.
//

import SwiftUI

struct DogView: View {
    @ObservedObject var dogVM: DogViewModel
    @State var milestoneCounter: Int = 0
    @Binding var isNotificationLaunch: Bool

    var body: some View {
        VStack {

            if isNotificationLaunch {
                Text("Willkommen zurück!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .foregroundColor(.blue)
            }
            Spacer()

            Text(dogVM.breedName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)

            Spacer()

            if let dogImageURL = dogVM.dogImageURL {
                AsyncImage(url: dogImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 400)
            } else {
                ProgressView()
            }

            Spacer()

            HStack {
                Button(action: {
                    dogVM.dislikeAction()
                    milestoneCounter += 1

                }) {
                    Image(systemName: "hand.thumbsdown")
                        .font(.system(size: 50))
                }
                .padding()

                Button(action: {
                    dogVM.likeAction()
                    milestoneCounter += 1
                }) {
                    Image(systemName: "hand.thumbsup")
                        .font(.system(size: 50))
                }
                .padding()
            }
        }
        .onChange(of: milestoneCounter) { oldValue, newValue in
            if newValue > 0 && newValue % 10 == 0 {
                NotificationService.shared.scheduleMilestoneNotification(
                    milestoneCount: newValue)

            }
        }
        .onAppear {
            Task {
                if isNotificationLaunch {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                isNotificationLaunch = false
                                            }
                }
            }
        }
    }
}

#Preview {
    DogView(dogVM: DogViewModel(), isNotificationLaunch: .constant(true))
}
