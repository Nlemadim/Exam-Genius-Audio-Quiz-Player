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
                   withTitle: ActivityConstants.highScoreLabel,
                   iconName: ActivityConstants.highScoreLabelIcon,
                   score: getPercentage(score: Int(highScore))
               )
               
               scoreLabel(
                   withTitle: "Lowest Score",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )

               scoreLabel(
                   withTitle: ActivityConstants.attemptsLabel,
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Total Number of Topics",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Total Number of Questions",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Total Questions Answered",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Questions Passed",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Questions Failed",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Available Resources",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
               
               scoreLabel(
                   withTitle: "Downloaded Resources",
                   iconName: ActivityConstants.attemptsLabelIcon,
                   score: "\(numberOfTestsTaken)"
               )
           }
           .cornerRadius(15)
           .backgroundStyle()
           .preferredColorScheme(.dark)
       }

//    var body: some View {
//        HStack {
//            Text("Summary")
//                .font(.title3)
//                .fontWeight(.semibold)
//            
//            Spacer(minLength: 0)
//        }
//        .padding(.top, 5)
//        .hAlign(.leading)
//        .padding(.horizontal)
//        
//        VStack(spacing: 10) {
//            // High Score
//            HStack {
//                Image(systemName: ActivityConstants.highScoreLabelIcon)
//                    .resizable()
//                    .frame(width: 25, height: 20)
//                    .foregroundStyle(Color.orange) // Replace with actual color
//                Text(ActivityConstants.highScoreLabel)
//                    .font(.system(size: 18))
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                
//                Spacer(minLength: 0)
//                
//                Text(getPercentage(score: Int(highScore)))
//                    .foregroundStyle(.quizMain)
//                    .font(.system(size: 18))
//                    .fontWeight(.bold)// Replace with actual color
//            }
//            
//            // Number of Tests Taken
//            HStack {
//                Image(systemName: ActivityConstants.attemptsLabelIcon)
//                    .resizable()
//                    .frame(width: 25, height: 20)
//                    .foregroundStyle(Color.orange) // Replace with actual color
//                Text(ActivityConstants.attemptsLabel)
//                    .font(.system(size: 18))
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                
//                Spacer(minLength: 0)
//                
//                Text("\(numberOfTestsTaken)")
//                    .foregroundStyle(.quizMain)
//                    .font(.system(size: 18))
//                    .fontWeight(.bold)// Replace with actual color
//            }
//            //.frame(maxWidth: .infinity)
//            
//        }
//        .padding()
//        .background(Color.gray.opacity(0.06))
//        .cornerRadius(15)
//        .padding(.vertical)
//    }
    
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
