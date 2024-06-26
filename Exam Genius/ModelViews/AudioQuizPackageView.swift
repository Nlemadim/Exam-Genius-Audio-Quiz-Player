//
//  AudioQuizPackageView.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/20/24.
//

import SwiftUI

struct AudioQuizPackageView: View {
    @StateObject private var generator = ColorGenerator()
    var quiz: AudioQuizPackage
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                GeometryReader { geometry in
                    if quiz.imageUrl.isEmpty {
                        Image("IconImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    } else {
                        Image(quiz.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                }
                .frame(height: 200)
                .frame(maxHeight: 200)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(quiz.name)
                        .font(.title3)
                        .fontWeight(.heavy)
                        .lineLimit(2, reservesSpace: false)
                        .multilineTextAlignment(.leading)
                        .bold()
                        .primaryTextStyleForeground()


                    audioLabel()
                    
                    Spacer()

                }
                .padding(.all, 10.0)
                .padding(.horizontal, 5)
                .frame(height: 120)

            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(
                LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
            )
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(10)
            
        }
        .onAppear {
            generator.updateDominantColor(fromImageNamed: quiz.imageUrl)
        }
        .preferredColorScheme(.dark)

    }
    
    var aboutQuiz: String {
        quiz.about.isEmpty ?
        "An audio quiz of at least 500 questions from more than 100 topics." : quiz.about
    }
    
    func audioLabel() -> some View {
        return  HStack {
            Text(quiz.acronym.isEmpty ? "Audio quiz" : quiz.acronym + " Audio Quiz")
                .font(.footnote)
                .fontWeight(.semibold)
            Image(systemName: "headphones")
                .font(.footnote)
                .fontWeight(.semibold)
        }
    }
}


struct AudioQuizPackageViewV2: View {
    @StateObject private var generator = ColorGenerator()
    var quiz: AudioQuizPackage
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                GeometryReader { geometry in
                    if quiz.imageUrl.isEmpty {
                        Image("IconImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    } else {
                        Image(quiz.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                }
                .frame(height: 200)
                .frame(maxHeight: 200)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(quiz.name)
                        .font(.title3)
                        .fontWeight(.heavy)
                        .lineLimit(2, reservesSpace: false)
                        .multilineTextAlignment(.leading)
                        .bold()
                        .primaryTextStyleForeground()


                    audioLabel()
                    
                    Spacer()

                }
                .padding(.all, 10.0)
                .padding(.horizontal, 5)
                .frame(height: 120)

            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(
                LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
            )
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(10)
            
        }
        .onAppear {
            generator.updateDominantColor(fromImageNamed: quiz.imageUrl)
        }
        .preferredColorScheme(.dark)

    }
    
    var aboutQuiz: String {
        quiz.about.isEmpty ?
        "An audio quiz of at least 500 questions from more than 100 topics." : quiz.about
    }
    
    func audioLabel() -> some View {
        return  HStack {
            Text(quiz.acronym.isEmpty ? "Audio quiz" : quiz.acronym + " Audio Quiz")
                .font(.footnote)
                .fontWeight(.semibold)
            Image(systemName: "headphones")
                .font(.footnote)
                .fontWeight(.semibold)
        }
    }
}

