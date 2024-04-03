//
//  RecommendedTopics.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/30/24.
//

import Foundation
import SwiftData

@Model
class RecommendedToipics:  ObservableObject, Identifiable {
    var id: UUID
    var recommendations: [Topic]
    
    init(id: UUID, recommendations: [Topic]) {
        self.id = id
        self.recommendations = recommendations
    }
    
    init(id: UUID) {
        self.id = id
        self.recommendations = []
    }
}
