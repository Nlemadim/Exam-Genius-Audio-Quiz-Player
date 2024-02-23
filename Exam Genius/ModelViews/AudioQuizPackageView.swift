//
//  AudioQuizPackageView.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/20/24.
//

import SwiftUI

struct AudioQuizPackageView: View {
    var quiz: AudioQuizPackage
    var downloadAction: () -> Void
    @StateObject private var generator = ColorGenerator()
    
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
                
                VStack(alignment: .leading, spacing: 16) {
                    audioLabel()
                    
                    HStack {
                        Text(quiz.name)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .lineLimit(3)
                            .bold()
                            .primaryTextStyleForeground()
                    }
                    Text(aboutQuiz)
                        .font(.subheadline)
                    
                    HStack {
                        Spacer()
                        BuildButton {
                            downloadAction()
                        }
                    }
                    .padding()
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(
                LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
            )
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(20)
            .onAppear {
                generator.updateDominantColor(fromImageNamed: quiz.imageUrl)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    var aboutQuiz: String {
        quiz.about.isEmpty ?
        "An audio quiz of at least 500 questions from more than 100 topics." : quiz.about
    }
    
    func audioLabel() -> some View {
        return  HStack {
            Text(quiz.acronym.isEmpty ? "Audio quiz" : quiz.acronym)
                .font(.footnote)
                .fontWeight(.semibold)
            Image(systemName: "headphones")
                .font(.footnote)
                .fontWeight(.semibold)
        }
    }
}

//#Preview {
//    let selectedCat: ExamCategory = .business
//    return LandingPage(selectedCategory: selectedCat)
//        .preferredColorScheme(.dark)
//        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
//}
