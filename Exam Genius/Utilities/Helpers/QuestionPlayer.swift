//
//  QuestionPlayer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/23/24.
//

//import Foundation
//import SwiftUI
//import Combine
//import AVFoundation
//import Speech
//import AVKit

import SwiftUI
import Combine
import AVFoundation

class QuestionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    @Published var didFinishPlayingSuccessfully: Bool = false
    @Published var interactionState: InteractionState = .idle

    var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        configureAudioSession()
    }

    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    func playAudioFile(_ audioFile: String) {
        guard let fileURL = getDocumentDirectoryURL(for: audioFile) else {
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
        self.interactionState = .isNowPlaying
        isPlaying = true
    }

    private func getDocumentDirectoryURL(for fileName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.didFinishPlayingSuccessfully = flag
            self.interactionState = .isDonePlaying
        }
    }
}
