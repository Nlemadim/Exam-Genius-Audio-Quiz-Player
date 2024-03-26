//
//  QuizPlayer.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/22/24.
//

import Foundation
import SwiftUI
import Combine
import SwiftData
import AVFoundation
import Speech
import AVKit

protocol QuizPlayerDelegate: AnyObject {
    func quizPlayerDidFinishPlaying(_ player: QuizPlayer)
}

class QuizPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate {
    @EnvironmentObject var user: User
    @Published var progress: CGFloat = 0
    @Published var score: CGFloat = 0
    @Published var currentIndex: Int = 0
    @Published var userTranscript: String = ""
    @Published var playlist: [String: String] = [:]
    @Published var isFinishedPlaying: Bool = false
    @Published var isRecordingAnswer: Bool = false
    @Published var isNowPlaying: Bool = false
    @Published var selectedOption: String = ""
    @Published var interactionState: InteractionState = .idle
    @Published var playerState: PlayerState = .idle
    @State var isUingMic: Bool = false
    
    weak var delegate: QuizPlayerDelegate?
    
    private var speechRecognizer = SpeechManager()
    
    private var speechSynthesizer = AVSpeechSynthesizer()
    var audioPlayer: AVAudioPlayer?
    
    var currentPlaybackQueue: [String] = []
    var cancellable: AnyCancellable?
    var showScoreCard: Bool = false
    var announceScoreCard: Bool = false
    var completionHandler: (() -> Void)?
    var audioFiles: [String] = []
    
    static let shared = QuizPlayer()
    
    private override init() {
        super.init()
        configureAudioSession()
    }
    
    var examQuestions: [Question] {
        return user.selectedQuizPackage?.questions ?? []
    }
    
    var currentQuestion: Question? {
        guard currentIndex < examQuestions.count else { return nil }
        
        return examQuestions[currentIndex]
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
    
    
    func playSampleQuiz(audioFileNames: [String]) {
        guard !audioFileNames.isEmpty else { return }
        interactionState = .isNowPlaying
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adding a slight delay
            self.audioFiles = audioFileNames
            self.currentIndex = 0
            self.playAudioFileAtIndex(self.currentIndex)
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
//            self.isFinishedPlaying = false
//            self.isNowPlaying = true // Ensure this triggers UI updates correctly
            return
        }
        
        let path = audioFiles[index]
        guard let fileURL = URL(string: path) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true) // Ensure the session is active
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay() // Prepare the player
            audioPlayer?.play()
        } catch {
            print("Could not load file: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Player has Finished playing")
        if flag {
            self.isNowPlaying = false
            self.isFinishedPlaying = true
        }
    }
    
    func quizPlayerDidFinishPlaying(completion: @escaping (Bool) -> Void) {
        self.cancellable = Future<Bool, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                promise(.success(true))
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] finished in
            self?.isFinishedPlaying = finished
            completion(finished)
        }
    }
    
    // Method to play a specific audio file immediately
    func playNow(audioFileName: String) {
        playerState = .isPlayingQuestion
        // Start playing the audio file
        //playAudio(audioFileName: audioFileName)
        
    }
    
//    fileprivate func playAudio(audioFileName: String) {
//        interactionState = .isNowPlaying
//        
//        let path = audioFileName
//        guard let fileURL = URL(string: path) else { return }
//        
////        let fileManager = FileManager.default
////        let url = URL(fileURLWithPath: audioFileName)
//        
//        do {
//            try AVAudioSession.sharedInstance().setActive(true) // Ensure the session is active
//            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
//            audioPlayer?.delegate = self
//            audioPlayer?.prepareToPlay() // Prepare the player
//            audioPlayer?.play()
//        } catch {
//            print("Could not load file: \(error)")
//            ///Use Siri in case of error
//            //readQuestionContent(questionContent: audioFileName)
//        }
//    }
      
    fileprivate func checkSelectedOptionAndUpdateState() {
        if UserDefaultsManager.isOnContinuousFlow() /* && !selectedOption.isEmpty */{
            // Proceed to the next audio file
            print("Playing next Question")
            playNextQuestion()
        } else {
            // Wait for user interaction to proceed
            //interactionState = .awaitingResponse
            audioPlayer?.stop()
            playerState = .isPaused
            print("Player paused while awaiting response")
        }
        
    }
    
    //UI TESTING
    func readQuestionContent(questionContent: String) {
        let utterance = AVSpeechUtterance(string: questionContent)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // You can change the language here
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // You can adjust the speech rate
        
        speechSynthesizer.speak(utterance)
        
        print(utterance)
    }
    
    //MARK: Recording Methods
//    func recordAnswer() {
//        interactionState = .isListening
//        startRecordingAndTranscribing()
//    }
//    
//    fileprivate func startRecordingAndTranscribing() {
//        guard interactionState == .isListening else { return }
//        
//        print("Starting transcription...")
//        self.isRecordingAnswer = true
//        playerState = .isAwaitingAnswer
//        
//        // Immediately start transcribing
//        self.speechRecognizer.transcribe()
//        print("Transcribing started")
//        
//        // Schedule to stop transcribing after 5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.speechRecognizer.stopTranscribing()
//            self.isRecordingAnswer = false
//            print("Transcription stopped")
//            
//            // Optionally, retrieve and process the transcript after stopping
//            self.getTranscript { newTranscript in
//                self.selectedOption = self.processTranscript(transcript: newTranscript)
//                self.interactionState = .hasResponded
//                print("Processing completed")
//                
//                // Further processing or state update can be done here
//                self.checkSelectedOptionAndUpdateState()
//            }
//        }
//    }
//    
//    
//    fileprivate func getTranscript(completion: @escaping (String) -> Void) {
//        cancellable = speechRecognizer.$transcript
//            .sink { newTranscript in
//                completion(newTranscript)
//            }
//    }
//    
//    func processTranscript(transcript: String) -> String {
//        interactionState = .isProcessing
//        let processedTranscript = WordProcessor.processWords(from: transcript)
//        self.selectedOption = processedTranscript
//        
//        if processedTranscript.isEmptyOrWhiteSpace {
//            playerState = .failureTranscribingAnswer
//            interactionState = .errorResponse
//            //MARK: TODO
//            //playErrorTranscriptionSound()
//        } else {
//            playerState = .successTranscribingAnswer
//            interactionState = .successfulResponse
//            //MARK: TODO
//            //playSuccessFulTranscriptionSound()
//        }
//        
//        return processedTranscript
//    }
    
    deinit {
        cancellable?.cancel()
    }
}

/* fileprivate func startRecordingAndTranscribing() {
 self.isRecordingAnswer = true
 // Wait for 5-7 seconds for transcribed answer
 DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
 self.speechRecognizer.transcribe()
 }
 
 // After transcribing, stop transcription and turn off recording
 DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
 self.speechRecognizer.stopTranscribing()
 self.isRecordingAnswer.toggle()
 }
 }
 
 func getTranscript(completion: @escaping (String) -> Void) {
 cancellable = speechRecognizer.$transcript
 .sink { newTranscript in
 completion(newTranscript)
 self.currentQuestion?.selectedOption = newTranscript
 }
 }*/




