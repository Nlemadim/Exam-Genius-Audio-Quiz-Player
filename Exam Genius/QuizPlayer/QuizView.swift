//
//  QuizView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/9/24.
//

import SwiftUI

struct QuizView: View {
    @State var audioQuiz: AudioQuizPackage
    @StateObject private var generator = ColorGenerator()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(alignment: .center, spacing: 15) {
                    
                    /// Exam Icon Image
                    Image(audioQuiz.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        /// Long Name
                        Text(audioQuiz.name)
                            .font(.body)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .lineLimit(2, reservesSpace: true)
                        
                        /// Short Name
                        Text(audioQuiz.acronym)
                            .foregroundStyle(.primary)
                            .opacity(0.6)
                        
                        /// Question Number
                        Text("Questions: \(audioQuiz.questions.count)")
                            .foregroundStyle(.secondary)
                            .opacity(0.6)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                }
                .padding(.horizontal)
                
                VStack(alignment: .center) {
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 500)
                .padding(.top,10)
                .background(
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(generator.dominantDarkToneColor)
                        .padding(.horizontal)
                
                )
                
                Spacer()
            }
            .onAppear {
                generator.updateDominantColor(fromImageNamed: audioQuiz.name)
                //generator.updateAllColors(fromImageNamed: "BarExam-Exam")
            }
        }
        .background(
            Image("BarExam-Exam")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 140)
        
        )
    }
}

//#Preview {
//    QuizView(audioQuiz: <#AudioQuizPackage#>)
//        .preferredColorScheme(.dark)
//}

struct PlayerContent {
    var titleImage: Image
    var title: String
    var shortTitle: String
    var questions: [String] = []
}
