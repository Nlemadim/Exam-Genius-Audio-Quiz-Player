//
//  AppState.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/20/24.
//

import Foundation
import SwiftUI


class AppState: ObservableObject {
    @Published var currentState: AppStateEnum = .none
    
    init() {
       launchAppState()
    }
    
    private func launchAppState() {
        currentState = .none
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // Check for existence of UserDefaults values, default them to false if not present
            let isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
            let hasSelectedAudioQuiz = UserDefaults.standard.bool(forKey: "hasSelectedAudioQuiz")
            
            // Determine AppState based on UserDefaults values
            if !isSignedIn {
                UserDefaults.standard.set(false, forKey: "hasSelectedAudioQuiz")
                self.currentState = .signIn
            } else if isSignedIn {
                self.currentState = .signedIn
            } else if hasSelectedAudioQuiz {
                self.currentState = .audioQuizSelected
            } else {
                self.currentState = .none
            }
        }
    }
}

enum AppStateEnum {
    case firstLaunch, signIn, signedIn, audioQuizSelected, none
}




