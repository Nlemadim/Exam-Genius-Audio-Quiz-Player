//
//  LandingPageViewModel.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/6/24.
//

import Foundation
import SwiftUI
import Combine


extension LandingPage {
    @Observable
    class LandingPageViewModel: ObservableObject {
        typealias QuizBuilder = AudioQuizPlaylistView.QuizBuilder
        private let networkService: NetworkService = NetworkService.shared
        
        let quizBuilderInstance = QuizBuilder()
        let quizPlayer = QuizPlayer.shared
        
        private var cancellables = Set<AnyCancellable>()
        //        var isFinishedPlaying: (Bool) -> Void
        
        //        func monitorPlaybackCompletion() {
        //                quizPlayer.$isFinishedPlaying
        //                    .receive(on: DispatchQueue.main)
        //                    .sink {  isFinished in
        //                        if isFinished {
        //                            self.isFinishedPlaying(isFinished)
        //                            // Additional logic...
        //                        }
        //                    }
        //                    .store(in: &cancellables) // This should work if `cancellables` is a class property
        //            }
        
        
        //        init() {
        //            monitorPlaybackCompletion()
        //        }
        
    }
}
