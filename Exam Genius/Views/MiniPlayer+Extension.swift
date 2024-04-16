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
        @Published var currentQuizPackage: AudioQuizPackage?
        @Published var stoppedPlaying: Bool = false
        @Published var interactionState: InteractionState = .idle
        @Published var quizQuestionCount: Int = 0
        
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
            }
        }
    }
}

