//
//  SummaryInfoView.swift
//  ExamGenius
//
//  Created by Tony Nlemadim on 12/26/23.
//

import SwiftUI

struct SummaryInfoView: View {
    var highScore: CGFloat
    var numberOfTestsTaken: Int
    
    var body: some View {
        HeaderView(title: "Summary")
            //.padding(.horizontal)
            .padding(.bottom)
           VStack(spacing: 15) {
               scoreLabel(
                   withTitle: "Highest Score",
                   iconName: "ActivityConstants.highScoreLabelIcon",
                   score: getPercentage(score: Int(highScore))
               )
               
               scoreLabel(
                   withTitle: "Lowest Score",
                   iconName: "ActivityConstants.attemptsLabelIcon",
                   score: "\(numberOfTestsTaken)"
               )

               scoreLabel(
                   withTitle: "ActivityConstants.attemptsLabel",
                   iconName: "ActivityConstants.attemptsLabelIcon",
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Total Number of Topics",
                   iconName: "ActivityConstants.attemptsLabelIcon",
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Total Number of Questions",
                   iconName: "ActivityConstants.attemptsLabelIcon",
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Total Questions Answered",
                   iconName:" ActivityConstants.attemptsLabelIcon",
                   score: "\(numberOfTestsTaken)"
               )
               
           }
           .cornerRadius(15)
           .preferredColorScheme(.dark)
       }

    
    private func scoreLabel(withTitle title: String, iconName: String, score: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .iconStyle()
            Text(title)
                .labelStyle()
            Spacer()
            Text(score)
                .scoreStyle()
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
}
