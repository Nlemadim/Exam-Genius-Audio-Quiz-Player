//
//  QuizPlayerPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/14/24.
//

import SwiftUI

struct QuizPlayerPage: View {
    @State var backgroundImage: String = "USMLESTEP1-Exam" {
        didSet {
            if !quiz.quizImage.isEmpty {
                backgroundImage = quiz.quizImage
            }
        }
    }
    @StateObject private var generator = ColorGenerator()
    var quiz: DownloadedAudioQuizContainer
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.clear)
                .background(
                    LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                )

            
            VStack(alignment: .center) {
                if !quiz.quizImage.isEmpty {
                    Image(backgroundImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                } else {
                    Image(quiz.quizImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
            }
            .frame(height: 280)
            .blur(radius: 60)
            
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Currently Playing")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    TabView {
                        ForEach(0 ..< 5) { item in
                            CurrentQuizView(name: quiz.name, image: quiz.quizImage, color: generator.dominantDarkToneColor, numberOfQuestions: 10, playButtonAction: {})
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 380)
                    
                    VStack(alignment: .leading, spacing: 4.0){
                        Text("Most Relevant Topics")
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.horizontal)
                        HStack {
                            Text("Download questions on these topics specifically and add to your playlist")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                            Spacer()
                                
                        }
                        .padding(.horizontal)
                    }
     
                }
        }
        .onAppear {
            generator.updateDominantColor(fromImageNamed: backgroundImage)
        }
        .preferredColorScheme(.dark)

    }
}


#Preview {
    @State var package = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "USMLESTEP1-Exam")
   return QuizPlayerPage(quiz: package)
  
}
