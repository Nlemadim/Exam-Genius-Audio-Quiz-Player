//
//  HorizontalQuizListView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import SwiftUI

struct HorizontalQuizListView: View {
    var quizzes: [AudioQuizPackage]
    var title: String
    var subtitle: String?
    let tapAction: (AudioQuizPackage) -> Void

    var body: some View {
        VStack(spacing: 4.0) {
            Text(title.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .kerning(-0.5) // Reduces the default spacing between characters
                .padding(.horizontal)
                .lineLimit(1) // Ensures the text does not wrap
                .truncationMode(.tail) // Adds "..." at the end if the text is too long
                .hAlign(.leading)
                       
            if let subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .padding(.horizontal)
                    .hAlign(.leading)
                    .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(quizzes, id: \.self) { quiz in
                        ImageAndTitleView(title: quiz.acronym, titleImage: quiz.imageUrl, tapAction: tapAction, quiz: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
