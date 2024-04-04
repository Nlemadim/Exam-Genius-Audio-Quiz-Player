//
//  AudioQuizProgressView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import Foundation
import SwiftUI

struct AudioQuizProgressView: View {
    var selectedQuizPackage: AudioQuizPackage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            LabeledContent("Total Questions", value: "\(selectedQuizPackage?.questions.count ?? 0)")
            LabeledContent("Questions Answered", value: "\(selectedQuizPackage?.questions.count ?? 0)")
            LabeledContent("Quizzes Completed", value: "\(selectedQuizPackage?.questions.count ?? 0)")
            LabeledContent("Current High Score", value: "\(selectedQuizPackage?.questions.count ?? 0)%")
        }
        .font(.footnote)
        .padding(.horizontal)
        .padding()
    }
}
