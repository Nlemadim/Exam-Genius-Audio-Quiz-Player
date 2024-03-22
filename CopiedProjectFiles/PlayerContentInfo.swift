//
//  PlayerContentInfo.swift
//  Exam Genius Audio Quiz Player
//
//  Created by Tony Nlemadim on 1/15/24.
//

import Foundation
import SwiftUI

struct PlayerContentInfo: View {
    @Binding var expandSheet: Bool
    var quizPlayer: QuizPlayer
    var user: User
    var animation: Namespace.ID
    var nameSpaceText: String?

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                if !expandSheet {
                    GeometryReader { geometry in
                        Image(nameSpaceText ?? "IconImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                    }
                }
            }
            .frame(width: 45, height: 45)
            
            Text(user.selectedQuizPackage?.name ?? "Not Playing")
                .font(.callout)
                .lineLimit(2, reservesSpace: false)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            MiniQuizControlView(
                recordAction: {/*quizPlayer.recordAnswer()*/},
                
                playPauseAction: { /* Implement play/pause action */ },
                
                nextAction: { /*quizPlayer.playNextQuestion()*/ },
                
                repeatAction: {
//                    if let question = quizPlayer.currentQuestion {
//                        quizPlayer.replayQuestion(question: question)
//                    }
                }
            )
            .offset(x: 25)
             
        }
        .foregroundStyle(.teal)
        .padding(.horizontal)
        .padding(.bottom, 12)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}


