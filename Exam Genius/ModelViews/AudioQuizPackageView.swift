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
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 16) {
                    audioLabel()
                    
                    HStack {
                        Text(quiz.name)
                            .font(.largeTitle)
                            .bold()
                    }
                    Text(aboutQuiz)
                        .font(.subheadline)
                    
                    BuildButton {
                        downloadAction()
                    }
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(
                LinearGradient(gradient: Gradient(colors: [.themePurpleLight, .black]), startPoint: .top, endPoint: .bottom)
            )
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(20)
            
        }
        .preferredColorScheme(.dark)
    }
    
    var aboutQuiz: String {
        quiz.about.isEmpty ?
        "An audio quiz focusing on Kotlin programming language concepts. At least 500 questions from more than 100 topics before refinement." : quiz.about
    }
    
    func audioLabel() -> some View {
        return  HStack {
            Text("Audio Quiz")
                .font(.footnote)
                .fontWeight(.semibold)
            Image(systemName: "headphones")
                .font(.footnote)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    LandingPage()
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
}


//#Preview {
//    AudioQuizView(quiz: <#AudioQuizPackage#>, downloadAction: {}, startAction: {}, image: "CCNA-Exam", name: "CCNA (Cisco Certified Network Associate)Exam", isReadyToPlay: false, questions: [])
//}

struct AudioQuizView: View {
    var quiz: AudioQuizPackage
    var downloadAction: () -> Void
    var startAction: () -> Void
    @State var isReadyToPlay: Bool = false
    
    var body: some View {
        ZStack {
            // Determine the image to display based on availability of imageUrl
            if quiz.imageUrl.isEmpty {
                Image("IconImage") // Ensure this image is in your assets
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 260)
                    .cornerRadius(20)
            } else {
                Image(quiz.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 260)
                    .cornerRadius(20)
            }
            
            // Overlay for name or loading indicator
            VStack {
                Spacer()
                if quiz.name.isEmpty {
                    // Display a ProgressView if the name is empty
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    // Display the name if it's available
                    Text(quiz.name)
                        .font(.callout)
                        .lineLimit(3, reservesSpace: true)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.7))
                }
            }
        }
        .frame(width: 180, height: 260)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}



