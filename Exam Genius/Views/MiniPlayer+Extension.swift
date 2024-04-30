//
//  MiniPlayer+Extension.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/16/24.
//

import Foundation
import SwiftUI

extension MiniPlayerV2 {
    class MiniPlayerV2Configuration: ObservableObject {
        @Published var configuration: QuizViewConfiguration?
        var transcriber: QuestionTranscriber?
        @Published var questionTranscript: String = "Get Ready!"
        @Published var currentQuizPackage: DownloadedAudioQuiz?
        @Published var latestPerformance: PerformanceModel?
        @Published var stoppedPlaying: Bool = false
        @Published var interactionState: InteractionState = .idle
        @Published var quizQuestionCount: Int = 0
        @Published var lastestScore: String = ""
        
        private var sharedState: SharedQuizState
        
        init(sharedState: SharedQuizState) {
            self.sharedState = sharedState
        }
        
        func loadQuizConfiguration(quizPackage: DownloadedAudioQuiz?) {
            guard let quizPackage = quizPackage else {
                return
            }
            
            let question = questionTranscript
            
            let newConfiguration = QuizViewConfiguration(
                imageUrl: quizPackage.quizImage,
                name: quizPackage.quizname,
                shortTitle: quizPackage.shortTitle,
                question: question
            )
            
            DispatchQueue.main.async {
                self.configuration = newConfiguration
                self.currentQuizPackage = quizPackage
                self.quizQuestionCount = quizPackage.questions.count
            }
        }
        
       
        func loadQuestionScriptViewer(question: String) {
            self.questionTranscript = question
        }
        
        
        func scoreCalculatorString(questions: [Question]) -> String {
            // Filter the questions that are answered
            let answeredQuestions = questions.filter { $0.isAnswered }
            
            // Filter the questions that are answered correctly
            let correctlyAnsweredQuestions = answeredQuestions.filter { $0.isAnsweredCorrectly }
            
            // Calculate the percentage score
            let totalQuestionCount = questions.count
            let totalAnsweredCorrectly = correctlyAnsweredQuestions.count
            let percentage = (Double(totalAnsweredCorrectly) / Double(totalQuestionCount)) * 100
            
            // Format the percentage as a string with 2 decimal places
            return String(format: "%.2f%%", percentage)
        }
        
        func scoreCalculator(questions: [Question]) -> CGFloat {
            // Filter the questions that are answered
            let answeredQuestions = questions.filter { $0.isAnswered }
            
            // Filter the questions that are answered correctly
            let correctlyAnsweredQuestions = answeredQuestions.filter { $0.isAnsweredCorrectly }
            
            // Calculate the percentage score
            let totalQuestionCount = questions.count
            let totalAnsweredCorrectly = correctlyAnsweredQuestions.count
            let percentage = (CGFloat(totalAnsweredCorrectly) / CGFloat(totalQuestionCount)) * 100
            
            return percentage
        }
    }
}

