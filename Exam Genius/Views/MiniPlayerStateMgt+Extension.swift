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
            self.interactionFeedbackMessage = "Incorrect!\nThe correct option is \(self.currentQuestions[self.currentQuestionIndex].correctOption)"
        
        case .nowPlayingCorrection:
            self.interactionFeedbackMessage = self.currentQuestions[self.currentQuestionIndex].questionNote
            
        case .donePlayingFeedbackMessage:
            self.interactionFeedbackMessage = "Moving on..."
            
        case .reviewing:
            self.interactionFeedbackMessage = scoreReadout()
            
            
        case.pausedPlayback:
            self.interactionFeedbackMessage = "Resume?"
            
        default:
            break
        }
    }
    
    
    func syncInteractionState(_ interactionState: InteractionState) {
        DispatchQueue.main.async {
            
            switch interactionState {
                
            case .isDonePlaying://Triggered by QuestionPlayer/
                intermissionPlayer.playListeningBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    prepareResponseInterface()
                    //executeResponseSequence()
                }

            case .hasResponded: //Triggered by response Listener & Options Button after recording or selecting answer
                intermissionPlayer.playReceivedResponseBell()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.interactionState = .successfulResponse
                    }
                
            case .noResponse: //Triggered by response Listener & Options Button after recording or selecting answer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .noResponse
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
            //startRecordingAnswer() //Changes interaction to .isListening
            startRecordingAnswerV2(answer: currentQuestions[currentQuestionIndex].options)
        
        case .successfulResponse:
            executeSuccessfulResponseSequence()
            //analyseResponse()//Changes interaction to .isProcessing -> isCorrectAnswer OR isIncCorrectAnswer Or .errorResponse
            
        case .resumingPlayback:
            //self.interactionState = .idle
           proceedWithQuiz()//Changes interaction to .nowPlaying
            
        case .errorResponse:
            executeErrorResponseSequence()
            
        case .isIncorrectAnswer:
            executeIncorrectAnswerSequence()//Changes interaction to .nowPlayingCorrection or .resuming
            
        case .playingFeedbackMessage:
            self.interactionState = interactionState
            
        case .noResponse:
            executeErrorResponseSequence()
            
        case .awaitingResponse:
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                self.interactionState = .successfulResponse
            }
            
        case .endedQuiz:
            dismissAction()
            
        default:
            break
       
        }
    }
    
    func updateConfigurationState(interactionState: InteractionState) {
        configuration.interactionState = interactionState
        let activeStates: [InteractionState] = [.isNowPlaying, .nowPlayingCorrection, .playingErrorMessage, .playingFeedbackMessage]
        configuration.isSpeaking = activeStates.contains(interactionState)
    }
    
    //Mark Modify method to check quiz Mode. Read answer, proceed to next question or stop
    private func processQuizFlow() {
        let isContinousPlayback = UserDefaultsManager.isContinousPlayEnabled()
        //MARK: TODO - Conditional check for continous playback
        if isContinousPlayback {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.interactionState = .resumingPlayback
            }
        } else {
            stopAllAudio()
            self.interactionState = .pausedPlayback
        }
    }
    
    private func prepareResponseInterface() {
        self.globalTimer.interactionState = .countingDownResponseTimer
    }
    
    private func executeResponseSequence() {
        selectResponsePresenter()
        let isHandsfreeEnabled = UserDefaultsManager.isHandfreeEnabled()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if isHandsfreeEnabled  {
                self.interactionState = .isListening
            } else {
                self.interactionState = .awaitingResponse
            }
        }
    }
    
    func selectResponsePresenter() {
        DispatchQueue.main.async {
            if expandSheet   {
                self.presentMiniModal = false
            } else if !expandSheet && quizPlayerObserver.playerState == .startedPlayingQuiz || quizPlayerObserver.playerState == .pausedCurrentPlay {
                self.presentMiniModal = true
            }
        }
    }
    
    func presentResponseInterface(_ interactionState: InteractionState) {
        if interactionState == .countingDownResponseTimer {
            executeResponseSequence()
        }
    }
    
    private func prepareForResponse() {
        DispatchQueue.main.async {
            self.interactionState = .countingDownResponseTimer 
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
            case .startedPlayingQuiz:
                updateCurrentQuestions(configuration.currentQuizPackage)
                self.expandAction()
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
