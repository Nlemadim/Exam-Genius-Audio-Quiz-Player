//
//  AudioQuizPlayerView.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/20/24.
//

import SwiftUI

struct AudioQuizPlayerView: View  {
    @Binding var expandSheet: Bool
    
    @State var showText: Bool = false
    @State var isMuted: Bool = false
    @State private var offsetY: CGFloat = 0
    @State private var animateContent: Bool = false
    @State private var isNowPlaying: Bool = false
    
    let quizPlayer: QuizPlayer
    @EnvironmentObject var user: User
    
    @StateObject private var generator = ColorGenerator()
    var animation: Namespace.ID
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.black)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                            .fill(.clear)
                            .dynamicExactGradientBackground(startColor: generator.dominantBackgroundColor, endColor: .black)
                            .background(
                            
//                                Image(user.selectedQuizPackage?.imageUrl ?? "Logo")
//                                    .blur(radius: 100)
                            )
                            .opacity(animateContent ? 1 : 0)
                    })
                    .overlay(alignment: .top) {
                        AudioQuizPlayer(expandSheet: $expandSheet, animation: animation)
                        
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: user.audioQuizPackage?.imageUrl.uppercased() ?? "ICONIMAGE", in: animation)
                
                VStack(spacing: 5) {
                    /// Grab Indicator
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                    /// Matching with Sliding Animation
                        .offset(y: animateContent ? 0 : size.height)
                    
                    ScrollView(showsIndicators: false) {
                       
                        VStack(spacing: 12) {
                            //MARK: Player Content Image View (Hero View)
                            GeometryReader {
                                let size = $0.size
                                
                                Image(user.audioQuizPackage?.imageUrl ??  "IconImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: size.width, height: size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: animateContent ? 15 : 5, style: .continuous))
                                
                            }
                            .matchedGeometryEffect(id: "MAINICON", in: animation)
                            /// For Square Content View
                            .frame(height: size.width - 50)
                            /// Dynamically changing Padding for smaller devices
                            .padding(.vertical, size.height < 700 ? 10 : 30)
                            .opacity(!showText ? 1 : 0)
                                   
                            /// Playback Controls
//                            FullScreenControlView(
//                                isNowPlaying: isNowPlaying, quizPlayer: _,
//                                repeatAction: {},
//                                stopAction: { quizPlayer.endQuiz() },
//                                micAction: {},
//                                playAction: { quizPlayer.startQuiz() },
//                                nextAction: { quizPlayer.playNextQuestion()},
//                                endAction: { quizPlayer.resetForNextQuiz()})
                        }
                    }
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
                                    
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY > size.height * 0.3 {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            generator.updateAllColors(fromImageNamed: user.audioQuizPackage?.imageUrl ?? "IconImage")
            //generator.updateDominantColor(fromImageNamed: user.selectedQuizPackage?.imageUrl ?? "IconImage")
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
}
