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


class IntermissionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var feedbackPlayerState: InteractionState = .idle
    @Published var finishedPlayingFeedBack: Bool = false
    @Published var finishedPlayingEndQuizFeedBack: Bool = false
    @Published var finishedPlayingReview: Bool = false
    @Published var finishedPlayingErrorMessage: Bool = false
    
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
    
    func pausePlayback() {
        audioPlayer?.pause()
    }
    
    func stopAndResetPlayer() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
    
    private func resetPlayerStates() {
        self.feedbackPlayerState = .idle
        self.finishedPlayingFeedBack = false
        self.finishedPlayingEndQuizFeedBack = false
        self.finishedPlayingReview = false
        self.finishedPlayingErrorMessage = false
    }
    // Plays the bell sound indicating correct answer state.
    func playWrongAnswerBell() {
        play(soundNamed: "wrongAnswerBell")
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
    
    // Plays the bell sound indicating correct answer state.
    func playErrorTranscriptionBell() {
        play(soundNamed: "errorTranscriptionBell")
    }
    
    // Plays a sound from the specified file name.
    func play(soundNamed soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Sound file not found.")
            return
        }
        
        resetPlayerStates()
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
                
                if self.finishedPlayingEndQuizFeedBack {
                    //                    self.feedbackPlayerState = .reviewing
                    print(self.feedbackPlayerState)
                }
                
                if self.finishedPlayingReview {
                    self.feedbackPlayerState = .doneReviewing
                    print(self.feedbackPlayerState)
                }
                
                if self.finishedPlayingErrorMessage {
                    self.feedbackPlayerState = .donePlayingErrorMessage
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
            self.finishedPlayingReview = false
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
        
        DispatchQueue.main.async {
            self.finishedPlayingErrorMessage = true
            self.finishedPlayingReview = false
            self.finishedPlayingFeedBack = false
        }
        
        do {
            try startPlayback(from: fileURL)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
        }
    }
    
    func playEndQuizFeedBack(_ messageUrl: String) {
        guard let fileURL = getDocumentDirectoryURL(for: messageUrl) else {
            print("Invalid file path")
            return
        }
        
        DispatchQueue.main.async {
            self.finishedPlayingEndQuizFeedBack = true
            self.finishedPlayingReview = false
        }
        
        do {
            try startPlayback(from: fileURL)
        } catch {
            print("Could not load file: \(error.localizedDescription)")
        }
    }
    
    func playReviewFeedBack(_ messageUrl: String) {
        guard let fileURL = getDocumentDirectoryURL(for: messageUrl) else {
            print("Invalid file path")
            return
        }
        
        DispatchQueue.main.async {
            self.finishedPlayingReview = true
            self.finishedPlayingEndQuizFeedBack = false
            
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


//import AVFoundation
//import SwiftUI
//
//
//class IntermissionPlayerV2: NSObject, ObservableObject, AVAudioPlayerDelegate {
//    @Published var feedbackPlayerState: InteractionState = .idle
//    @Published var finishedPlayingFeedBack: Bool = false
//    @Published var finishedPlayingEndQuizFeedBack: Bool = false
//    @Published var finishedPlayingReview: Bool = false
//    @Published var currentPowerLevel: Float = 0.0  // Monitor power level
//
//    var audioPlayer: AVAudioPlayer?
//    var audioEngine: AVAudioEngine = AVAudioEngine()
//    var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
//
//    override init() {
//        super.init()
//        setupAudioEngine()
//    }
//
//    private func setupAudioEngine() {
//        audioEngine.attach(playerNode)
//        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
//
//        audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: audioEngine.mainMixerNode.outputFormat(forBus: 0)) { [weak self] buffer, _ in
//            self?.updatePowerLevel(buffer: buffer)
//        }
//
//        do {
//            try audioEngine.start()
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("Audio engine or session setup failed: \(error)")
//        }
//    }
//
//    private func updatePowerLevel(buffer: AVAudioPCMBuffer) {
//        let channelData = buffer.floatChannelData![0]
//        let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
//        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
//        let avgPower = 20 * log10(rms)
//        DispatchQueue.main.async {
//            self.currentPowerLevel = avgPower.isFinite ? avgPower : 0.0
//        }
//    }
//
//    func play(soundNamed soundName: String) {
//        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav"), let file = try? AVAudioFile(forReading: url) else {
//            print("Sound file not found.")
//            return
//        }
//
//        do {
//            audioPlayer?.stop()
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.delegate = self
//            audioPlayer?.volume = 1.0
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//            playerNode.scheduleFile(file, at: nil) { self.finishedPlayingFeedBack = true }
//            playerNode.play()
//        } catch {
//            print("Error loading or playing audio: \(error)")
//        }
//    }
//
//    func playWrongAnswerBell() { play(soundNamed: "wrongAnswerBell") }
//    func playCorrectBell() { play(soundNamed: "correctBell") }
//    func playListeningBell() { play(soundNamed: "softBell1") }
//    func playReceivedResponseBell() { play(soundNamed: "softBell2") }
//    func playErrorBell() { play(soundNamed: "errorBell1") }
//    func playErrorTranscriptionBell() { play(soundNamed: "errorTranscriptionBell") }
//
//    // Delegate methods to handle playback states
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        DispatchQueue.main.async {
//            self.updateStateOnFinish(success: flag)
//        }
//    }
//
//    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
//        print("Decode error occurred: \(String(describing: error))")
//    }
//
//    private func updateStateOnFinish(success: Bool) {
//        DispatchQueue.main.async {
//            if success {
//                if self.finishedPlayingFeedBack { self.feedbackPlayerState = .donePlayingFeedbackMessage }
//                if self.finishedPlayingEndQuizFeedBack { self.feedbackPlayerState = .endedQuiz }
//                if self.finishedPlayingReview { self.feedbackPlayerState = .doneReviewing }
//            }
//        }
//    }
//}
