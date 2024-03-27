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
    
    private var speechRecognizer = SpeechManager()
    var cancellable: AnyCancellable?
    
    func recordAnswer() {
        startRecordingAndTranscribing()
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
            print("Listener published userTranscript as: \(self.userTranscript)")
        }
    }
    
    fileprivate func getTranscript() {
        cancellable = speechRecognizer.$transcript
            .sink { newTranscript in
                self.selectedOption = self.processTranscript(transcript: newTranscript)
            }
        
        self.userTranscript = self.selectedOption
    }
    
    func processTranscript(transcript: String) -> String {
        self.interactionState = .isProcessing
        let processedTranscript = WordProcessor.processWords(from: transcript)
        self.selectedOption = processedTranscript
        
        if processedTranscript.isEmptyOrWhiteSpace {
            interactionState = .errorResponse
            //MARK: TODO
            //playErrorTranscriptionSound()
        } else {
            interactionState = .successfulResponse
            //MARK: TODO
            //playSuccessFulTranscriptionSound()
        }
        
        interactionState = .idle
        return processedTranscript
    }
    
    deinit {
        cancellable?.cancel()
    }
}
