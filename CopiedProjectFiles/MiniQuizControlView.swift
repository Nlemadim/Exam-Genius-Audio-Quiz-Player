//
//  MiniQuizControlView.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/25/24.
//

import SwiftUI

struct MiniQuizControlView: View {
    var recordAction: () -> Void
    var playPauseAction: () -> Void
    var nextAction: () -> Void
    var repeatAction: () -> Void
    @Binding var interactionState: InteractionState
    
    @State private var tappedPlay: Bool = false
    
    @State private var isUsingMic: Bool = UserDefaultsManager.isHandfreeEnabled()
    
    let imageSize: CGFloat = 18
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Image(systemName: isUsingMic ? "mic.fill" : "mic.slash")
                    .font(.headline)
                    .foregroundStyle(isUsingMic ? interactionState == .isListening ? .red : .orange : .gray)
                    .onTapGesture {
                        isUsingMic.toggle()
                    }
                Text(isUsingMic ? interactionState == .isListening ? "Listening" : "Ready" : "Off")
                    .font(.footnote)
            }
            .offset(y: 5)
            
            Button(action: {
                playPauseAction()
                tappedPlay.toggle()
            }) {
                Image(systemName: interactionState == .isNowPlaying || interactionState == .nowPlayingCorrection || interactionState == .playingFeedbackMessage || interactionState == .playingErrorMessage || interactionState == .resumingPlayback ? "pause.fill" : "play.fill")
                    .font(.title)
            }
            .sensoryFeedback(.start, trigger: tappedPlay)
            .disabled(interactionState == .isDownloading)
        }
        .foregroundStyle(interactionState == .isDownloading ? .gray : .white)
        .padding(.horizontal)
    }
    
    private func isActivePlay() -> Bool {
        let activeStates: [InteractionState] = [.isNowPlaying, .nowPlayingCorrection, .playingErrorMessage, .playingFeedbackMessage]
        return activeStates.contains(self.interactionState)
        
    }
    
}

#Preview {
    MiniQuizControlView(recordAction: {}, playPauseAction: {}, nextAction: {}, repeatAction: {}, interactionState: .constant(.isListening))
        .preferredColorScheme(.dark)
}




// Record Button with Progress Ring
//            ZStack {
//                // Background
//                Circle()
//                    .fill(Color.themePurple)
//                    .frame(width: imageSize * 3, height: imageSize * 3)
//
//                // Conditional display of Progress Ring
//                if showProgressRing {
//                    Circle()
//                        .stroke(Color.white.opacity(0.3), lineWidth: 5)
//                        .frame(width: imageSize * 3, height: imageSize * 3)
//
//                    Circle()
//                        .trim(from: 0, to: fillAmount)
//                        .stroke(Color.teal, lineWidth: 5)
//                        .frame(width: imageSize * 3, height: imageSize * 3)
//                        .rotationEffect(.degrees(-180))
//                        .animation(.linear(duration: 5), value: fillAmount)
//                }
//
//                // Mic Button
//                Button(action: {
//                    self.recordAction()
//                    self.startFilling()
//                }) {
//                    Image(systemName: "mic.fill")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                }
//            }
