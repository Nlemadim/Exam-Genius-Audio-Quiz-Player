//
//  MiniPlayerControls.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/31/24.
//

import SwiftUI

struct QuizControlConfiguration {
    let selectA: () -> Void
    let selectB: () -> Void
    let selectC: () -> Void
    let selectD: () -> Void
    let selectPlay: () -> Void
    let selectReplay: () -> Void
    let selectNext: () -> Void
    var playerState: PlayerState = .idle
    var isUsingMic: Bool = false
}

enum PlayerState {
    case idle
    case quizStarted
    case isPlayingQuestion
    case isAwaitingAnswer
    case hasRecievedAnswer
    case successTranscribingAnswer
    case failureTranscribingAnswer
    case isPaused
    case quizEnded
}

struct MiniPlayerControls: View {
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false
    var controlConfiguration: QuizControlConfiguration
    let imageSize: CGFloat = 18
    
    var body: some View {
        HStack(spacing: 3) { // Adjust spacing as needed
            Button(action: {
                controlConfiguration.selectA()
            }, label: {
                Text("A")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 40, height: 25)
                    .background(RoundedRectangle(cornerRadius: 10)
                    .fill(buttonDisabled ? .gray : .teal))
                    .padding(.horizontal)
            }).disabled(buttonDisabled)
            
            Spacer(minLength: 0)
            
            Button(action: {
                controlConfiguration.selectB()
            }, label: {
                Text("B")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 40, height: 25)
                    .background(RoundedRectangle(cornerRadius: 10)
                    .fill(buttonDisabled ? .gray : .teal))
                    .padding(.horizontal)
            }).disabled(buttonDisabled)
            
            Spacer(minLength: 0)
            
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 70, height: 70)
                .offset(y: -10)
                .overlay {
                    StartButton(configuration: controlConfiguration.playerState, isUsingMic: controlConfiguration.isUsingMic, action: {
                        controlConfiguration.selectPlay()
                    })
                    .offset(y: -10)

                }
            

            
            Spacer(minLength: 0)

            Button(action: {
                controlConfiguration.selectC()
            }, label: {
                Text("C")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 40, height: 25)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(buttonDisabled ? .gray : .teal))
                    .padding(.horizontal)
            }).disabled(buttonDisabled)
            
            Spacer(minLength: 0)
            
            Button(action: {
                controlConfiguration.selectB()
            }, label: {
                Text("D")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 40, height: 25)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(buttonDisabled ? .gray : .teal))
                    .padding(.horizontal)
            }).disabled(buttonDisabled)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.teal)
    }
    
    var buttonDisabled: Bool { controlConfiguration.playerState != .isAwaitingAnswer }
}
#Preview {
   @State var configuration: PlayerState = .idle
    return StartButton(configuration: configuration, isUsingMic: false, action: {})
       // .preferredColorScheme(.dark)
}

#Preview {
    let user = User()
    let player = QuizPlayer.shared
    return MiniPlayerControls(controlConfiguration: player.controlConfiguration)
        .environmentObject(user)
        .environmentObject(player)
}

struct StartButton: View {
    @State var configuration: PlayerState
    @State var isUsingMic: Bool
    var action: () -> Void
    @State var isAwaitingAnswer: Bool = false
//    var isAwaitingAnswer: Bool {
//        configuration == .isAwaitingAnswer
//    }
    @State private var progress: CGFloat = 0.0
    let fillUpDuration = 5.0

    var body: some View {
        Button(action: {
            isAwaitingAnswer.toggle()
            action()
            if isAwaitingAnswer {
                // Start the animation to fill the progress ring
                withAnimation(.linear(duration: fillUpDuration)) {
                    progress = 1.0
                }
                // Schedule the reset after the fillUpDuration
                DispatchQueue.main.asyncAfter(deadline: .now() + fillUpDuration) {
                    //isFilling = false // Reset filling state
                    progress = 0.0 // Reset progress
                }
            }
        }) {
            ZStack {
                Circle()
                    .strokeBorder(Color.gray.opacity(0.5), lineWidth: 4)
                    .frame(width: 67, height: 67)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 4, lineCap: .round)).activeGlow(.orange, radius: 1)
                    .rotationEffect(.degrees(-270))
                    .frame(width: 65, height: 65)
                    .shadow(color: .orange, radius: 20)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.teal).activeGlow(.white, radius: 2)
                    .overlay {
                        Text("START")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.themePurple)
                            //.padding(.horizontal)
                    }
                    .opacity(configuration == .idle ? 1 : 0)
                
                Circle()
                    .frame(width: 65, height: 65)
                    .foregroundColor(.white).activeGlow(.white, radius: 2)
                    .overlay {
                        Image(systemName: isAwaitingAnswer ? isUsingMic ? "mic.fill" : "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.black)
                            
                    }
                    .opacity(configuration != .idle ? 1 : 0)
            }
        }
       // .disabled(true)
        
    }
}

