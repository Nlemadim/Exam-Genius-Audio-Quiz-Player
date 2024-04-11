//
//  PlayListItem.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/30/24.
//

import Foundation
import SwiftUI

protocol PlaylistItem: AnyObject {
    var title: String { get }
    var titleImage: String { get }
    var audioFile: String? { get }
    var audioCollection: [String]? { get }
}

protocol QuizItem: AnyObject {
    var name: String { get }
    var imageUrl: String { get }
}


class MyPlaylistItem: PlaylistItem {
    var title: String
    var titleImage: String
    var audioFile: String?
    var audioCollection: [String]?

    init(title: String, titleImage: String, audioFile: String? = nil, audioCollection: [String]? = nil) {
        self.title = title
        self.titleImage = titleImage
        self.audioFile = audioFile
        self.audioCollection = audioCollection
    }
    
    convenience init(from anyQuiz: QuizItem) {
        self.init(title: anyQuiz.name, titleImage: anyQuiz.imageUrl)
    }
    
    // Initialize from an AudioQuizPackage
    convenience init(from package: AudioQuizPackage) {
        let audioCollection = package.questions.map { $0.questionAudio }
        self.init(title: package.name, titleImage: package.imageUrl, audioCollection: audioCollection)
    }
    
    convenience init(from container: DownloadedAudioQuizContainer) {
        let audioCollection = container.contents.map { $0.questionAudio }
        self.init(title: container.name, titleImage: container.quizImage, audioCollection: audioCollection)
    }
    
    // Initialize from a Topic
    convenience init(from topic: Topic) {
        self.init(title: topic.name, titleImage: "", audioFile: topic.audioLecture)
    }
}




