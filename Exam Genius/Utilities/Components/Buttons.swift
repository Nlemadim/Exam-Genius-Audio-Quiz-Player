//
//  BuildButton.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation
import SwiftUI

struct BuildButton: View {
    @State private var didTapButton = false
    let action: () -> Void
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            VStack(spacing: 5) {
                Image(systemName: "wand.and.stars.inverse")
                    .font(.body)
                    .foregroundColor(.teal)
                Text("Build")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(2)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.teal.opacity(0.6))
                    
                    )
            }
            .padding(5)
        })
        .foregroundStyle(.primary)
    }
}

struct DownloadAudioQuizButton: View {
    var buildProcesses: () -> Void
    var cancelDownload: () -> Void
    @Binding var isDownloading: Bool
    
    var body: some View {
        VStack {
            if isDownloading {
                Text("Downloading...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("This could take more than a minute")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Button("Download Audio Quiz") {
                buildProcesses()
            }
            .buttonStyle(CapsuleStrokeButtonStyle(isDisabled: isDownloading))
            .disabled(isDownloading)
            
            if isDownloading {
                Button(action: {
                    cancelDownload()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                .padding(.top, 5)
            }
        }
    }
}

struct LaunchQuizButton: View {
    @Binding var pressedPlay: Bool
    var startAudioQuiz: () -> Void
    var body: some View {
        Button("Start Audio Quiz") {
            startAudioQuiz()
        }
        
        .buttonStyle(CapsuleStrokeButtonStyle(isDisabled: pressedPlay, activeBackgroundColor: .teal.opacity(0.6)))
        .disabled(pressedPlay)
    }
}

struct CapsuleStrokeButtonStyle: ButtonStyle {
    var isDisabled: Bool
    var textColor: Color = .white
    var activeBackgroundColor: Color = .clear
    var activeBorderColor: Color = .white
    var disabledBackgroundColor: Color = Color.gray.opacity(0.5)
    var disabledBorderColor: Color = .gray
    var textFont: Font = .subheadline

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(textFont) // Use the specified font
            .foregroundColor(textColor) // Use the specified text color
            .padding() // Add some padding inside the capsule
            .background(
                Capsule() // Capsule shape
                    .strokeBorder(isDisabled ? disabledBorderColor : activeBorderColor, lineWidth: 1) // Stroke color based on disabled state
                    .background(
                        Capsule().fill(isDisabled ? disabledBackgroundColor : activeBackgroundColor) // Background color based on disabled state
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

#Preview {
    BuildButton(action: {})
}

#Preview {
    LaunchQuizButton(pressedPlay: .constant(false), startAudioQuiz: {})
        .preferredColorScheme(.dark)
}

#Preview {
    DownloadAudioQuizButton(buildProcesses: {}, cancelDownload: {}, isDownloading: .constant(true))
        .preferredColorScheme(.dark)
}

#Preview {
    DownloadAudioQuizButton(buildProcesses: {}, cancelDownload: {}, isDownloading: .constant(false))
        .preferredColorScheme(.dark)
}

