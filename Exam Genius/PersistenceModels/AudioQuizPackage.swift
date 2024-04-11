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
    var category: [ExamCategory]
    var topics: [Topic]
    var questions: [Question]
    var performance: [PerformanceModel]
    
    init(id: UUID) {
        self.id = id
        self.name = ""
        self.acronym = ""
        self.about = ""
        self.imageUrl = ""
        self.category = []
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
        self.category = []
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
        self.category = []
        self.questions = []
        self.topics = []
        self.performance = []
    }
    
    init(id: UUID, name: String, imageUrl: String, category: [ExamCategory]) {
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
    
    init(id: UUID, name: String, about: String, imageUrl: String, category: [ExamCategory]) {
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
    
    init(id: UUID, name: String, acronym: String, about: String, imageUrl: String, category: [ExamCategory], topics: [Topic], questions: [Question], performance: [PerformanceModel]) {
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
            category: examDetails.category,
            topics: [],
            questions: [],
            performance: []
        )
    }
}

enum ExamCategory: String, Codable, Identifiable, CaseIterable, Hashable {
    case science = "Science"
    case technology = "Technology"
    case healthcare = "Healthcare"
    case legal = "Legal"
    case business = "Business"
    case itCertifications = "Information Technology"
    case professional = "Proffesional"
    case language = "Language"
    case engineering = "Engineering"
    case finance = "Finance"
    case miscellaneous = "Education"
    case education = "Educational"
    case topColledgePicks = "Colledge"
    case topProfessionalCertification = "Profesional Certification"
    case history = "History"
    case free = "Free"
    case topCollection = "Top Picks"
    case cultureAndSociety = "Culture and Society"
    

    var id: Self { self } // This makes ExamCategory conform to Identifiable

    var descr: String { // Provides a human-readable description
        switch self {
        case .science:
            return "Science"
        case .technology:
            return "Technology"
        case .healthcare:
            return "Healthcare"
        case .legal:
            return "Legal"
        case .business:
            return "Business"
        case .itCertifications:
            return "Information Technology"
        case .professional:
            return "Professional"
        case .language:
            return "Language"
        case .engineering:
            return "Engineering"
        case .finance:
            return "Finance"
        case .miscellaneous:
            return "Miscellaneous"
        case .education:
            return "Educational"
        case .topColledgePicks:
            return "Colledge"
        case .topProfessionalCertification:
            return "Profesional Certification"
        case .history:
            return "History"
        case .free:
            return "Sponsored"
        case .topCollection:
            return "Top Picks"
        case .cultureAndSociety:
            return "Culture and Society"
        }
    }
}

struct CombinedCategory: Hashable {
    let name: String
    let includedCategories: [ExamCategory]

    static func ==(lhs: CombinedCategory, rhs: CombinedCategory) -> Bool {
        return lhs.name == rhs.name && lhs.includedCategories == rhs.includedCategories
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(includedCategories)
    }
}

let combinedCategories: [CombinedCategory] = [
    CombinedCategory(name: "Top Picks", includedCategories: [.technology, .healthcare, .science]),
    CombinedCategory(name: "Free", includedCategories: [.education, .language]),
    CombinedCategory(name: "Colledge Picks", includedCategories: [.healthcare, .language]),
    CombinedCategory(name: "Science", includedCategories: [.healthcare, .engineering, .professional])
    
]

enum GroupedCategory {
    case topPicks
    case free

    var title: String {
        switch self {
        case .topPicks: return "Top Picks"
        case .free: return "Free"
        }
    }

    var includedCategories: [ExamCategory] {
        switch self {
        case .topPicks: return [.legal, .healthcare, .science]
        case .free: return [.healthcare]
        }
    }
}

enum UnifiedCategory: Identifiable {
    case individual(ExamCategory)
    case grouped(GroupedCategory)

    var id: String {
        switch self {
        case .individual(let category):
            return category.rawValue
        case .grouped(let grouped):
            return grouped.title
        }
    }

    var title: String {
        switch self {
        case .individual(let category):
            return category.rawValue
        case .grouped(let grouped):
            return grouped.title
        }
    }
}


struct ExamDetails: Identifiable {
    let id = UUID()
    let name: String
    let acronym: String
    let category: [ExamCategory]
    let about: String
    let image: String
}


extension AudioQuizPackage {
    convenience init(from examDetails: ExamDetails, topics: [Topic] = [], questions: [Question] = [], performance: [PerformanceModel] = []) {
        self.init(
            id: examDetails.id,
            name: examDetails.name,
            acronym: examDetails.acronym,
            about: examDetails.about,
            imageUrl: examDetails.image,
            category: examDetails.category, 
            topics: topics,
            questions: questions,
            performance: performance
        )
    }
}

extension AudioQuizPackage {
    static func from(content: AudioQuizPackageContent) -> AudioQuizPackage {
        let package = AudioQuizPackage(id: UUID())
        package.name = content.name
        package.acronym = content.acronym
        package.about = content.about
        package.imageUrl = content.imageUrl
             
        package.topics = content.topics.map { topicContent in
            Topic(name: topicContent.name, isPresented: topicContent.isPresented, numberOfPresentations: topicContent.numberOfPresentations, audioLecture: "")
        }

        package.questions = content.questions.map { questionContent in
            Question(id: questionContent.id, questionContent: questionContent.questionContent, questionNote: "", topic: questionContent.topic, options: questionContent.options, correctOption: questionContent.correctOption, selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: questionContent.questionAudio, questionNoteAudio: "")
        }
        
        package.category = []
        package.performance = []

        return package
    }
}

extension AudioQuizPackage {
    convenience init(from content: AudioQuizContent) {
        self.init(id: UUID())
        
        self.topics = content.topics.map { Topic(name: $0) }
        
        self.questions = content.questions.map { Question(fromResponse: $0) }
        
        self.performance = []
    }
}

struct TestAudioQuizPackage {
    var id: UUID
    var name: String
    var acronym: String
    var about: String
    var imageUrl: String
    var category: [ExamCategory]
    var topics: [Topic]
    var questions: [Question]
    var performance: [PerformanceModel]
    
    init(id: UUID) {
        self.id = id
        self.name = ""
        self.acronym = ""
        self.about = ""
        self.imageUrl = ""
        self.category = []
        self.questions = []
        self.topics = []
        self.performance = []
    }
}
