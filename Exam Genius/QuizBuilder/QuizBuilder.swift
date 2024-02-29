//
//  QuizBuilder.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/27/24.
//

import Foundation
import SwiftUI
import SwiftData

extension AudioQuizPlaylistView {
    @Observable
    class QuizBuilder {
        private let networkService: NetworkService = NetworkService.shared
        var modelContext: ModelContext? = nil
        var questioNumber: Int = 0
        
        func fetchTopicNames(context: String) async throws -> [String] {
            return try await networkService.fetchTopics(context: context)
        }
        
        
        
        
        
        func updateQuestionGroup(package: [Question]) async -> [Question]  {
            guard !package.isEmpty else { return [] }
            var voicedQuestions: [Question] = []
            
            for question in package {
                questioNumber += 1
                await self.generateAudioQuestion(question: question)
                voicedQuestions.append(question)
            }
            
            return voicedQuestions
        }
        
        
        
        
        
        
        
        private func generateAudioQuestion(question: Question) async {
            let readOut = formatQuestionForReadOut(questionContent: question.questionContent, options: question.options)
            
            do {
                let audioFile = try await networkService.fetchAudioData(content: readOut)
                let fileUrl = saveAudioDataToFile(audioFile)
                updateQuestionAudioContent(question: question, audioFilePath: fileUrl.path)
                
            } catch {
                print(error.localizedDescription) //MARK: TODO: Modify for retry
            }
        }
        
        private func updateQuestionAudioContent(question: Question, audioFilePath: String) {
            question.questionAudio = audioFilePath
        }
        
        private func saveAudioDataToFile(_ data: Data) -> URL {
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let fileName = UUID().uuidString + ".mp3"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("Error saving audio file:", error)
                return fileURL // or handle the error appropriately
            }
        }
        
        private func formatQuestionForReadOut(questionContent: String, options: [String]) -> String {
            return """
                   Question:\(questioNumber)
                   
                   \(questionContent)
                   
                   Options:
                   
                   Option A: \(options[0])
                   Option B: \(options[1])
                   Option C: \(options[2])
                   Option D: \(options[3])
                   
                   """
        }
    }
}
