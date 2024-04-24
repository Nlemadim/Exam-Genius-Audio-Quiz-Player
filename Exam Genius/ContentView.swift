//
//  ContentView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
   
    var body: some View {
        switch appState.currentState {
        case .firstLaunch:
            LaunchPage()
            
        case .signIn:
            SignInPage()
            
        case .signedIn:
            HomePage()
            
        case .audioQuizSelected:
            HomePage()
            
        case .none:
            LaunchPage()
        }
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    return ContentView()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self, DownloadedAudioQuiz.self, VoiceFeedbackMessages.self], inMemory: true)
        
}
