//
//  QuizDataManager.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/30/24.
//

import Foundation

@Observable final class QuizDataManager {
    private let networkService = NetworkService.shared
    var interactionState: InteractionState = .idle
    var container = Container(id: UUID())
    var temporaryQuestionContent = [Question]()
    
    
    func buildQuestionsOnly(examName: String) async throws -> Container {
        try await fetchAndStoreAllTopics(examName: examName)
        let selectedTopics = selectRandomTopics(limit: 10)
        await downloadQuestionsForTopics(selectedTopics, examName: examName)
        return container
    }
    
    
    private func fetchAndStoreAllTopics(examName: String) async throws {
        let allTopics = try await networkService.fetchTopics(context: examName)
        container.topics = allTopics.map { Topic(name: $0) }
        print("Fetched and stored all topics")
    }
    
    private func selectRandomTopics(limit: Int) -> [Topic] {
        guard container.topics.count >= limit else {
            return container.topics
        }
        return container.topics.shuffled().prefix(limit).map { $0 }
    }
    
    private func downloadQuestionsForTopics(_ topics: [Topic], examName: String) async {
        await withTaskGroup(of: Void.self) { group in
            for topic in topics {
                group.addTask {
                    do {
                        let questionDataArray = try await self.networkService.fetchQuestionData(examName: examName, topics: [topic.name], number: 1)
                        // Processing each question data object
                        questionDataArray.forEach { questionDataObject in
                            let questions = questionDataObject.questions.map { questionData in
                                Question(
                                    id: UUID(),
                                    topic: topic.name,
                                    questionContent: questionData.question,
                                    options: [questionData.options.a, questionData.options.b, questionData.options.c, questionData.options.d],
                                    correctOption: questionData.correctOption,
                                    questionNote: questionData.overview
                                )
                            }
                            
                            DispatchQueue.main.async {
                                // Append directly to the container questions
                                self.container.questions.append(contentsOf: questions)
                                print("Downloaded questions for topic: \(topic.name)")
                            }
                        }
                    } catch {
                        print("Failed to download questions for topic: \(topic.name), error: \(error)")
                    }
                }
            }
        }
    }
    
    func downloadAllFeedbackAudio(for voiceFeedback: VoiceFeedbackContainer) async -> VoiceFeedbackContainer {
        var updatedFeedback = voiceFeedback
        let messagesAndPaths: [(message: String, keyPath: WritableKeyPath<VoiceFeedbackContainer, String>)] = [
            (voiceFeedback.quizStartMessage, \VoiceFeedbackContainer.quizStartAudioUrl),
            (voiceFeedback.quizEndingMessage, \VoiceFeedbackContainer.quizEndingAudioUrl),
            (voiceFeedback.correctAnswerCallout, \VoiceFeedbackContainer.correctAnswerCalloutUrl),
            (voiceFeedback.skipQuestionMessage, \VoiceFeedbackContainer.skipQuestionAudioUrl),
            (voiceFeedback.errorTranscriptionMessage, \VoiceFeedbackContainer.errorTranscriptionAudioUrl),
            (voiceFeedback.finalScoreMessage, \VoiceFeedbackContainer.finalScoreAudioUrl)
        ]
        
        await withTaskGroup(of: (WritableKeyPath<VoiceFeedbackContainer, String>, String?).self) { group in
            for (message, keyPath) in messagesAndPaths {
                group.addTask {
                    let audioUrl = await self.downloadReadOut(readOut: message)
                    return (keyPath, audioUrl)
                }
            }
            for await (keyPath, audioUrl) in group {
                if let url = audioUrl {
                    updatedFeedback[keyPath: keyPath] = url
                }
            }
        }
        
        return updatedFeedback
    }
    
    
    func downloadAudioQuestions(for items: [DownloadableQuiz]) async {
        var updatedItems = [(DownloadableQuiz, String, String)]()
        // Perform all downloads concurrently, collect results in an array
        await withTaskGroup(of: (DownloadableQuiz, String, String).self) { group in
            for item in items {
                group.addTask {
                    let contentAudio: String = await self.downloadReadOut(readOut: item.contentReadOut) ?? ""
                    let noteAudio: String = await self.downloadReadOut(readOut: item.noteReadOut) ?? ""
                    return (item, contentAudio, noteAudio)
                }
            }
            
            // Collect all updates safely
            for await (item, contentAudio, noteAudio) in group {
                updatedItems.append((item, contentAudio, noteAudio))
            }
        }
        
        // Apply the updates in a non-concurrent context
        for (var item, contentAudio, noteAudio) in updatedItems {
            item.contentAudioURL = contentAudio
            item.noteAudioURL = noteAudio
        }
    }
    
    private func downloadReadOut(readOut: String) async -> String? {
        var fileName: String? = nil
        do {
            let audioData = try await networkService.fetchAudioData(content: readOut)
            if let savedFileName = saveAudioDataToFile(audioData) {
                fileName = savedFileName
                print("Downloaded and saved audio file name: \(savedFileName)")
            } else {
                print("Failed to save the audio file.")
            }
        } catch {
            print("Failed to download audio file: \(error.localizedDescription)")
        }
        
        return fileName
    }
    
    private func saveAudioDataToFile(_ data: Data) -> String? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".mp3"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving audio file: \(error)")
            return nil
        }
    }
    
    
    
}
