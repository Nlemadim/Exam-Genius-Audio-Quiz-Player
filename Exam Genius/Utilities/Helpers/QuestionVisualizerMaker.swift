//
//  QuestionVisualizerMaker.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/21/24.
//

import Foundation

class QuestionVisualizerMaker {
    static func createVisualizers(from questions: [Question]) -> [QuestionVisualizer] {
        return questions.map { question in
            // Ensure there are exactly 4 options, otherwise, fill missing options with empty strings
            let options = question.options + Array(repeating: "", count: max(0, 4 - question.options.count))
            
            return QuestionVisualizer(
                questionContent: question.questionContent,
                optionA: options[0],
                optionB: options[1],
                optionC: options[2],
                optionD: options[3]
            )
        }
    }
}
