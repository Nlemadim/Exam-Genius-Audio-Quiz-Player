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
        
        func fetchTopicNames(context: String) async throws -> [String] {
            return try await networkService.fetchTopics(context: context)
        }
    }
}
