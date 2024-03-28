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
        audioPlayer?.stop()
        audioPlayer = nil
        interactionState = .isNowPlaying
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.playQuestionAudioFile(audioFile)
            print("Question Player is now playing audioFile at: \(audioFile)")
        }
    }

    
    private func playQuestionAudioFile(_ audioFile: String) {
        //        let path = audioFile
        //
        //        guard let fileURL = URL(string: path) else {
        //            print("Invalid file URL for audio file: \(audioFile)")
        //            return
        //        }
        
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(audioFile)
        
        do {
            // Attempt to configure and activate the audio session if not already in the desired state.
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.category != .playback || audioSession.mode != .default {
                try audioSession.setCategory(.playback, mode: .default)
                try audioSession.setActive(true)
            }
            
            // Stop and nil out the current player before initializing a new one.
            audioPlayer?.stop()
            audioPlayer = nil
            
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Could not load file: \(error.localizedDescription)")
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
        DispatchQueue.main.async {
            if flag {
                self.interactionState = .isDonePlaying
            } else {
                // Handle unsuccessful playback if needed
                print("Playback finished unsuccessfully")
            }
            self.audioPlayer?.stop()
            self.audioPlayer = nil // Proper cleanup
        }
    }
}
