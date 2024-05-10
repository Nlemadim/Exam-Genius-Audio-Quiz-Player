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
        self.interactionState = .isNowPlaying
        expandSheet = true
        presentationManager.expandSheet = true
        presentationManager.interactionState = .isNowPlaying
        configuration.interactionState = self.interactionState
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
        self.intermissionPlayer.stopAndResetPlayer()
        self.audioContentPlayer.stopAndResetPlayer()
        self.questionPlayer.stopAndResetPlayer()
        currentQuestionIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            playSingleQuizQuestion()
        }
    }
    
    func playQuizReview() {
        //let reviewUrl = await fetchQuizReview(review: scoreReadout())
        DispatchQueue.main.async {
            intermissionPlayer.playReviewFeedBack(scoreReadout())
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
            
            playEndQuizFeedbackMessage(feedbackMessageUrls?.quizEndingMessage)
            self.currentQuestionIndex = 0
            self.interactionState = .reviewing
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                playQuizReview()
            }
        }
    }
    
    func playMode() {
        if self.quizPlayerObserver.playerState == .pausedCurrentPlay {
            resumeQuiz()
        }
        
        if self.quizPlayerObserver.playerState == .startedPlayingQuiz {
            playPauseStop()
        }
    }
    
    
    
    
    func playPauseStop() {
        stopAllAudio()
        let index = self.currentQuestionIndex
        let state = self.interactionState
        
        if state == .idle {
            expandAction()
        }
        
        if isActivePlay() {
            pauseQuiz(currentIndex: index)
        }
        
        if isFullScreenPlayerMode && isActivePlay() {
            pauseQuiz(currentIndex: index)
        }
        
        if !isFullScreenPlayerMode && state == .idle {
            startQuizAudioPlay()
        }
    }
    
    func resumeQuiz() {
        DispatchQueue.main.async {
            loadPlayerPositions()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                playSingleQuizQuestion()
            }
        }
    }
    
    //MARK: TODO Continuity Methods
    func pauseQuiz(currentIndex: Int) {
        stopAllAudio()
        DispatchQueue.main.async {
            UserDefaultsManager.updateCurrentPosition(currentIndex)
            UserDefaultsManager.updateCurrentScoreStreak(correctAnswerCount: self.correctAnswerCount)
            self.interactionState = .pausedPlayback
        }
    }
    
    func stopAllAudio() {
        self.intermissionPlayer.stopAndResetPlayer()
        self.audioContentPlayer.stopAndResetPlayer()
        self.questionPlayer.stopAndResetPlayer()
    }
    
    func continueFromPause(state: InteractionState) {
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
    
    func playEndQuizReview() {
        playQuizReview()
    }
    
    //MARK: Direct Click Action Methods.
    //MARK: Show Full Screen Method
    func expandAction() {
        guard selectedQuizPackage != nil else { return }
        UserDefaultsManager.updateCurrentQuizStatus(inProgress: true)
        startQuizAudioPlay()
    }
    
    var isFullScreenPlayerMode: Bool {
        if expandSheet == true && presentationManager.expandSheet == true {
            return true
        }
        
        return false
    }
    
    //MARK: Dismiss Full Screen Method
    func dismissAction() {
        resetQuizAndGetScore()
        self.interactionState = .idle
        configuration.interactionState = self.interactionState
        currentQuestionIndex = 0
        UserDefaultsManager.updateCurrentPosition(currentQuestionIndex)
        UserDefaultsManager.updateCurrentQuizStatus(inProgress: false)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.quizPlayerObserver.playerState = .endedQuiz
            self.presentationManager.expandSheet = false
            self.presentationManager.interactionState = .idle
            self.expandSheet = false
        }
    }
}
