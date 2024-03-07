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
    @State var shouldDisplay: Bool = false
    @State var buttonText: String = "Download Audio Quiz"
    @Binding var isDownloading: Bool
    
    var body: some View {
        ZStack {
            
            Button(buttonText) {
                buildProcesses()
            }
            .buttonStyle(CapsuleStrokeButtonStyle(isDisabled: isDownloading, activeBackgroundColor: .teal.opacity(0.6)))
            .disabled(isDownloading)
            
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
    var activeGlow: Bool?
    var activeGlowColor: Color?
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(textFont) // Use the specified font
            .foregroundColor(textColor) // Use the specified text color
            .padding(8) // Add some padding inside the capsule
            .background(
                Capsule() // Capsule shape
                    .strokeBorder(isDisabled ? disabledBorderColor : activeBorderColor, lineWidth: 1)
                    .activeGlow(activeGlow ?? false ? activeBorderColor : .clear, radius: 1)// Stroke color based on disabled state
                
                    .background(
                        Capsule().fill(isDisabled ? disabledBackgroundColor : activeBackgroundColor) // Background color based on disabled state
                        
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        
    }
}


struct CapsuleButton: View {
    let defaultLabel: String
    let actionLabel: String?
    let defaultColor: Color
    let actionColor: Color
    let borderColor: Color?
    let imageName: String?
    let action: () -> Void
    
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            self.action()
            self.isPressed.toggle()
        }) {
            HStack {
                Text(isPressed && actionLabel != nil ? actionLabel! : defaultLabel)
                    .font(.caption2)
                    .fontWeight(.medium)
                
                
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
            }
            .padding(3)
            .foregroundColor(.white)
            .background(isPressed ? actionColor : defaultColor)
            .cornerRadius(3)
        }
        .buttonStyle(CapsuleStrokeButtonStyle(isDisabled: isPressed, activeBackgroundColor: .clear, activeBorderColor: borderColor ?? .teal, disabledBackgroundColor: .clear, disabledBorderColor: .clear, activeGlow: true, activeGlowColor: .teal))
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}

struct SpinnerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(lineWidth: 2)
            .foregroundStyle(.teal)
            .frame(width: 20, height: 20)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear() {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.isAnimating = true
                }
            }
    }
}

struct PlaySampleButton: View {
    @Binding var isDownloading: Bool
    @Binding var isPlaying: Bool
    var playAction: () -> Void
    
    var body: some View {
        Button(action: {
            if !isDownloading && !isPlaying {
                playAction() 
            }
        }) {
            HStack {
                Text(isPlaying ? "Playing" : "Play Sample")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                // Conditionally display icon based on buttonState
                if isDownloading {
                    SpinnerView() // Your custom spinner view
                        .frame(width: 20, height: 20)
                    
                } else if !isPlaying {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .foregroundStyle(.white)
        }
    }
    
}

enum ButtonState {
    case `default`, loading, playing
}

#Preview {
    PlaySampleButton(isDownloading: .constant(false), isPlaying: .constant(false), playAction: {})
        .preferredColorScheme(.dark)
}




#Preview {
    CapsuleButton(defaultLabel: "Build Audio Quiz", actionLabel: nil, defaultColor: .clear, actionColor: .clear, borderColor: nil, imageName: nil, action: {})
        .preferredColorScheme(.dark)
}



#Preview {
    BuildButton(action: {})
}


#Preview {
    DownloadAudioQuizButton(buildProcesses: {}, isDownloading: .constant(true))
        .preferredColorScheme(.dark)
}

#Preview {
    DownloadAudioQuizButton(buildProcesses: {}, isDownloading: .constant(false))
        .preferredColorScheme(.dark)
}

