//
//  Config.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/18/24.
//

import Foundation

class Config {
    static let audioRequestURL = "https://ljnsun.buildship.run/testAudioGeneration"
    static let topicRequestURL = "https://ljnsun.buildship.run/"
    static let imageRequestURL = "https://ljnsun.buildship.run/imageGenerator"
    static let questionsRequestURL = "https://ljnsun.buildship.run/ExGenQuestionGeneration"
}


struct QuestionResponse: Decodable {
    let question: String
    let options: [Option]
    let correctOption: String
    let overview: String?
    
    struct Option: Decodable {
        let option: String
    }
}

