//
//  QuestionPlayer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/23/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import Speech
import AVKit

class QuestionPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate {
    @Published var interactionState: InteractionState = .idle
    @Published var isFinishedPlaying: Bool = false
    @Published var isNowPlaying: Bool = false
    @Published var currentIndex: Int = 0
    
    var audioPlayer: AVAudioPlayer?
    var speechSynthesizer = AVSpeechSynthesizer()
    var cancellable: AnyCancellable?
    var audioFiles: [String] = []
    
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
    
    func playAudioQuestions(audioFile: [String], currentNumber: Int) {
        interactionState = .isNowPlaying
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adding a slight delay
            self.audioFiles.append(contentsOf: audioFile)
            self.playAudioFileAtIndex(currentNumber)
        }
    }
    
    func playSingleAudioQuestion(audioFile: String) {
        interactionState = .isNowPlaying
        print("Question Player is now playing audioFile at: \(audioFile)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  // Adding a slight delay
            self.playQuestionAudioFile(audioFile)
        }
    }
    
    private func playQuestionAudioFile(_ audioFile: String) {
        let path = audioFile
        
        guard let fileURL = URL(string: path) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay() // Prepare the player
            audioPlayer?.play()
        } catch {
            print("Could not load file: \(error)")
        }
    }
    
    private func playAudioFileAtIndex(_ index: Int) {
        guard index < audioFiles.count else {
            return
        }
        
        let path = audioFiles[index]
        guard let fileURL = URL(string: path) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay() // Prepare the player
            audioPlayer?.play()
        } catch {
            print("Could not load file: \(error)")
        }
    }
    
    func readQuestionContent(questionContent: String) {
        let utterance = AVSpeechUtterance(string: questionContent)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // You can change the language here
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // You can adjust the speech rate
        
        interactionState = .isNowPlaying
        speechSynthesizer.speak(utterance)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag {
            DispatchQueue.main.async {
                self.interactionState = .isDonePlaying
                self.audioPlayer?.stop()
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
