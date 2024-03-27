//
//  QuizPlayerViewExtensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/26/24.
//

import Foundation

extension QuizPlayerView {
    
    func playQuestion() {
        guard !currentQuestions.isEmpty else { return }
        if currentQuestions.indices.contains(currentQuestionIndex), currentQuestionIndex < currentQuestions.count - 1 {
            let currentPosition = self.currentQuestionIndex
            let audio = self.currentQuestions[currentPosition].questionAudio
            questionPlayer.playSingleAudioQuestion(audioFile: audio)
        } else {
            self.currentQuestionIndex = 0
            playQuestion()
        }
    }
    
    var currentQuestions: [Question] {
        var questions: [Question] = []
        if let selectedPackage = user.selectedQuizPackage {
            let currentQuestions = selectedPackage.questions
            questions.append(contentsOf: currentQuestions)
        }
        return questions
    }
    
    var numberOfTopics: Int {
        if let selectedPackage = user.selectedQuizPackage {
            let numberOfTopics = selectedPackage.topics.count
            return numberOfTopics
        }
        
        return 0
    }
    
    var numberOfQuestions: Int {
        if let selectedPackage = user.selectedQuizPackage {
            let numberOfTopics = selectedPackage.questions.count
            return numberOfTopics
        }
        
        return 0
    }
    
    var questionsAnswered: Int {
        let total = UserDefaultsManager.totalQuestionsAnswered()
        return total
    }
    
    var quizzesCompleted: Int {
        let total = UserDefaultsManager.numberOfQuizSessions()
        return total
    }
    
    var highestScore: Int {
        let total = UserDefaultsManager.userHighScore()
        return total
    }
 
    func analyseResponse() {
        self.interactionState = .hasResponded
        if !self.selectedOption.isEmptyOrWhiteSpace {
    
            DispatchQueue.main.async {
                print("Saving response")
                let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
                currentQuestion.selectedOption = self.selectedOption
                currentQuestion.isAnswered = true

                if currentQuestion.selectedOption == currentQuestion.correctOption {
                    currentQuestion.isAnsweredCorrectly = true
                }
                
                print(self.interactionState)
                print("Save complete")
                print("Question Answered")
                print("User selected \(self.currentQuestions[self.currentQuestionIndex].selectedOption) option")
                print("Current question is answered: \(self.currentQuestions[self.currentQuestionIndex].isAnswered)")
                print("Question \(self.currentQuestions[self.currentQuestionIndex].id) was answered correctly?: \(self.currentQuestions[self.currentQuestionIndex].isAnsweredCorrectly)")
            }
        }
    }
    
    func goToNextQuestion() {
        if let questionCount = configuration?.questions.count, currentQuestionIndex < questionCount - 1 {
            self.currentQuestionIndex += 1
            questionPlayer.playSingleAudioQuestion(audioFile: self.currentQuestions[self.currentQuestionIndex].questionAudio)
            print("Current Question Index on QuizPlayer is \(self.currentQuestionIndex)")
        }
    }
    
    private func goToPreviousQuestion() {
        
    }
    
    private func selectOption(_ option: String) {
     
    }
}
