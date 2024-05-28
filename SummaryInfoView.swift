//
//  SummaryInfoView.swift
//  ExamGenius
//
//  Created by Tony Nlemadim on 12/26/23.
//

import SwiftUI

struct SummaryInfoView: View {
    var answeredQuestions = UserDefaultsManager.totalQuestionsAnswered()
    var quizzesCompleted = UserDefaultsManager.numberOfQuizSessions()
    var totalAnsweredQuestions = UserDefaultsManager.numberOfQuizSessions()
    var highScore: CGFloat
    var numberOfTestsTaken: Int
    
    var body: some View {
           VStack(spacing: 15) {
               
               scoreLabel(
                   withTitle: "Quizzes Completed",
                   iconName: "doc.questionmark",
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "High Score",
                   iconName: "trophy",
                   score: "\(highScore)%"
               )
               
               scoreLabel(
                   withTitle: "Total Number of Questions",
                   iconName: "questionmark.circle",
                   score: "∞"
               )
               
               scoreLabel(
                   withTitle: "Questions Answered",
                   iconName: "checkmark.circle",
                   score: "\(answeredQuestions)"
               )
               
               scoreLabel(
                   withTitle: "Questions Skipped",
                   iconName: "forward.arrow",
                   score: "\(0)"
               )
           }
       }

    
    private func scoreLabel(withTitle title: String, iconName: String, score: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(.mint)
               
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(score)
                .font(.subheadline)
        }
    }
}



#Preview {
    SummaryInfoView(highScore: 3, numberOfTestsTaken: 10)
        .preferredColorScheme(.dark)
}
