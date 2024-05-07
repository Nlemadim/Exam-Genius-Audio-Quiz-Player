//
//  QuizViewPresentationManager.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/13/24.
//

import Foundation

class QuizViewPresentationManager: ObservableObject {
    @Published var shouldShowFullScreen: Bool = false

    var expandSheet: Bool = false {
        didSet {
            updateShouldShowFullScreen()
        }
    }

    var interactionState: InteractionState = .idle {
        didSet {
            updateShouldShowFullScreen()
        }
    }
    
    

    private func updateShouldShowFullScreen() {
        shouldShowFullScreen = expandSheet && interactionState == .isNowPlaying 
    }
}
