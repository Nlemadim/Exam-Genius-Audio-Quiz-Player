//
//  VUMeterView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/5/24.
//

import SwiftUI

import SwiftUI
import Combine

struct VUMeterView: View {
    @Binding var interactionState: InteractionState
    @State private var randomScales: [CGFloat] = Array(repeating: 0.01, count: 6)
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            ForEach(randomScales.indices, id: \.self) { index in
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 4, height: 16) // Constant height for all bars
                    .scaleEffect(y: randomScales[index], anchor: .bottom)
                    .animation(.linear(duration: 0.3), value: randomScales[index])
            }
        }
        .onReceive(timer) { _ in
            if interactionState == .isNowPlaying {
                // Randomize the scale for each bar to simulate activity
                withAnimation {
                    randomScales = randomScales.map { _ in CGFloat.random(in: 0.1...1.0) }
                }
            } else {
                // Reset the scale to minimum when not playing
                withAnimation {
                    randomScales = Array(repeating: 0.01, count: 6)
                }
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

#Preview {
    VUMeterView(interactionState: .constant(.isNowPlaying))
        .preferredColorScheme(.dark)
}
