//
//  AudioQuizPackage.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 2/9/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class AudioQuizPackage: ObservableObject, Identifiable {
    var id: UUID
    @Attribute(.unique) var name: String
    var acronym: String
    var about: String
    var imageUrl: String
    var category: String
    var topics: [Topic]
    var questions: [Question]
    var performance: [Performance]
    
    init(id: UUID) {
        self.id = id
        self.name = ""
        self.acronym = ""
        self.about = ""
        self.imageUrl = ""
        self.category = ""
        self.questions = []
        self.topics = []
        self.performance = []
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
        self.acronym = ""
        self.about = ""
        self.imageUrl = ""
        self.category = ""
        self.questions = []
        self.topics = []
        self.performance = []
    }
    
    init(id: UUID, name: String, about: String, imageUrl: String, category: String) {
        self.id = id
        self.name = name
        self.acronym = ""
        self.about = about
        self.imageUrl = imageUrl
        self.category = category
        self.questions = []
        self.topics = []
        self.performance = []
    }
    
    init(id: UUID, name: String, acronym: String, about: String, imageUrl: String, category: String, topics: [Topic], questions: [Question], performance: [Performance]) {
        self.id = id
        self.name = name
        self.acronym = acronym
        self.about = about
        self.imageUrl = imageUrl
        self.category = category
        self.topics = topics
        self.questions = questions
        self.performance = performance
    }
    
}

