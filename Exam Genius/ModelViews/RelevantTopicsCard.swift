//
//  RelevantTopicsCard.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/14/24.
//

import SwiftUI

struct RelevantTopicsCard: View {
    let topicName: String
    let quizImage: String
    let numberOfQuestions: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack{
                Image(quizImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(.leading)
                
                VStack(spacing: 8.0) {
                    Text(topicName)
                        .font(.footnote)
                        .fontWeight(.light)
                        .lineLimit(3, reservesSpace: false)
                        .hAlign(.leading)
                        .activeGlow(.white, radius: 0.4)
                    //Spacer()
                    Text("\(numberOfQuestions) Questions")
                        .font(.footnote)
                        .hAlign(.leading)
                    
                }
                .padding(8.0)
            }
        }
        .frame(height: 120)
        .background(.ultraThinMaterial)
        .foregroundColor(.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 0.5)
                .activeGlow(.white, radius: 1)
        )
    }
}

#Preview {
    RelevantTopicsCard(topicName: "Web Application Vulnerabilities Application Vulnerabilities. Application Vulnerabilities", quizImage: "COMPTIA-Security-Exam-Basic", numberOfQuestions: 23)
        .preferredColorScheme(.dark)
}
