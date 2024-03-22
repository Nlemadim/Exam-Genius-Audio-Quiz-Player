//
//  FullScreenControlView.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/25/24.
//

import SwiftUI

//struct FullScreenControlView: View {
//    @State var isNowPlaying: Bool
//    @EnvironmentObject var quizPlayer: QuizPlayer
//    var repeatAction: () -> Void
//    var stopAction: () -> Void
//    var micAction: () -> Void
//    var playAction: () -> Void
//    var nextAction: () -> Void
//    var endAction: () -> Void
//
//    var body: some View {
//        VStack(spacing: 5) {
//            
////            InteractionVisualizer(comment: quizPlayer.currentQuestion?.selectedOption ?? "", correctOption: quizPlayer.currentQuestion?.correctOption ?? "", interactionState: quizPlayer.interactionState, quizPlayer: quizPlayer)
//            
//            HStack(spacing: 30) {
//                // Repeat Button
//                Button(action: repeatAction) {
//                    Image(systemName: "memories")
//                        .font(.title)
//                        .foregroundColor(.themePurple)
//                        
//                }
//
//                // Stop Button
//                Button(action: stopAction) {
//                    Image(systemName: "stop.fill")
//                        .font(.title)
//                        .foregroundColor(.themePurple)
//                       
//                }
//
//                // Mic Button with Progress Ring
//                MicButtonWithProgressRing(action: {
//                   // quizPlayer.recordAnswer()
//                })
//
//                // Play/Pause Button
//                Button(action: {
//                    //quizPlayer.startQuiz()
//                }) {
//                    Image(systemName: isNowPlaying ?  "pause.fill" : "play.fill")
//                        .font(.title)
//                        .foregroundColor(.themePurple)
//                }
//
//                // Next/End Button
//                Button(action:  {
//                    
//                }) {
//                    Image(systemName: "forward.end.fill")
//                        .font(.title)
//                        .foregroundColor(.themePurple)
//                        
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .frame(height: 100) // Adjust as needed
//            
//            HStack(spacing: 20){
//                //Quiz Content Text View Toggle Button
//                Button {
//                    //showText.toggle()
//                } label: {
//                    Image(systemName: "rectangle.and.hand.point.up.left")
//                        .foregroundStyle(.white)
//                        .padding(12)
//                        .background {
//                            Circle()
//                                .fill(.themePurple)
//                                .environment(\.colorScheme, .light)
//                        }
//                }
//                
//                
//                //Mute Button
//                Button {
//                   // isMuted.toggle()
//                } label: {
//                    Image(systemName: !isNowPlaying ? "speaker.slash.fill" : "speaker")
//                        .foregroundStyle(.white)
//                        .padding(12)
//                        .background {
//                            Circle()
//                                .fill(.themePurple)
//                                .environment(\.colorScheme, .light)
//                        }
//                }
//            }
//        }
//    }
//}
//
//struct MicButtonWithProgressRing: View {
//    @State private var fillAmount: CGFloat = 0.0
//    @State private var showProgressRing: Bool = false
//    let action: () -> Void
//
//    let imageSize: CGFloat = 25 // Adjusted size
//
//    var body: some View {
//        ZStack {
//            // Background
//            Circle()
//                .fill(Color.themePurple)
//                .frame(width: imageSize * 3, height: imageSize * 3)
//
//            // Conditional display of Progress Ring
//            if showProgressRing {
//                Circle()
//                    .stroke(Color.white.opacity(0.3), lineWidth: 5)
//                    .frame(width: imageSize * 3, height: imageSize * 3)
//
//                Circle()
//                    .trim(from: 0, to: fillAmount)
//                    .stroke(Color.red, lineWidth: 8)
//                    .frame(width: imageSize * 3, height: imageSize * 3)
//                    .rotationEffect(.degrees(-180))
//                    .animation(.linear(duration: 5), value: fillAmount)
//            }
//
//            // Mic Button
//            Button(action: {
//                self.action()
//                self.startFilling()
//            }) {
//                Image(systemName: "mic.fill")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//            }
//        }
//    }
//
//    private func startFilling() {
//        fillAmount = 0.0 // Reset the fill amount
//        showProgressRing = true // Show the progress ring
//        withAnimation(.linear(duration: 5)) {
//            fillAmount = 1.0 // Fill the ring over 5 seconds
//        }
//        // Hide the progress ring after 5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.showProgressRing = false
//        }
//    }
//}
//
//#Preview {
//    FullScreenControlView(isNowPlaying: true, repeatAction: {}, stopAction: {}, micAction: {}, playAction: {}, nextAction: {}, endAction: {})
//        .preferredColorScheme(.dark)
////    @StateObject var quizPlayer = QuizPlayer()
////    return FullScreenControlView(isNowPlaying: true, quizPlayer: quizPlayer, repeatAction: {}, stopAction: {}, micAction: {}, playAction: {}, nextAction: {}, endAction: {})
////        .preferredColorScheme(.dark)
//}
