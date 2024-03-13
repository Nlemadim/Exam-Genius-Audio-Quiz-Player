//
//  AudioQuizDetailVM.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/11/24.
//

import SwiftUI
import Foundation

extension AudioQuizDetailView {
    class AudioQuizDetailVM: ObservableObject {
        var error: Error?
        @Bindable var audioQuiz: AudioQuizPackage
        private let networkService = NetworkService.shared
        private let quizPlayer = QuizPlayer.shared
        var isDownloading: Bool = false
        
        init(audioQuiz: AudioQuizPackage) {
            self.audioQuiz = audioQuiz
        }
        
        func buildAudioQuizContent(name audioQuiz: AudioQuizPackage)  {
            isDownloading = true
            let contentBuilder = ContentBuilder(networkService: networkService)
            Task {
                do {
                    let content = try await contentBuilder.buildContent(for: audioQuiz.name)
                    DispatchQueue.main.async {
                        self.audioQuiz = AudioQuizPackage.from(content: content)
                        self.isDownloading = false
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.isDownloading = false
                        self?.error = error
                    }
                }
            }
        }
        
        func playAudioQuizSample(playlist: [String]) {
            guard !audioQuiz.questions.isEmpty else {
                print("Empty Playlist")
                return
            }
            let sampleCollection = audioQuiz.questions.filter{ $0.questionAudio != "" }
            let playlist = sampleCollection.map{ $0.questionAudio }
            quizPlayer.playSampleQuiz(audioFileNames: playlist)
            
        }
    }
}
