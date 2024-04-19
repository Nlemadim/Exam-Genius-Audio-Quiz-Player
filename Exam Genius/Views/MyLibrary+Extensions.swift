//
//  MyLibrary+Extensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import Foundation

extension MyLibrary {
    func updatePlaylist() {
        // Extracting question IDs already present in the downloaded collection
        let existingQuestionIds = downloadedAudioQuizCollection.flatMap { $0.questions }.map { $0.id }

        let filteredQuizPackages = audioQuizCollection.filter { audioQuizPackage in
            // Filter out audioQuizPackages where all questions are already in the downloaded collection
            audioQuizPackage.questions.contains { question in
                !question.questionAudio.isEmptyOrWhiteSpace && !existingQuestionIds.contains(question.id)
            }
        }

        self.downloadedAudioQuizCollection.append(contentsOf: filteredQuizPackages)
     
        filteredQuizPackages.forEach { audioQuiz in
            addAudioQuizToLibrary(from: audioQuiz)
        }
    }
    
    func updateUserSelection(content: PlayerContent) {
        // Extract the title from the content
        let title: String
        switch content {
        case .audioQuiz(let quiz):
            title = quiz.title
        case .topic(let topic):
            title = topic.title
        }

        // Assuming downloadedQuizzes holds similar playable content
        // Filter this collection to find the matching content
        let selectedPackages = downloadedAudioQuizCollection.filter { quiz in
            quiz.name == title
        }
        
        // Assuming you need the first match only
        if let selectedPackage = selectedPackages.first {
            // Update your state or properties with this selected package
            self.selectedQuizPackage = selectedPackage
            user.selectedQuizPackage = selectedPackage
        } else {
            // Handle the case where no matching package is found in downloadedQuizzes
            print("No matching package found in downloadedQuizzes")
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
