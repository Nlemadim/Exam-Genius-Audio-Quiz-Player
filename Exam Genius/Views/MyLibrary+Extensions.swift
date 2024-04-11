//
//  MyLibrary+Extensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import Foundation

extension MyLibrary {
    func updatePlaylist() {
        let filteredQuizPackages = audioQuizCollection.filter { audioQuizPackage in
            audioQuizPackage.questions.contains { question in
                !question.questionAudio.isEmptyOrWhiteSpace
            }
        }
        
        self.downloadedAudioQuizCollection = filteredQuizPackages
        downloadedAudioQuizCollection.forEach { audioQuiz in
            addAudioQuizToLibrary(from: audioQuiz)
        }
    }
    
    private func addAudioQuizToLibrary(from package: AudioQuizPackage?) {
        guard let package = package else { return }
        let audioCollection = Array(package.questions.compactMap { $0.questionAudio })
        let audioQuiz = AudioQuiz(title: package.name, audioCollection: audioCollection, titleImage: package.imageUrl)
        self.audioPlaylist.append(.audioQuiz(audioQuiz))
    }
    
    private func addTopicOverviewToLibrary(topic: Topic) {
        let overview = TopicOverview(title: topic.name, audiofile: topic.audioLecture, titleImage: "")
        self.audioPlaylist.append(.topic(overview))
    }
    
    func loadMockData() {
        audioPlaylist = [
            .audioQuiz(AudioQuiz(title: "Quiz 1", audioCollection: ["Track 1", "Track 2"], titleImage: "IconImage")),
            .topic(TopicOverview(title: "Topic 1", audiofile: "File 1", titleImage: "IconImage"))
        ]
    }
    
    var questionCount: Int {
        let count = UserDefaults.standard.object(forKey: "numberOfTestQuestions") as? Int
        return count ?? 0
    }
}
