//
//  KnowledgeTestViewModel.swift
//  KnowledgeTestComponent
//
//  Created by Tony Nlemadim on 1/10/24.
//

import SwiftUI
import SwiftData

extension KnowledgeTestContentView {
    @Observable
    //MARK: Mimicking the adoption of a viewModel or Service that will generate Questions, Select A set of Topics and Questions for them, generate Audio files for the question and Create a knowledge Test based on a set number of Questions, then Save the knowledge Test to database.
    class ViewModel {
        var modelContext: ModelContext? = nil
        var questions: [Question] = []
        
        func fetchQuestions() {
            let fetchDescriptor = FetchDescriptor<Question>(
                predicate: #Predicate { $0.topic != "Some Unknown Topic" },
                sortBy: [SortDescriptor(\.topic)]
            )
            
            questions = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
        }
        
        //MARK: TODO :- Algorthim to select Questions Randomly
        private func sortQuestionsByTestTopics(_questions: [Question]) -> [Question] {
            
            return []
        }
    }
}
