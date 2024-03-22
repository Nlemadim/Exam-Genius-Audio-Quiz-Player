//
//  QuestionDataObject.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/11/24.
//

import Foundation
import SwiftData


// Define the main object model
struct QuestionDataObject: Decodable {
    let examName: String
    var topics: [String] // Changed to an array to handle multiple topics
    var questions: [QuestionData]
    
    enum CodingKeys: String, CodingKey {
        case examName = "examName"
        case topics // Adjusted for the change to an array
        case questions
    }
}

// Define the Question model
struct QuestionData: Decodable {
    let questionNumber: Int
    let question: String
    let options: Options
    let correctOption: String
    let overview: String
    var audioUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case questionNumber = "questionNumber"
        case question
        case options
        case correctOption = "correctOption"
        case overview
    }
}

// Define the Options model
struct Options: Decodable {
    let a: String
    let b: String
    let c: String
    let d: String
    
    // Use custom coding keys to match JSON keys
    enum CodingKeys: String, CodingKey {
        case a = "A"
        case b = "B"
        case c = "C"
        case d = "D"
    }
}

struct AudioQuizPackageContent {
    var name: String = ""
    var acronym: String = ""
    var about: String = ""
    var imageUrl: String = ""
    var categories: [String] = [] // Assuming categories are identified by Strings. Adjust if a different structure is used.
    var topics: [TopicContent] = []
    var questions: [QuestionContent] = []
    // Performance data might be fetched or calculated differently, so it's not included here initially.
}


struct TopicContent {
    var name: String
    var isPresented: Bool = false
    var numberOfPresentations: Int = 0
}

struct QuestionContent {
    var id: UUID
    var questionContent: String
    var topic: String
    var options: [String]
    var correctOption: String
    var questionAudio: String
    var questionNoteAudio: String
    // SelectedOption, isAnswered, isAnsweredCorrectly, and numberOfPresentations might be initialized differently, hence not included.
}
