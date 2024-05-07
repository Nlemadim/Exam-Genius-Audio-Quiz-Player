//
//  MiniPlayer+AudioPlay+Extension.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/6/24.
//

import Foundation
import SwiftUI

extension MiniPlayerV2 {
    //MARK: STEP 1: Quiz Entry Point - Now Playing
    func startQuizAudioPlay() {
        configuration.interactionState = self.interactionState
        presentationManager.interactionState = self.interactionState
        expandSheet = true
        presentationManager.expandSheet = true
        quizPlayerObserver.playerState = .startedPlayingQuiz
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playSingleQuizQuestion()
        }
    }
    
    //MARK: STEP 1: Quiz Entry Point - Now Playing Method
    private func playSingleQuizQuestion() {
        // Access the current quiz package safely
        guard let package = configuration.currentQuizPackage else {
            print("Mini Player error: No quiz package currently selected")
            return
        }
        
        guard !package.questions.isEmpty else {
            print("Mini Player error: No available questions in the package")
            return
        }

        let questions = package.questions
        currentQuestions = questions
        print("Current MiniPlayer Questions Postloading is: \(self.currentQuestions.count)")
        
        let currentlyPlayingQuestion = self.currentQuestions[currentQuestionIndex]
        let audioFile = currentlyPlayingQuestion.questionAudio
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            questionPlayer.playAudioFile(audioFile)
            
        }
    }
    
    func goToNextQuestion() {
        currentQuestionIndex += 1
        playSingleQuizQuestion()
    }
    
    func playQuizReview() async {
        let reviewUrl = await fetchQuizReview(review: scoreReadout())
        DispatchQueue.main.async {
            intermissionPlayer.playReviewFeedBack(reviewUrl)
        }
    }
    
    func playCorrectionAudio() {
        DispatchQueue.main.async {
            self.interactionState = .nowPlayingCorrection
            let correctionAudio = currentQuestions[currentQuestionIndex].questionNoteAudio
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                audioContentPlayer.playAudioFile(correctionAudio)
            }
        }
    }
    
    //MARK: Step 2 Processes - Continue Playing Method
    private func continuePlaying() {
        print("Continuation Condition Met")
        
        let currentQuestion = self.currentQuestions[currentQuestionIndex]
        let audioFile = currentQuestion.questionAudio
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.interactionState = .isNowPlaying
            questionPlayer.playAudioFile(audioFile)
        }
    }
    
    //MARK: Step 2 Processes - Continue Playing Logic
    func proceedWithQuiz() {
        self.currentQuestionIndex += 1
        
        if currentQuestions.indices.contains(currentQuestionIndex) {
            self.continuePlaying()
            
        } else {
            interactionFeedbackMessage = "Quiz Complete!. Calculating score..."
            playEndQuizFeedbackMessage(feedbackMessageUrls?.endMessage)
            self.currentQuestionIndex = 0
            self.interactionState = .reviewing
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                Task {
                    await playQuizReview()
                }
            }
        }
    }
    
    func playPauseStop() {
        let index = self.currentQuestionIndex
        let state = self.interactionState
        let commonStates: [InteractionState] = [.isNowPlaying, .playingErrorMessage, .playingFeedbackMessage]
        
        if state == .idle {
            DispatchQueue.main.async {
                self.interactionState = .isNowPlaying
                if isFullScreenPlayerMode {
                    
                    playSingleQuizQuestion()
                    
                } else {
                    
                    startQuizAudioPlay()
                }
            }
        }
        
        if state == .pausedPlayback {
            continueFromPause(state: state)
        }
        
        if commonStates.contains(state) {
            pauseQuiz(currentIndex: index)
        }
    }
    
    //MARK: TODO Continuity Methods
    func pauseQuiz(currentIndex: Int) {
        DispatchQueue.main.async {
            UserDefaultsManager.updateCurrentPosition(currentIndex)
            self.intermissionPlayer.stopAndResetPlayer()
            self.audioContentPlayer.stopAndResetPlayer()
            self.questionPlayer.stopAndResetPlayer()
            self.interactionState = .pausedPlayback
        }
    }
    
    func continueFromPause(state: InteractionState) {
        loadPlayerPositions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            playSingleQuizQuestion()
        }
    }
    
    func playFeedbackMessage(_ messageUrl: String?) {
        if let feedbackMessageUrl = messageUrl {
            //intermissionPlayer.play(soundNamed: feedbackMessageUrl)
            intermissionPlayer.playVoiceFeedBack(feedbackMessageUrl)
            DispatchQueue.main.async {
                self.interactionState = .playingFeedbackMessage
            }
        }
    }
    
    func playErrorFeedbackMessage(_ messageUrl: String?) {
        if let feedbackMessageUrl = messageUrl {
            //intermissionPlayer.play(soundNamed: feedbackMessageUrl)
            intermissionPlayer.playErrorVoiceFeedBack(feedbackMessageUrl)
            DispatchQueue.main.async {
                self.interactionState = .playingFeedbackMessage
            }
        }
    }
    
    func playEndQuizFeedbackMessage(_ messageUrl: String?) {
        if let feedbackMessageUrl = messageUrl {
            intermissionPlayer.playEndQuizFeedBack(feedbackMessageUrl)
            
        }
    }
    
    func playEndQuizReview() async {
        await playQuizReview()
    }
    
    //MARK: Direct Click Action Methods.
    //MARK: Show Full Screen Method
    func expandAction() {
        guard selectedQuizPackage != nil else { return }
        self.interactionState = .isNowPlaying
        configuration.interactionState = self.interactionState
        presentationManager.interactionState = self.interactionState
        presentationManager.expandSheet = true
        playSingleQuizQuestion()
    }
    
    var isFullScreenPlayerMode: Bool {
        if expandSheet == true && presentationManager.expandSheet == true {
            return true
        }
        
        return false
    }
    
    //MARK: Dismiss Full Screen Method
    func dismissAction() {
        presentationManager.interactionState = .idle
        self.interactionState = .idle
        currentQuestionIndex = 0
        quizPlayerObserver.playerState = .endedQuiz
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presentationManager.expandSheet = false
            expandSheet = false
        }
    }
    
}
