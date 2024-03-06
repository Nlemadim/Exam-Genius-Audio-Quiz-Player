//
//  QuestionModel.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 2/9/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Question: ObservableObject, Identifiable {
    var id: UUID
    @Attribute(.unique) var questionContent: String
    var questionNote: String
    var topic: String
    var options: [String]
    var correctOption: String
    var selectedOption: String = ""
    var isAnswered: Bool = false
    var isAnsweredCorrectly: Bool
    var numberOfPresentations: Int
    var questionAudio: String
    var questionNoteAudio: String
    
    init(
        id: UUID,
        questionContent: String,
        questionNote: String,
        topic: String,
        options: [String],
        correctOption: String,
        selectedOption: String,
        isAnswered: Bool,
        isAnsweredCorrectly: Bool,
        numberOfPresentations: Int,
        questionAudio: String,
        questionNoteAudio: String
    ) {
        self.id = id
        self.questionContent = questionContent
        self.questionNote = questionNote
        self.topic = topic
        self.options = options
        self.correctOption = correctOption
        self.selectedOption = selectedOption
        self.isAnswered = isAnswered
        self.isAnsweredCorrectly = isAnsweredCorrectly
        self.numberOfPresentations = numberOfPresentations
        self.questionAudio = questionAudio
        self.questionNoteAudio = questionNoteAudio
    }
    
    init(id: UUID) {
        self.id = id
        self.questionContent = ""
        self.questionNote = ""
        self.topic = ""
        self.options = []
        self.correctOption = ""
        self.selectedOption = ""
        self.isAnswered = false
        self.isAnsweredCorrectly = false
        self.numberOfPresentations = 0
        self.questionAudio = ""
        self.questionNoteAudio = ""
    }
}

extension Question {
    convenience init(from response: QuestionResponse) {
        let options = response.options.map { $0.option }
        let topic = response.topic
        self.init(
            id: UUID(),
            questionContent: response.question,
            questionNote: response.overview ?? "",
            topic: topic,
            options: options,
            correctOption: response.correctOption,
            selectedOption: "",
            isAnswered: false,
            isAnsweredCorrectly: false,
            numberOfPresentations: 0,
            questionAudio: response.questionAudio ?? "",
            questionNoteAudio: ""
        )
    }
}




enum QuestionStatus: Int, Codable, Identifiable, CaseIterable {
    case isPresented, isAnswered, isAnsweredCorrectly, isRefined
    var id: Self {
        self
    }
    
    var descr: String {
        switch self {
        case .isPresented:
            "Has Been Presented"
        case .isAnswered:
            "Has Been Answered"
        case .isAnsweredCorrectly:
            "Has Been Answered Correctly"
        case .isRefined:
            "Has Been Refined"
        }
    }
}
