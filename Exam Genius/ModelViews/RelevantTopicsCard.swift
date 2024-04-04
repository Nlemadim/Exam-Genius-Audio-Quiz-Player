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

#Preview {
    LibraryItemView(title: "Web Application Vulnerabilities", titleImage: "COMPTIA-Security-Exam-Basic", interactionState: .constant(.idle), isDownlaoded: .constant(false))
        .preferredColorScheme(.dark)
}


struct LibraryItemView: View {
    let title: String
    let titleImage: String
    var audioFile: String?
    var audioCollection: [String]?
    @Binding var interactionState: InteractionState
    @Binding var isDownlaoded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Image(titleImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(4)
                    .padding(.leading)
                
                VStack(spacing: 2.0) {
                    Text(title)
                        .font(.footnote)
                        .fontWeight(.light)
                        .lineLimit(2, reservesSpace: true)
                        .hAlign(.leading)
                        .activeGlow(.white, radius: 0.4)
                    
                    
                    HStack {
                        Button(!isDownlaoded ? "Download" : "Play" ) {
                            
                        }
                        //.buttonStyle(.bordered)
                        .font(.footnote)
                        .hAlign(.leading)
                        
                        SpinnerView()
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .opacity(interactionState == .isDownloading ? 1 : 0)
                    }
                    

                }
                .padding(8.0)
            }
        }
        .frame(height: 75)
        .background(.clear)
        .foregroundColor(.white)
        .cornerRadius(5)
//        .overlay(
//            Rectangle()
//                .stroke(Color.gray, lineWidth: 0.5)
//            
//        )
    }
}

