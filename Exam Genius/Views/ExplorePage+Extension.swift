//
//  ExplorePage+Extension.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/3/24.
//

import Foundation
import SwiftUI
import SwiftData

extension ExplorePage {
    
    func playNow(_ audioQuiz: AudioQuizPackage) {
        isPlaying.toggle()
        let list = audioQuiz.questions
        let playList = list.compactMap{$0.questionAudio}
        audioContentPlayer.playAudioFile(playList[0])
    }
    
    func playSampleQuiz(_ didTapPlay: Bool) {
        if didTapPlay {
            if let selectedQuizPackage = self.selectedQuizPackage {
                if selectedQuizPackage.questions.isEmpty {
                    Task {
                        try await downloadSample(selectedQuizPackage)
                    }
                } else {
                    playNow(selectedQuizPackage)
                }
            }
        }
    }
    
    func fetchFullPackage(_ didTapDownload: Bool) {
        if didTapDownload {
            if let selectedQuizPackage = self.selectedQuizPackage {
                Task {
                    try await downloadFullPackage(selectedQuizPackage)
                }
            }
        }
    }
    
    private func downloadFullPackage(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.questions.isEmpty else { return }
        DispatchQueue.main.async {
            self.interactionState = .isDownloading
        }
    
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
       
        //MARK: ProductionFlow Method
        let content = try await contentBuilder.buildQuestionsOnly(examName: audioQuiz.name)
        
        print("Downloaded \(content.questions.count) Questions without audio")
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            user.selectedQuizPackage = audioQuiz
            self.interactionState = .idle
            print("Downloaded")
        }
    }
    
    private func downloadSample(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.questions.isEmpty else { return }
        DispatchQueue.main.async {
            didTapSample.toggle()
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process for sample Q&A
        let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
        print("Downloaded Sample Content: \(content)")
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            didTapSample = false
            playNow(audioQuiz)
        }
    }
}
