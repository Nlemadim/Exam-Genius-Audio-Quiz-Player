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
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(4)
                    .padding(.leading)
                
                VStack(spacing: 8.0) {
                    Text(topicName)
                        .font(.footnote)
                        .fontWeight(.light)
                        .lineLimit(3, reservesSpace: false)
                        .hAlign(.leading)
                        .activeGlow(.white, radius: 0.4)
                    
                }
                .padding(8.0)
            }
           
        }
        .frame(height: 55)
        .background(.ultraThinMaterial)
        .foregroundColor(.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 0.5)
                .activeGlow(.white, radius: 1)
        )
    }
}

#Preview {
    RelevantTopicsCard(topicName: "Web Application Vulnerabilities Application Vulnerabilities. Application Vulnerabilities", quizImage: "COMPTIA-Security-Exam-Basic", numberOfQuestions: 23)
        .preferredColorScheme(.dark)
}
