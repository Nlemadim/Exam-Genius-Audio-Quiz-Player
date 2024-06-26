//
//  SpeechManager.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/23/24.
//

import Foundation
import SwiftUI
import Speech

class SpeechManager: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
                
            }
        }
    }
    
    @Published var transcript: String = ""
    
    public var isRecording = false
    
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    private var audioSession: AVAudioSession!
    private var inputNode: AVAudioInputNode!
    private var audioEngine: AVAudioEngine?
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    init() {
        //MARK TODO: Dynamically Pass in Locale Identifier based on phone settings
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                listenForError(error)
            }
        }
    }
    
    deinit {
        reset()
    }
    
    /**
     Begin transcribing audio.
     
     Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopTranscribing()`.
     The resulting transcription is continuously written to the published `transcript` property.
     */
    func transcribe() {
        DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.listenForError(RecognizerError.recognizerIsUnavailable)
                return
            }
            
            do {
                let (audioEngine, recognitionRequest) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.recognitionRequest = recognitionRequest
                
                self.task = recognizer.recognitionTask(with: recognitionRequest) { result, error in
                    let receivedFinalResult = result?.isFinal ?? false
                    let receivedError = error != nil // != nil mean there's error (true)
                    
                    if receivedFinalResult || receivedError {
                        audioEngine.stop()
                        audioEngine.inputNode.removeTap(onBus: 0)
                    }
                    
                    if let result = result {
                        self.listenForAnswer(result.bestTranscription.formattedString)
                    }
                }
            } catch {
                self.reset()
                self.listenForError(error)
            }
        }
    }
    
    func transcribe2() {
        DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
            guard let self = self else { return }
            guard let recognizer = self.recognizer, recognizer.isAvailable else {
                self.listenForError(RecognizerError.recognizerIsUnavailable)
                return
            }

            // Check if the recognizer supports on-device recognition
            if recognizer.supportsOnDeviceRecognition {
                do {
                    let (audioEngine, recognitionRequest) = try Self.prepareEngine()
                    // Set the recognition request to require on-device processing
                    recognitionRequest.requiresOnDeviceRecognition = true
                    self.audioEngine = audioEngine
                    self.recognitionRequest = recognitionRequest
                    
                    self.task = recognizer.recognitionTask(with: recognitionRequest) { result, error in
                        if let error = error {
                            // Handle the error specifically if on-device recognition fails
                            self.listenForError(error)
                            return
                        }
                        
                        if let result = result, result.isFinal {
                            self.listenForAnswer(result.bestTranscription.formattedString)
                            audioEngine.stop()
                            audioEngine.inputNode.removeTap(onBus: 0)
                        }
                    }
                } catch {
                    self.listenForError(error)
                }
            } else {
                // Handle the scenario where on-device recognition is not supported
                self.listenForError(RecognizerError.recognizerIsUnavailable)
            }
        }
    }


    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    /// Stop transcribing audio.
    func stopTranscribing() {
        reset()
    }
    
    private func listenForAnswer(_ message: String) {
            transcript = message
    }
    
    private func listenForError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
    }
 
    func reset() {
        task?.cancel()
        audioEngine?.stop()
        
        audioEngine = nil
        recognitionRequest = nil
        task = nil
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

