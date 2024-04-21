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
        @Published var questionTranscript: String = "Empty"
        @Published var currentQuizPackage: AudioQuizPackage?
        @Published var latestPerformance: PerformanceModel?
        @Published var stoppedPlaying: Bool = false
        @Published var interactionState: InteractionState = .idle
        @Published var quizQuestionCount: Int = 0
        @Published var lastestScore: String = ""
        
        private var sharedState: SharedQuizState
        
        init(sharedState: SharedQuizState) {
            self.sharedState = sharedState
        }
        
        func loadQuizConfiguration(quizPackage: AudioQuizPackage?) {
            guard let quizPackage = quizPackage else {
                return
            }
            
            let questions = QuestionVisualizerMaker.createVisualizers(from: quizPackage.questions)
            
            let newConfiguration = QuizViewConfiguration(
                imageUrl: quizPackage.imageUrl,
                name: quizPackage.name,
                shortTitle: quizPackage.acronym,
                questions: questions
            )
            
            DispatchQueue.main.async {
                self.configuration = newConfiguration
                self.currentQuizPackage = quizPackage
                print("Quiz Setter has Set New Quiz package: \(self.currentQuizPackage?.name ?? "No package selected")")
                print("Quiz Setter has Set Configurations")
                print("Quiz Setter has Set questionTranscript as: \(self.questionTranscript)")
                
            }
        }
        
       
        func loadQuestionScriptViewer(question: Question) {
            
            transcriber = QuestionTranscriber(question: question)
            
            // Initialize transcription to ensure it's ready to be observed.
            transcriber?.startTypingText()
            
            // Bind the `displayedText` to `questionTranscript`
            transcriber?.displayedTextPublisher.receive(on: RunLoop.main).assign(to: &$questionTranscript)
            print(questionTranscript)
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

