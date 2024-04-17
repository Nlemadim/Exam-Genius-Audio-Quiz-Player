//
//  IntermissionPlayer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/17/24.
//

import Foundation
import AVFoundation
import Combine
import SwiftUI

class IntermissionPlayer: ObservableObject {
    @Published var interactionState: InteractionState = .idle {
        didSet {
            handleStateChange()
        }
    }
    var audioPlayer: AVAudioPlayer?
    private var cancellables = Set<AnyCancellable>()

    init(state: InteractionState) {
        self.interactionState = state
    }

    private func handleStateChange() {
        switch interactionState {
        case .isListening:
            playListeningBell()
        case .successfulResponse:
            playReceivedResponseBell()
        default:
            break
        }
    }

    func playListeningBell() {
        play(soundNamed: "softBell1")
    }

    func playReceivedResponseBell() {
        play(soundNamed: "softBell2")
    }

    private func play(soundNamed soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Sound file not found.")
            return
        }

        do {
            audioPlayer?.stop()  // Stop any currently playing audio
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("Could not load file: \(error)")
        }
    }
}


struct TestView: View {
    @StateObject var intermissionPlayer = IntermissionPlayer(state: .idle)

    var body: some View {
        VStack {
            Button("Start Listening") {
                intermissionPlayer.interactionState = .isListening
            }

            Button("Mark Success") {
                intermissionPlayer.interactionState = .successfulResponse
            }
        }
    }
}

#Preview {
    TestView()
        .preferredColorScheme(.dark)
}
