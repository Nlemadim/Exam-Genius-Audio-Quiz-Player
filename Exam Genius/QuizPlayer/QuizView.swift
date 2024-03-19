//
//  QuizView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/9/24.
//

import SwiftUI

struct QuizView: View {
    @EnvironmentObject var user: User
    @StateObject private var generator = ColorGenerator()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                if let selectedAudioQuiz = user.selectedQuizPackage {
                    HStack(alignment: .center, spacing: 15) {
                        
                        /// Exam Icon Image
                        Image(selectedAudioQuiz.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            /// Long Name
                            Text(selectedAudioQuiz.name)
                                .font(.body)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .lineLimit(2, reservesSpace: true)
                            
                            /// Short Name
                            Text(selectedAudioQuiz.acronym)
                                .foregroundStyle(.primary)
                                .opacity(0.6)
                            
                            /// Question Number
                            Text("Questions: \(selectedAudioQuiz.questions.count)")
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

            }
            .onAppear {
                generator.updateAllColors(fromImageNamed: user.selectedQuizPackage?.name ?? "IconImage")
                //generator.updateAllColors(fromImageNamed: "BarExam-Exam")
            }
        }
        .background(
            Image( user.selectedQuizPackage?.imageUrl ?? "IconImage")
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
