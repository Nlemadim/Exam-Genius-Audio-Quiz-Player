//
//  ResponseListener.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/23/24.
//

import Foundation
import SwiftUI
import Combine
import Speech
import AVKit

class ResponseListener: NSObject, ObservableObject, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate {
    @Published var isRecordingAnswer: Bool = false
    @Published var selectedOption: String = ""
    @Published var userTranscript: String = ""
    @Published var interactionState: InteractionState = .idle
    
    var cancellable: AnyCancellable?
    private var speechRecognizer = SpeechManager()
    private var retryCount = 0
    private let maxRetryCount = 2
    
    func recordAnswer() {
        startRecordingAndTranscribing()
    }
    
    func recordAnswerV2(answer options: [String]) {
        startRecordingAndTranscribingV2(answers: options)
    }
    
    fileprivate func startRecordingAndTranscribing() {
        interactionState = .isListening
        print("Starting transcription...")
        self.isRecordingAnswer = true
        
        // Immediately start transcribing
        self.speechRecognizer.transcribe()
        print("Transcribing started")
        
        // Schedule to stop transcribing after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.speechRecognizer.stopTranscribing()
            self.isRecordingAnswer = false
            print("Transcription stopped")
            
            self.getTranscript()
            
        }
    }
    
    fileprivate func getTranscript() {
        cancellable = speechRecognizer.$transcript
            .sink { newTranscript in
                self.selectedOption = self.processTranscript(transcript: newTranscript)
            }
        
        self.userTranscript = self.selectedOption
        print("Listener published userTranscript as: \(self.userTranscript)")
        self.interactionState = .hasResponded
        
    }
    
    fileprivate func processTranscript(transcript: String) -> String {
        //self.interactionState = .isProcessing
        let processedTranscript = WordProcessor.processWords(from: transcript)
        return processedTranscript
    }
    
    
    fileprivate func startRecordingAndTranscribingV2(answers options: [String]) {
        interactionState = .isListening
        print("Starting transcription...")
        self.isRecordingAnswer = true
        
        // Immediately start transcribing
        self.speechRecognizer.transcribe()
        print("Transcribing started")
        
        // Schedule to stop transcribing after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.speechRecognizer.stopTranscribing()
            self.isRecordingAnswer = false
            print("Transcription stopped")
            
            self.getTranscriptV2(answer: options)
            
        }
    }
    
    
    fileprivate func getTranscriptV2(answer options: [String]) {
        cancellable = speechRecognizer.$transcript
            .sink { newTranscript in
                self.selectedOption = self.processTranscriptV2(transcript: newTranscript, options: options)
            }
        
        self.userTranscript = self.selectedOption
        print("Listener published userTranscript as: \(self.userTranscript)")
        self.interactionState = .hasResponded
    }
    
    fileprivate func processTranscriptV2(transcript: String, options: [String]) -> String {
        //self.interactionState = .isProcessing
        let processedTranscript = WordProcessorV2.processWords(from: transcript, comparedWords: options)
        
        return processedTranscript
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        // This method is called when the speech recognizer successfully recognizes speech from the audio file.
        DispatchQueue.main.async {
            ///Automatically retrying recording after error transcription
    //        if !successfully && retryCount < maxRetryCount {
    //            DispatchQueue.main.async {
    //                self.interactionState = .errorTranscription
    //                self.speechRecognizer.reset()
    //                self.startRecordingAndTranscribing()
    //                self.retryCount += 1
    //            }
    //        }
    //
    //        if !successfully {
    //            self.interactionState = .errorTranscription
    //        }
        }
    }

    
    deinit {
        cancellable?.cancel()
    }
}
