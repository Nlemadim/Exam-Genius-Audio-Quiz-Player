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
            self.interactionFeedbackMessage = "Starting a new quiz!"
      
        case .isCorrectAnswer:
            self.interactionFeedbackMessage = "\(self.currentQuestions[self.currentQuestionIndex].selectedOption) is correct"
            
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
            } else {
                playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseCallout)
            }
            
        case .isIncorrectAnswer:
            playCorrectionAudio()//Changes interaction to .nowPlayingCorrection
            
        case .isCorrectAnswer:
            proceedWithQuiz()
            //setContinousPlayInteraction(learningMode: true) // Changes to resumingPlayback OR pausedPlayback based on User LearningMode Settings
            
        case .playingFeedbackMessage:
            self.interactionState = interactionState
            
        case .errorTranscription:
            
            if !UserDefaultsManager.hasRecievedInvalidResponseAdvisory() {
                playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseUserAdvisory)
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
    
    //MARK: SCREEN TRANSITION OBSERVERS
    //MARK: QuizPlayer/Homepage+MiniPlayer QuizStatus Observer
    func handleQuizObserverInteractionStateChange(_ state: QuizPlayerState) {
        DispatchQueue.main.async {
            self.quizPlayerObserver.playerState = state
            switch state {
            case .startedPlayingQuiz:
                self.expandAction()
                self.presentationManager.interactionState = .isNowPlaying
            case .restartQuiz:
                self.resetQuizAndGetScore()
                //self.updateAudioQuizQuestions()
                
            default:
                break
            }
        }
    }
}
