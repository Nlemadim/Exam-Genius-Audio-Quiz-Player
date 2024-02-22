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
    
    
    init(id: UUID, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.acronym = ""
        self.about = ""
        self.imageUrl = imageUrl
        self.category = ""
        self.questions = []
        self.topics = []
        self.performance = []
    }
    
    init(id: UUID, name: String, imageUrl: String, category: String) {
        self.id = id
        self.name = name
        self.acronym = ""
        self.about = ""
        self.imageUrl = imageUrl
        self.category = category
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
    
    // Custom initializer from ExamDetails
    convenience init(from examDetails: ExamDetails) {
        self.init(
            id: UUID(), name: examDetails.name,
            acronym: examDetails.acronym,
            about: examDetails.about,
            imageUrl: examDetails.image,
            category: "",
            topics: [],
            questions: [],
            performance: []
        )
    }
}

enum ExamCategory: String, CaseIterable, Identifiable {
    case science = "Science"
    case technology = "Technology"
    case healthcare = "Healthcare"
    case legal = "Legal"
    case business = "Business"
    case itCertifications = "IT Certifications"
    case professional = "Professional"
    case language = "Language"
    case engineering = "Engineering"
    case finance = "Finance"
    case miscellaneous = "Miscellaneous"
    case education = "Educational"
    
    var id: String { self.rawValue }
}

struct ExamDetails: Identifiable {
    let id = UUID()
    let name: String
    let acronym: String
    let category: ExamCategory
    let about: String
    let image: String
}


