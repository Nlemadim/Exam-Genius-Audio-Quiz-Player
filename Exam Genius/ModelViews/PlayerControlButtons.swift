//
//  PlayerControlButtons.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/21/24.
//

import SwiftUI

struct PlayerControlButtons: View {
    @Binding var isNowPlaying: Bool

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
                    imageLabel: "mic",
                    color: themeColor ?? .clear,
                    buttonAction: { repeatAction() })

                
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
                    buttonAction: { nextAction() })
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            
        }
    }
}

struct MiniPlayerControlButtons: View {
    @Binding var isNowPlaying: Bool

    var themeColor: Color?
    var repeatAction: () -> Void
    var playAction: () -> Void
    var nextAction: () -> Void
  
    var body: some View {
        VStack(spacing: 5) {
            
            HStack(spacing: 20) {
                // Repeat Button
                CircularButton(
                    isPlaying: .constant(false),
                    isDownloading: .constant(false),
                    imageLabel: "mic",
                    color: themeColor ?? .clear,
                    buttonAction: { repeatAction() })

                
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
                    buttonAction: { nextAction() })
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            
        }
    }
}

#Preview {
    MiniPlayerControlButtons(isNowPlaying: .constant(true), repeatAction: {}, playAction: {}, nextAction: {})
        .preferredColorScheme(.dark)
}


//#Preview {
//    PlayerControlButtons(isNowPlaying: .constant(true), repeatAction: {}, playAction: {}, nextAction: {})
//        .preferredColorScheme(.dark)
//}
