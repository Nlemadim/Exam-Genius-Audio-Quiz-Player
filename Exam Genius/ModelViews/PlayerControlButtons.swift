//
//  PlayerControlButtons.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/21/24.
//

import SwiftUI

struct PlayerControlButtons: View {
    @State var isNowPlaying: Bool

    var quizPlayer = QuizPlayer.shared
    var themeColor: Color?
    var repeatAction: () -> Void
    var playAction: () -> Void
    var nextAction: () -> Void
  
    var body: some View {
        VStack(spacing: 5) {
            
            HStack(spacing: 30) {
                // Repeat Button
                CircularButton(
                    isPlaying: .constant(false),
                    isDownloading: .constant(false),
                    imageLabel: "arrow.clockwise",
                    color: themeColor ?? .clear,
                    playAction: { repeatAction() })

                
                CircularPlayButton(
                    isPlaying: $isNowPlaying,
                    isDownloading: .constant(false),
                    color: themeColor ?? .clear,
                    playAction: { playAction() }
                )
                
                // Next/End Button
                CircularButton(
                    isPlaying: .constant(false),
                    isDownloading: .constant(false),
                    imageLabel: "forward.end.fill",
                    color: themeColor ?? .clear,
                    playAction: { repeatAction() })
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            
        }
    }
}


#Preview {
    PlayerControlButtons(isNowPlaying: false, repeatAction: {}, playAction: {}, nextAction: {})
        .preferredColorScheme(.dark)
}
