//
//  SummaryInfoView.swift
//  ExamGenius
//
//  Created by Tony Nlemadim on 12/26/23.
//

import SwiftUI

struct SummaryInfoView: View {
    @State var userHighScore = UserDefaultsManager.userHighScore()
    @State var quizzesCompleted = UserDefaultsManager.numberOfQuizSessions()
    @State var totalAnsweredQuestions = UserDefaultsManager.numberOfQuizSessions()
    var highScore: CGFloat
    var numberOfTestsTaken: Int
    
    var body: some View {
           VStack(spacing: 15) {
               scoreLabel(
                   withTitle: "High Score",
                   iconName: "trophy",
                   score: getPercentage(score: Int(userHighScore))
               )

               scoreLabel(
                   withTitle: "Quizzes",
                   iconName: "doc.questionmark",
                   score: "\(quizzesCompleted)"
               )
               
               scoreLabel(
                   withTitle: "Total Number of Questions",
                   iconName: "questionmark.circle",
                   score: "∞"
               )
               
               scoreLabel(
                   withTitle: "Answered Correctly",
                   iconName: "checkmark.circle",
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Answered Wrong",
                   iconName: "xmark.circle",
                   score: "\(numberOfTestsTaken)"
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

    
    func calculatedScore(score: Int) -> CGFloat {
        return CGFloat(score) * 10.0
    }
    
    func getPercentage(score: Int) -> String {
        let scorePercentage = calculatedScore(score: score)
        return String(format: "%.0f%%", scorePercentage)
    }
}

struct HeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding([.top, .horizontal])
        .hAlign(.leading)
    }
}

#Preview {
    SummaryInfoView(highScore: 3, numberOfTestsTaken: 10)
        .preferredColorScheme(.dark)
}
