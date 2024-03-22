//
//  QuizBuilder.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/27/24.
//

//import Foundation
//import SwiftUI
//import SwiftData
//
//extension AudioQuizPlaylistView {
//    @Observable
//    class QuizBuilder: ObservableObject {
//        private let networkService: NetworkService = NetworkService.shared
//        var modelContext: ModelContext? = nil
//        var questionNumber: Int = 0
//        
//        func fetchTopicNames(context: String) async throws -> [String] {
//            var topics = [String]()
//            do {
//                topics = try await networkService.fetchTopics(context: context)
//                
//            } catch {
//                print("Error Fetching Topics: Desc; \(error.localizedDescription)")
//                
//            }
//            return topics
//        }
//        
//        func fetchPackageQuestions(examName: String, topics: [String], number: Int) async throws -> [QuestionResponse] {
//            return try await networkService.fetchQuestions(examName: examName, topics: topics, number: number)
//        }
//    }
//}




//let topicsPrompt = topicsContentPrompt(examName: examName.name, numberOfTopics: 3)
//            let topicsString = await networkService.fetchTopicsLocally(prompt: "Given: \(examName.name) Exam. Generate study topics for a student preparing to take this exam. If any topic has subtopics list as induvidual topic. Example: Maths, Addition, subtraction, division, multiplication, Fractions etc. DO NOT NUMBER TOPICS. FOR EASY PARSING RETURN A SINGLE STRING OF TOPICS SEPARATED BY A COMMA")
