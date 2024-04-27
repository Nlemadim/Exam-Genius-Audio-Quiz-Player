//
//  QuizViewConfigurations.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/21/24.
//

import Foundation

struct QuizViewConfiguration: Equatable {
    var imageUrl: String
    var name: String
    var shortTitle: String
    var question: String
    
    static func == (lhs: QuizViewConfiguration, rhs: QuizViewConfiguration) -> Bool {
        return lhs.name == rhs.name
    }

}


struct ControlConfiguration {
    var playPauseQuiz: () -> Void
    var nextQuestion: () -> Void
    var repeatQuestion: () -> Void
    var endQuiz: () -> Void
}

struct QuestionVisualizer: Equatable {
    var questionContent: String
    var optionA: String
    var optionB: String
    var optionC: String
    var optionD: String
}

