//
//  DownloadedAudioQuiz.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 2/13/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class DownloadedAudioQuiz: Identifiable, Hashable {
    @Attribute(.unique) var quizname: String
    var shortTitle: String
    var quizImage: String
    var dateCreated: Date
    var currentIndex: Int
    var quizzesCompleted: Int
    var questions: [Question]
    
    init(quizname: String, shortTitle: String, quizImage: String) {
        self.quizname = quizname
        self.quizImage = quizImage
        self.shortTitle = shortTitle
        self.dateCreated = .now
        self.currentIndex = 0
        self.questions = []
        self.quizzesCompleted = 0
    }
}

enum AudioQuizStatus: Int, Codable, Identifiable, CaseIterable {
    case downloaded, deleted
    var id: Self {
        self
    }
    
    var descr: String {
        switch self {
        case .downloaded:
            "Downloaded"
        case .deleted:
            "Audio files deleted"
        }
    }
}

enum UserStatus: Int, Codable, Identifiable, CaseIterable {
    case quizStarted, quizEnded, inPlaylist, onShelf
    var id: Self {
        self
    }
    
    var descr: String {
        switch self {
        case .quizStarted:
            "Quiz Started"
        case .quizEnded:
            "Quiz Ended"
        case .inPlaylist:
            "Added to Playlist"
        case .onShelf:
            "Available"
        }
    }
}

struct DownloadedAudioQuizContainer {
    var name: String
    var quizImage: String
    var dateCreated: Date
    var currentIndex: Int
    var quizStatus: AudioQuizStatus
    var userStatus: UserStatus
    var contents: [Question]
    var topics: [Topic]
    var rating: Int
    
    init(name: String, quizImage: String) {
        self.name = name
        self.quizImage = quizImage
        self.dateCreated = .now
        self.currentIndex = 0
        self.quizStatus = .downloaded
        self.userStatus = .inPlaylist
        self.contents = []
        self.topics = []
        self.rating = 0
    }
}
