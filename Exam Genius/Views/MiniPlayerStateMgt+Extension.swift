//
//  MiniPlayerStateMgt+Extension.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/2/24.
//

import Foundation
import SwiftUI

extension MiniPlayerV2 {
        
    func updateFeedbackMessage(_ interactionState: InteractionState) {
        switch interactionState {
        case .isNowPlaying:
            self.interactionFeedbackMessage = transcript
            
        case .errorTranscription:
            self.interactionFeedbackMessage = "Transcription Error!"
            
        case .errorResponse:
            self.interactionFeedbackMessage = "Invalid Response"
            
        case .isListening:
            self.interactionFeedbackMessage = transcript
            
        case .idle:
            self.interactionFeedbackMessage = "Start"
      
        case .isCorrectAnswer:
            self.interactionFeedbackMessage = "\(self.selectedOption) is correct"
            
        case .isIncorrectAnswer:
            self.interactionFeedbackMessage = "Incorrect!\n The correct option is \(self.currentQuestions[self.currentQuestionIndex].correctOption)"
        
        case .nowPlayingCorrection:
            self.interactionFeedbackMessage = self.currentQuestions[self.currentQuestionIndex].questionNote
            
        case .donePlayingFeedbackMessage:
            self.interactionFeedbackMessage = "Moving on..."
            
        case .reviewing:
            self.interactionFeedbackMessage = "Calculating your score"
            
        case.doneReviewing:
            self.interactionFeedbackMessage = scoreReadout()
            
        case.pausedPlayback:
            self.interactionFeedbackMessage = "Resume?"
            
        default:
            break
        }
    }
    
    func updateConfigurationState(interactionState: InteractionState) {
        configuration.interactionState = interactionState
        let activeStates: [InteractionState] = [.isNowPlaying, .nowPlayingCorrection, .playingErrorMessage, .playingFeedbackMessage]
        configuration.isSpeaking = activeStates.contains(interactionState)
    }
    
    func syncInteractionState(_ interactionState: InteractionState) {
        DispatchQueue.main.async {
            
            switch interactionState {
                
            case .isDonePlaying://Triggered by QuestionPlayer/
                self.startPlaying = false
                intermissionPlayer.playListeningBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .isListening
                }

            case .hasResponded: //Triggered by response Listener after recording answer
                intermissionPlayer.playReceivedResponseBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .successfulResponse
                }
            
            case .isDonePlayingCorrection: //Triggered by audioContentPlayer after Feedback play
                self.intermissionPlayer.playErrorTranscriptionBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .resumingPlayback
                }
                
            case .donePlayingFeedbackMessage: //Triggered by intermissionPlayer after Feedback play
                self.intermissionPlayer.playErrorTranscriptionBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .resumingPlayback
                }

            case .donePlayingErrorMessage: //Triggered by intermissionPlayer after error message play
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .resumingPlayback
                }
                
            case .doneReviewing: //Triggered by intermissionPlayer after reviewing play
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .endedQuiz
                    dismissAction()
                }
                
            default:
                break
            }
        }
    }
    
    
    func interactionStateAction(_ interactionState: InteractionState) {
        print("iteractionStateAction is acting on \(interactionState) state")
        switch interactionState {
       
        case .isListening:
            startRecordingAnswer() //Changes interaction to .isListening
            //startRecordingAnswerV2(answer: currentQuestions[currentQuestionIndex].options)
        
        case .successfulResponse:
            analyseResponse()//Changes interaction to .isProcessing -> isCorrectAnswer OR isIncCorrectAnswer Or .errorResponse
            
        case .resumingPlayback:
            //self.interactionState = .idle
           proceedWithQuiz()//Changes interaction to .nowPlaying
            
        case .errorResponse:
            if !UserDefaultsManager.hasRecievedInvalidResponseAdvisory() {
                playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseUserAdvisory)
                UserDefaultsManager.updateRecievedInvalidResponseAdvisory()
            } else {
                playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseCallout)
            }
            
        case .isIncorrectAnswer:
            playCorrectionAudio()//Changes interaction to .nowPlayingCorrection
            
//        case .isCorrectAnswer:
//            proceedWithQuiz()
            //setContinousPlayInteraction(learningMode: true) // Changes to resumingPlayback OR pausedPlayback based on User LearningMode Settings
            
        case .playingFeedbackMessage:
            self.interactionState = interactionState
            
        case .errorTranscription:
            
            if !UserDefaultsManager.hasRecievedInvalidResponseAdvisory() {
                playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseUserAdvisory)
                UserDefaultsManager.updateRecievedInvalidResponseAdvisory()
            } else {
                playErrorFeedbackMessage(feedbackMessageUrls?.errorTranscriptionCallout)
            }
             // Changes to .playingFeedback
            //MARK: TODO - Create Method to check for repeat listen settings
            
        case .endedQuiz:
            dismissAction()
            
        default:
            break
       
        }
    }
    
//    func miniPlayerStateAction(_ playerState: MiniPlayerState) {
//        switch playerState {
//        case .minimized:
//            expandSheet = false
//            presentationManager.expandSheet = false
//            
//        case .expanded:
//            expandSheet = true
//            presentationManager.expandSheet = true
//            
//        case .isActive:
//            DispatchQueue.main.async {
//                enterActiveState()
//            }
//            
//        case .isInActive:
//            DispatchQueue.main.async {
//                enterInActiveState()
//            }
//        }
//    }
    
    //MARK: SCREEN TRANSITION OBSERVERS
    //MARK: QuizPlayer/Homepage+MiniPlayer QuizStatus Observer
    func handleQuizObserverInteractionStateChange(_ state: QuizPlayerState) {
        DispatchQueue.main.async {
            self.quizPlayerObserver.playerState = state
            switch state {
//            case .startedPlayingQuiz:
//                self.expandAction()
//                self.presentationManager.interactionState = .isNowPlaying
            case .restartQuiz:
                self.resetQuizAndGetScore()
//                //self.updateAudioQuizQuestions()
//            case .pausedCurrentPlay:
//                self.enterInActiveState()
                
            default:
                break
            }
        }
    }
    
    func switchActiveState() {
        if self.miniPlayerState == .isActive {
            self.miniPlayerState = .isInActive
        }
        
        if self.miniPlayerState == .isInActive {
            self.miniPlayerState = .isActive
        }
    }
    
    func enterInActiveState() {
        stopAllAudio()
        self.quizPlayerObserver.playerState = .pausedCurrentPlay
        UserDefaultsManager.updateCurrentPosition(self.currentQuestionIndex)
        UserDefaultsManager.updateCurrentScoreStreak(correctAnswerCount: self.correctAnswerCount)
        self.interactionState = .pausedPlayback
        
    }
    
    func enterActiveState() {
        guard selectedQuizPackage != nil else { return }
        let currentPos = UserDefaultsManager.currentPlayPosition()
        self.currentQuestionIndex = currentPos
        UserDefaultsManager.updateCurrentQuizStatus(inProgress: true)
        
        expandSheet = true
        presentationManager.expandSheet = true
        self.interactionState = .isNowPlaying
        presentationManager.interactionState = .isNowPlaying
        configuration.interactionState = self.interactionState
        startQuizAudioPlay()
    }
}
