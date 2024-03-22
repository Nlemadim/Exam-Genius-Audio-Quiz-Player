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
    
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false
    @State private var tappedPlay: Bool = false
    let imageSize: CGFloat = 18
    
    var body: some View {
        HStack(spacing: 20) {
            // Repeat Button
            Button(action: repeatAction) {
                Image(systemName: "memories")
                    .font(.title2)
            }
            
            // Play/Pause Button
            Button(action: {
                playPauseAction()
                tappedPlay.toggle()
                
            }) {
                Image(systemName: tappedPlay ? "pause.fill" : "play.fill")
                    .font(.title2)
            }
            
            // Next Button
            Button(action: nextAction) {
                Image(systemName: "forward.end.fill")
                    .font(.title2)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
    }
    
    private func startFilling() {
        fillAmount = 0.0 // Reset the fill amount
        showProgressRing = true // Show the progress ring
        withAnimation(.linear(duration: 5)) {
            fillAmount = 1.0 // Fill the ring over 5 seconds
        }
        // Hide the progress ring after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showProgressRing = false
        }
    }
}

#Preview {
    MiniQuizControlView(recordAction: {}, playPauseAction: {}, nextAction: {}, repeatAction: {})
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
