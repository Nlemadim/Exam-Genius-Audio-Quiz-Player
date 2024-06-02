//
//  QuizPlayerObserver.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/13/24.
//

import Foundation
import SwiftUI
import Combine

class QuizPlayerObserver: ObservableObject {
    @Published var playerState: QuizPlayerState = .idle
    @Published var currentQuizId: UUID? = nil
    @Published var themeColor: Color = .themePurple
}

@Observable class QuizPlayerObserverV2 {
    var playerState: QuizPlayerState = .idle
    var currentQuizId: UUID? = nil
    var themeColor: Color = .themePurple
    var titleImage: String = "Logo"
    var title: String = "VOQA"
    var audioQuizDefaultImage: String = "IconImage"
}

enum QuizPlayerState {
    case startedPlayingQuiz
    case restartQuiz
    case pausedCurrentPlay
    case startedPlayingTopic
    case startedPlayingAd
    case startedPlayingMusic
    case endedQuiz
    case idle
    case donePlaying
    case isAwaitingResponse
    case loadingQuiz

    var status: String {
        switch self {
        case .startedPlayingQuiz:
            return "Quiz in Progress"
        case .startedPlayingTopic:
            return "Now Playing"
        case .startedPlayingAd:
            return "Sponsored"
        case .startedPlayingMusic:
            return "mp3 Song"
        case .endedQuiz:
            return "Quiz complete"
        case .idle:
            return "Start A Quiz"
        case .donePlaying:
            return "done"
        case .isAwaitingResponse:
            return "Awaiting Response"
        case .pausedCurrentPlay:
            return "Paused"
        case .restartQuiz:
            return "Restarting"
        case .loadingQuiz:
            return "Downloading"
            
        }
    }
}
