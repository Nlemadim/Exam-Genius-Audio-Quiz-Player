//
//  QuizCarouselView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import SwiftUI

struct QuizCarouselView: View {
    var quizzes: [AudioQuizPackage]
    @Binding var currentItem: Int
    @ObservedObject var generator: ColorGenerator
    @Binding var backgroundImage: String
    let tapAction: () -> Void
    
    var body: some View {
        Text("Top Picks")
            .font(.headline)
            .fontWeight(.bold)
            .padding(.horizontal)
            .hAlign(.leading)
        
        TabView(selection: $currentItem) {
            ForEach(quizzes.indices, id: \.self) { index in
                let quiz = quizzes[index]
                VStack(spacing: 4) {
                    Image(quiz.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 240, height: 240)
                        .cornerRadius(15.0)
                    
                    Text(quiz.acronym)
                        .font(.callout)
                        .fontWeight(.black)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .frame(width: 180)
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                }
                .onTapGesture {
                    tapAction()
                }
                .onAppear {
                    generator.updateAllColors(fromImageNamed: quiz.imageUrl)
                    backgroundImage = quiz.imageUrl // Update background
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 350)
    }
}
