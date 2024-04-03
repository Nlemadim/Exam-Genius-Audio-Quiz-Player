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
                    let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
                    DispatchQueue.main.async {
                        audioQuiz.topics.append(contentsOf: content.topics)
                        audioQuiz.questions.append(contentsOf: content.questions)
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
        
        func buildAudioQuizTestContent(name audioQuiz: AudioQuizPackage)  {
            isDownloading = true
            let contentBuilder = ContentBuilder(networkService: networkService)
            Task {
                do {
                    let content = try await contentBuilder.alternateBuildTestContent(for: audioQuiz.name)
                    DispatchQueue.main.async {
                        audioQuiz.topics.append(contentsOf: content.topics)
                        audioQuiz.questions.append(contentsOf: content.questions)
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
            sampleContent(audioQuiz: audioQuiz)
        }
        
        func sampleContent(audioQuiz: AudioQuizPackage) {
            let samples  = getPlaylist(audioQuiz: audioQuiz)
            let playlist = samples.map{ $0.questionAudio }
            let sortedPlaylist = playlist.sorted()
            quizPlayer.playSampleQuiz(audioFileNames: sortedPlaylist)
           // isNowPlaying = true
        }
        
        func getPlaylist(audioQuiz: AudioQuizPackage) -> [Question] {
            var playlist: [Question] = []
            for question in audioQuiz.questions {
                if !question.questionAudio.isEmpty {
                    playlist.append(question)
                }
            }
            print(playlist.count)
            return playlist
        }
        
    }
}
