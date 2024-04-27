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
                intermissionPlayer.playCorrectBell()
            }

            Button("Mark Success") {
                intermissionPlayer.playWrongAnswerBell()            }
        }
    }
}

#Preview {
    TestView()
        .preferredColorScheme(.dark)
}


class IntermissionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var feedbackPlayerState: InteractionState = .idle
    @Published var finishedPlayingFeedBack: Bool = false
    
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
    func playWrongAnswerBell() {
        self.feedbackPlayerState = .idle
        self.finishedPlayingFeedBack = false
        play(soundNamed: "wrongAnswerBell")
    }
    
    // Plays the bell sound indicating correct answer state.
    func playCorrectBell() {
        self.feedbackPlayerState = .idle
        self.finishedPlayingFeedBack = false
        play(soundNamed: "correctBell")
    }

    // Plays the bell sound indicating listening state.
    func playListeningBell() {
        self.feedbackPlayerState = .idle
        self.finishedPlayingFeedBack = false
        play(soundNamed: "softBell1")
    }

    // Plays the bell sound indicating a successful response.
    func playReceivedResponseBell() {
        self.feedbackPlayerState = .idle
        self.finishedPlayingFeedBack = false
        play(soundNamed: "softBell2")
    }
    
    func playErrorBell() {
        self.feedbackPlayerState = .idle
        self.finishedPlayingFeedBack = false
        play(soundNamed: "errorBell1")
    }
    
    // Plays the bell sound indicating correct answer state.
    func playErrorTranscriptionBell() {
        self.feedbackPlayerState = .idle
        self.finishedPlayingFeedBack = false
        play(soundNamed: "errorTranscriptionBell")
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
            if flag  {
                if self.finishedPlayingFeedBack {
                    self.feedbackPlayerState = .donePlayingFeedbackMessage
                    print(self.feedbackPlayerState)
                }
            }
        }
    }

    // AVAudioPlayerDelegate method for handling decoding errors.
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        DispatchQueue.main.async {
            print("Decode error occurred: \(String(describing: error))")
        }
    }
    
    func playVoiceFeedBack(_ messageUrl: String) {
        guard let fileURL = getDocumentDirectoryURL(for: messageUrl) else {
            print("Invalid file path")
            return
        }
        
        DispatchQueue.main.async {
            self.finishedPlayingFeedBack = true
            self.feedbackPlayerState = .playingFeedbackMessage
        }
        
        do {
            try startPlayback(from: fileURL)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
        }
    }
    
    func playErrorVoiceFeedBack(_ messageUrl: String) {
        guard let fileURL = getDocumentDirectoryURL(for: messageUrl) else {
            print("Invalid file path")
            return
        }
        
        do {
            try startPlayback(from: fileURL)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
        }
    }

    private func startPlayback(from fileURL: URL) throws {
        if AVAudioSession.sharedInstance().category != .playback {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }

        audioPlayer?.stop()
        audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
        audioPlayer?.delegate = self
        audioPlayer?.volume = 1.0
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }

    private func getDocumentDirectoryURL(for fileName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
}


