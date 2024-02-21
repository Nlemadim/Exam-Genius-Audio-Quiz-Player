//
//  AudioQuizPackageView.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/20/24.
//

import SwiftUI

struct AudioQuizPackageView: View {
    var playButtonAction: () -> Void
    @State var image: String
    @State var AudioQuizName: String
    @State var isReadyToPlay: Bool = false
    var questions: [String]
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 400.0)
                .cornerRadius(30)
                .padding(.horizontal, 20)
        }
        .preferredColorScheme(.dark)
        .overlay(
            VStack(alignment: .leading, spacing: 8.0) {
                Spacer()

                HStack {
                    VStack(spacing: 0) {
                        Text(AudioQuizName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        Text("\(questions.count) Questions".uppercased())
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.leading)
                    
                    
                    Spacer()
                    Button {
                        playButtonAction()
                    } label: {
                        Text("Download")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .padding(9)
                            .background(.teal.opacity(0.5), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
     
                    Button {
                        playButtonAction()
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .cornerRadius(10)
                            .padding(9)
                            .foregroundStyle(isReadyToPlay ? .teal : .gray)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .disabled(isReadyToPlay)
       
                }
                .padding()

                .background(.ultraThinMaterial, in: Rectangle())
                .cornerRadius(30)
            }
            .shadow(radius: 10, x: 0, y: 10)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        )
    }
}

#Preview {
    AudioQuizPackageView(playButtonAction: {}, image: "SwiftProgramming", AudioQuizName: "Swift", questions: [])
}
