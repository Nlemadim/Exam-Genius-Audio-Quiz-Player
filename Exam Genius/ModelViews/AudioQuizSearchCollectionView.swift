//
//  AudioQuizSearchCollectionView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/27/24.
//

import SwiftUI

struct AudioQuizSearchCollectionView: View {
    var quiz: AudioQuizPackage
    @StateObject private var generator = ColorGenerator()

    var body: some View {
        VStack {
            Image(quiz.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 260) // Adjusted size
                .cornerRadius(20)
                .overlay(
                    VStack {
                        Spacer()
                        // Encapsulate text within a background
                        VStack {
                            Text(quiz.acronym)
                                .font(.subheadline)
                                .lineLimit(2, reservesSpace: true)
                                .bold()
                                .foregroundColor(.white)
                                .padding(5) // Adjust padding for text
                        }
                        .frame(width: 200, height: 60) // Fixed size background
                        .background(
                            generator.dominantBackgroundColor
                        )
                        .onAppear {
                            generator.updateDominantColor(fromImageNamed: quiz.imageUrl)
                        }
                    }
                )
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
