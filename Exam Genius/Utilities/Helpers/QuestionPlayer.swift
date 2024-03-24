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
    
    func playAudioQuestion(audioFile: String) {
        interactionState = .isNowPlaying
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adding a slight delay
            self.audioFiles.append(audioFile)
            self.currentIndex = 0
            self.playAudioFileAtIndex(self.currentIndex)
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
    
//    func playQuestion(audioFileName: String) {
//        self.isFinishedPlaying = false
//        if interactionState == .isNowPlaying {
//            audioPlayer?.stop()
//            print("Stopped current playback")
//            playAudio(audioFileName: audioFileName)
//            isNowPlaying = true
//        } else {
//            playAudio(audioFileName: audioFileName)
//        }
//    }
    
    func readQuestionContent(questionContent: String) {
        let utterance = AVSpeechUtterance(string: questionContent)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // You can change the language here
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // You can adjust the speech rate
        
        interactionState = .isNowPlaying
        speechSynthesizer.speak(utterance)
    }
    
//    fileprivate func playAudio(audioFileName: String) {
//        let path = audioFileName
//        guard let fileURL = URL(string: path) else { return }
//        
//        do {
//            try AVAudioSession.sharedInstance().setActive(true) 
//            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
//            audioPlayer?.delegate = self
//            audioPlayer?.prepareToPlay() // Prepare the player
//            interactionState = .isNowPlaying
//            audioPlayer?.play()
//            print("Player is now playing")
//            
//        } catch {
//            print("Could not load file: \(error)")
//            ///Use Siri in case of error
//            //readQuestionContent(questionContent: audioFileName)
//        }
//    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag {
            audioPlayer?.stop()
            interactionState = .idle
            isFinishedPlaying = true
            isNowPlaying = false
            print("Player is now idle")
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
