//
//  PlaylistModels.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import Foundation


protocol PlayableContent {
    var title: String { get }
    var titleImage: String { get }
}

enum PlayerContent: Hashable {
    case audioQuiz(AudioQuiz)
    case topic(TopicOverview)
}

struct AudioQuiz: PlayableContent, Hashable {
    var id = UUID()
    var title: String
    var audioCollection: [String]
    var titleImage: String
}

struct TopicOverview: PlayableContent, Hashable {
    var id = UUID()
    var title: String
    var audiofile: String
    var titleImage: String
}


