//
//  SwiftData.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/18/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Topic: ObservableObject, Identifiable {
    @Attribute(.unique) var name: String
    var isPresented: Bool
    var numberOfPresentations: Int
    var audioLecture: String
    
    init(name: String, isPresented: Bool, numberOfPresentations: Int, audioLecture: String) {
        self.name = name
        self.isPresented = isPresented
        self.numberOfPresentations = numberOfPresentations
        self.audioLecture = audioLecture
    }
    
    init(name: String) {
        self.name = name
        self.isPresented = false
        self.numberOfPresentations = 0
        self.audioLecture = ""
    }
}

@Model
class PerformanceModel: Identifiable, Hashable {
    let id: UUID
    var quizName: String
    var date: Date
    var score: CGFloat
    var numberOfQuestions: Int
    
    init(id: UUID, quizName: String, date: Date, score: CGFloat, numberOfQuestions: Int) {
        self.id = id
        self.quizName = quizName
        self.date = date
        self.score = score
        self.numberOfQuestions = numberOfQuestions
    }
}

@Model
class UserConfig: ObservableObject, Identifiable {
    @Attribute(.unique) var username: String
    var email: String
    var quizPackages: [AudioQuizPackage]
    var recommendedListens: [AudioItem]
    var topicReview: [TopicReview]
    
    init(username: String, email: String, quizPackages: [AudioQuizPackage], recommendedListens: [AudioItem], topicReview: [TopicReview]) {
        self.username = username
        self.email = email
        self.quizPackages = quizPackages
        self.recommendedListens = recommendedListens
        self.topicReview = topicReview
    }
}

@Model
class AudioItem: ObservableObject, Identifiable {
    var id: UUID
    @Attribute(.unique) var title: String
    var titleImage: String
    var audioUrl: String
    
    init(id: UUID) {
        self.id = UUID()
        self.title = ""
        self.titleImage = ""
        self.audioUrl = ""
    }
    
    init(id: UUID, title: String, titleImage: String, audioUrl: String) {
        self.id = id
        self.title = title
        self.titleImage = titleImage
        self.audioUrl = audioUrl
    }
}

@Model
class TopicReview: ObservableObject, Identifiable {
    var id: UUID
    @Attribute(.unique) var title: String
    var titleImage: String
    var audioUrl: String
    
    init(id: UUID) {
        self.id = UUID()
        self.title = ""
        self.titleImage = ""
        self.audioUrl = ""
    }
    
    init(id: UUID, title: String, titleImage: String, audioUrl: String) {
        self.id = id
        self.title = title
        self.titleImage = titleImage
        self.audioUrl = audioUrl
    }
}

