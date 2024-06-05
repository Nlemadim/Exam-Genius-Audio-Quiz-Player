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
        quizPlayerObserver.playerState = .startedPlayingQuiz
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playSingleQuizQuestion()
        }
    }
    
    private func playQuestionAtIndex(index: Int) {
        guard currentQuestions.indices.contains(index) else {
            print("Error. Index out of range: Question Count\(self.currentQuestions.count) - CurrentIndex: \(self.currentQuestionIndex)")
            return
        }
        
        let currentlyPlayingQuestion = self.currentQuestions[index]
        
        let audioFile = currentlyPlayingQuestion.questionAudio
        guard !audioFile.isEmptyOrWhiteSpace else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            questionPlayer.playAudioFile(audioFile)
            self.interactionState = .isNowPlaying
            self.presentationManager.interactionState = .isNowPlaying
        }
    }
    
    //MARK: STEP 1: Quiz Entry Point - Now Playing Method
    func playSingleQuizQuestion() {
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
        
        guard currentQuestions.indices.contains(self.currentQuestionIndex) else {
            print("Error. Index out of range: Question Count\(self.currentQuestions.count) - CurrentIndex: \(self.currentQuestionIndex)")
            return
        }
        
        let currentlyPlayingQuestion = self.currentQuestions[self.currentQuestionIndex]
        
        let audioFile = currentlyPlayingQuestion.questionAudio
        guard !audioFile.isEmptyOrWhiteSpace else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            questionPlayer.playAudioFile(audioFile)
            self.interactionState = .isNowPlaying
            self.presentationManager.interactionState = .isNowPlaying
        }
    }
    
    func goToNextQuestion() {
        guard currentQuestions.indices.contains(self.currentQuestionIndex) else { return }
        
        currentQuestionIndex += 1
        
        print("Question Count\(self.currentQuestions.count) / CurrentIndex: \(self.currentQuestionIndex)")
        
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
    
    func executeIncorrectAnswerSequence() {
        if self.isQandA {
            playCorrectionAudio()
        } else {
            self.intermissionPlayer.playErrorTranscriptionBell()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.interactionState = .resumingPlayback
            }
        }
    }
    
    func executeErrorResponseSequence() {
        if !UserDefaultsManager.hasRecievedInvalidResponseAdvisory() {
            playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseUserAdvisory)
            UserDefaultsManager.updateRecievedInvalidResponseAdvisory()
        } else {
            playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseCallout)
        }
    }
    
//    func executeErrorTranscriptionSequence() {
//        if !UserDefaultsManager.hasRecievedInvalidResponseAdvisory() {
//            playErrorFeedbackMessage(feedbackMessageUrls?.invalidResponseUserAdvisory)
//            UserDefaultsManager.updateRecievedInvalidResponseAdvisory()
//        } else {
//            playErrorFeedbackMessage(feedbackMessageUrls?.errorTranscriptionCallout)
//        }
//    }
    
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
  
    
    func proceedWithQuiz() {
        // Add a guard statement to check if the currentQuestionIndex is less than or equal to the count of currentQuestions - 1
        print("\(currentQuestionIndex)")
        print("\(currentQuestions.count)")
        guard currentQuestionIndex + 1 <= currentQuestions.count - 1 else {
            DispatchQueue.main.async {
                self.interactionFeedbackMessage = "Quiz Complete!. Calculating score..."
            }
            playEndQuizFeedbackMessage(feedbackMessageUrls?.quizEndingMessage)
            //self.currentQuestionIndex = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.interactionState = .reviewing
                playQuizReview()
            }
            return
        }

        // If the guard condition is met, proceed with the quiz
        DispatchQueue.main.async {
            print("proceedWithQuiz func proceeding... CurrentIndex at: \(self.currentQuestionIndex)")
            self.currentQuestionIndex += 1
            print("proceedWithQuiz func has moved Local index to: \(self.currentQuestionIndex)")
            self.playQuestionAtIndex(index:  self.currentQuestionIndex)
        }
    }

    
    
    //MARK: TODO Continuity Methods
    func pauseQuiz(currentIndex: Int) {
        DispatchQueue.main.async {
            stopAllAudio()
//            UserDefaultsManager.updateCurrentPosition(currentIndex)
//            UserDefaultsManager.updateCurrentScoreStreak(correctAnswerCount: self.correctAnswerCount)
//            self.interactionState = .pausedPlayback
//            self.quizPlayerObserver.playerState = .pausedCurrentPlay
        }
    }
    
    func debugReset() {
//        UserDefaultsManager.updateCurrentPosition(0)
//        UserDefaultsManager.updateCurrentScoreStreak(correctAnswerCount: 0)
//        UserDefaultsManager.updateCurrentQuizStatus(inProgress: false)
    }
    
    func stopAllAudio() {
        self.intermissionPlayer.stopAndResetPlayer()
        self.audioContentPlayer.stopAndResetPlayer()
        self.questionPlayer.stopAndResetPlayer()
        self.configuration.isSpeaking = false
        self.interactionState = .idle
    }
    
//    func continueFromPause(state: InteractionState) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            playSingleQuizQuestion()
//        }
//    }
    
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
        expandSheet = true
        configuration.interactionState = self.interactionState
        startQuizAudioPlay()
    }
    
    func startOrContinue() {
        if interactionState == .pausedPlayback {
            expandAction()
        } else {
            startQuizAudioPlay()
        }
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
        
        UserDefaultsManager.updateCurrentQuizStatus(inProgress: false)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.quizPlayerObserver.playerState = .endedQuiz
            UserDefaultsManager.updateCurrentPosition(0)
            self.presentationManager.expandSheet = false
            self.presentationManager.interactionState = .idle
            self.expandSheet = false
            self.refreshQuiz = true
        }
    }
}
