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

struct TestView: View {
    @StateObject var intermissionPlayer = IntermissionPlayer()

    var body: some View {
        VStack {
            Button("Start Listening") {
                intermissionPlayer.playListeningBell()
            }

            Button("Mark Success") {
                intermissionPlayer.playReceivedResponseBell()            }
        }
    }
}

#Preview {
    TestView()
        .preferredColorScheme(.dark)
}


class IntermissionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
        configureAudioSession()
    }
    
    // Configures the audio session for playback.
    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    // Plays the bell sound indicating correct answer state.
    func playCorrectBell() {
        play(soundNamed: "correctBell")
    }

    // Plays the bell sound indicating listening state.
    func playListeningBell() {
        play(soundNamed: "softBell1")
    }

    // Plays the bell sound indicating a successful response.
    func playReceivedResponseBell() {
        play(soundNamed: "softBell2")
    }
    
    func playErrorBell() {
        play(soundNamed: "errorBell1")
    }

    // Plays a sound from the specified file name.
    func play(soundNamed soundName: String) {
            guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
                print("Sound file not found.")
                return
            }

            // Ensure the audio session is correctly configured each time a sound is played
            configureAudioSession()  // This call can be placed here to ensure the session is active and configured each time.

            do {
                audioPlayer?.stop()  // Stop any currently playing audio
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = 1.0
                audioPlayer?.play()
            } catch {
                print("Could not load file: \(error)")
            }
        }
        

    // AVAudioPlayerDelegate method for handling playback completion.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            // Handle any cleanup or UI updates here if needed.
        }
    }

    // AVAudioPlayerDelegate method for handling decoding errors.
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        DispatchQueue.main.async {
            print("Decode error occurred: \(String(describing: error))")
        }
    }
}

