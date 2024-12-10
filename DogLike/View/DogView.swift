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
    @State var likeAnimationTrigger: Bool = false
    @State var dislikeAnimationTrigger: Bool = false
    @State var breednameTr: Bool = false


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
                .font(breednameTr ? .system(size: 60) : .largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        breednameTr.toggle()
                    }
                }

            Spacer()

            if let dogImageURL = dogVM.dogImageURL {
                AnimatedAsyncImage(url: dogImageURL)
            } else {
                ProgressView()
            }
            
            Spacer()

            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        dislikeAnimationTrigger = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dislikeAnimationTrigger = false
                    }
                    dogVM.dislikeAction()
                    milestoneCounter += 1
                }) {
                    Image(systemName: "hand.thumbsdown")
                        .font(.system(size: 50))
                        .foregroundColor(
                            dislikeAnimationTrigger ? .red : .primary
                        )
                        .scaleEffect(dislikeAnimationTrigger ? 1.4 : 1.0)
                        .rotationEffect(
                            dislikeAnimationTrigger
                                ? .degrees(-15) : .degrees(0)
                        )
                        .opacity(dislikeAnimationTrigger ? 0.8 : 1.0)
                        .animation(
                            .spring(
                                response: 0.4, dampingFraction: 0.5,
                                blendDuration: 0.5),
                            value: dislikeAnimationTrigger)
                }
                .padding()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        likeAnimationTrigger = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        likeAnimationTrigger = false
                    }
                    dogVM.likeAction()
                    milestoneCounter += 1
                }) {
                    Image(systemName: "hand.thumbsup")
                        .font(.system(size: 50))
                        .foregroundColor(
                            likeAnimationTrigger ? .green : .primary
                        )
                        .scaleEffect(likeAnimationTrigger ? 1.4 : 1.0)
                        .rotationEffect(
                            likeAnimationTrigger ? .degrees(15) : .degrees(0)
                        )
                        .opacity(likeAnimationTrigger ? 0.8 : 1.0)
                        .animation(
                            .spring(
                                response: 0.4, dampingFraction: 0.5,
                                blendDuration: 0.5), value: likeAnimationTrigger
                        )
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


struct AnimatedAsyncImage: View {
    let url: URL?
    
    @State private var scale: CGFloat = 0.1
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 400)
                .cornerRadius(20)
                .shadow(radius: 10)
                .scaleEffect(scale)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: scale)
                .onAppear {
                    scale = 1.0
                }
        } placeholder: {
            ProgressView()
        }
        .frame(width: 300, height: 400)
        .onChange(of: url) { oldValue, newValue in
            scale = 0.6
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                scale = 1.0
            }
        }
    }
}
