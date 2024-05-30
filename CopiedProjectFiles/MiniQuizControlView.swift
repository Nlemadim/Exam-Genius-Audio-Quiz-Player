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
    let imageSize: CGFloat = 18
    
    var body: some View {
        HStack(spacing: 20) {
            // Repeat Button
//            Button(action: recordAction) {
//                Image(systemName: "mic.circle")
//                    .font(.title2)
//            }
            
            // Play/Pause Button
            Spacer()
            Button(action: {
                playPauseAction()
                tappedPlay.toggle()
                
            }) {
                Image(systemName: interactionState == .isNowPlaying || interactionState == .nowPlayingCorrection || interactionState == .playingFeedbackMessage || interactionState == .playingErrorMessage || interactionState == .resumingPlayback ? "pause.fill" : "play.fill")
                    .font(.title)
            }
            .sensoryFeedback(.start, trigger: tappedPlay)
        
            
            // Next Button
//            Button(action: nextAction) {
//                Image(systemName: "forward.end.fill")
//                    .font(.title2)
//            }
//            .sensoryFeedback(.selection, trigger: tappedPlay)
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
//        .onChange(of: interactionState) { _, _ in
//            if isActivePlay() == false {
//                tappedPlay = false
//            }
//        }
    }
    
    private func isActivePlay() -> Bool {
        let activeStates: [InteractionState] = [.isNowPlaying, .nowPlayingCorrection, .playingErrorMessage, .playingFeedbackMessage]
        return activeStates.contains(self.interactionState)
        
    }
    
}

#Preview {
    MiniQuizControlView(recordAction: {}, playPauseAction: {}, nextAction: {}, repeatAction: {}, interactionState: .constant(.idle))
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
