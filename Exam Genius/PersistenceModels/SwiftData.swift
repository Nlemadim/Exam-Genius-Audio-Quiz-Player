//
//  SwiftData.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/18/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Topic: ObservableObject, Identifiable {
    @Attribute(.unique) var name: String
    var isPresented: Bool
    var numberOfPresentations: Int
    
    init(name: String, isPresented: Bool, numberOfPresentations: Int) {
        self.name = name
        self.isPresented = isPresented
        self.numberOfPresentations = numberOfPresentations
    }
    
    init(name: String) {
        self.name = name
        self.isPresented = false
        self.numberOfPresentations = 0
    }
}

@Model
class Performance: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var score: CGFloat
    
    init(id: UUID, date: Date, score: CGFloat) {
        self.id = id
        self.date = date
        self.score = score
    }
}
