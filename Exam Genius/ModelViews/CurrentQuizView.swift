//
//  CurrentQuizView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/14/24.
//

import Foundation
import SwiftUI

struct CurrentQuizView: View {
    var name: String
    var image: String
    var color: Color
    var numberOfQuestions: Int
    var playButtonAction: () -> Void

    var body: some View {
        ZStack { // Use ZStack to layer the image behind the content
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill) // Fill the available space
                .frame(height: 320.0) // Match the height of the container
                .cornerRadius(30)
                //.blur(radius: 2) // Apply blur to the image
                .padding(.horizontal, 20) // Match the horizontal padding of the container

            VStack(alignment: .leading, spacing: 8.0) {
                VStack(alignment: .center) {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(height: 180)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                      
                }
          
                Text(name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .activeGlow(.white, radius: 0.4)
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.leading)
                
                PlayPauseButton(isDownloading: .constant(false), isPlaying: .constant(false), color: color, playAction: {
                    playButtonAction()
                    
                })

            }
            .padding(.all, 25.0)
            .padding(.vertical, 20)
            .frame(height: 350.0)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(radius: 10, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
        .preferredColorScheme(.dark)
    }
}


struct RecentScoreCard: View {
    let quizImage: String
    let numberOfQuestions: Int
    let score: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack{
                Image(quizImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .padding(.leading)
                
                VStack(spacing: 8.0) {
                    Text("\(numberOfQuestions) Questions")
                        .font(.footnote)
                        .hAlign(.leading)
                    
                    Text("\(score)%")
                        .font(.footnote)
                        .fontWeight(.light)
                        .hAlign(.leading)
                        .activeGlow(.white, radius: 0.8)
                }
            }
        }
        .frame(height: 54)
        .background(.ultraThinMaterial)
        .foregroundColor(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 0.5)
                .activeGlow(.white, radius: 1)
        )
    }
}

struct CurrentQuizViewV2: View {
    var image: String
    var buttonLabel: String?
    var color: Color
    var backgroundImage: String?
    var numberOfQuestions: Int
    var numberOfQuizzes: Int
    var questionsAnswered: Int
    var highScore: Int
    var numberOfTopics: Int
    var isDisabled: Bool?
    var playButtonAction: () -> Void
    
    let generator = ColorGenerator()

    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 12.0) {
                VStack(alignment: .center) {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(30)
                        .frame(height: 150)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                      
                }
               
                VStack(alignment: .leading, spacing: 12.0) {
                    LabeledContent("Number of Topics", value: "\(numberOfTopics)")
                    LabeledContent("Number of Questions", value: "\(numberOfQuestions)")
                    LabeledContent("Questions Answered", value: "\(questionsAnswered)")
                    LabeledContent("Quizzes Completed", value: "\(numberOfQuestions)")
                    LabeledContent("Current High Score", value: "\(highScore)%")
                }
                
                VStack {
                    
                    PlainClearButton(color: color, label: buttonLabel ?? "Start", image: nil, isDisabled: nil, playAction: { playButtonAction() })
                }
                .padding()
            }
            .padding(.all, 20.0)
            .padding(.vertical, 20)
            .background(generator.dominantDarkToneColor, in: RoundedRectangle(cornerRadius: 35, style: .continuous))
            .padding(.horizontal, 20)
        }
        .onAppear {
            generator.updateAllColors(fromImageNamed: image)
        }
        .preferredColorScheme(.dark)
    }
}
