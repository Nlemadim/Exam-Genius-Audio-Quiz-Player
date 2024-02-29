//
//  AudioQuizSearchCollectionView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/27/24.
//

import SwiftUI

struct AudioQuizSearchCollectionView: View {
    var quiz: AudioQuizPackage

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
                        VStack {
                            HStack {
                                Text(quiz.name.capitalized)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(3, reservesSpace: true)
                                    .bold()
                                    .foregroundColor(.white)

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(
                            Material.ultraThin
                        )
                    }
                )
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
