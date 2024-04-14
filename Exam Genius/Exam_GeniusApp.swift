//
//  Exam_GeniusApp.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/21/24.
//

import SwiftUI
import SwiftData

@main
struct Exam_GeniusApp: App {
    @StateObject var appState = AppState()
    @StateObject var user = User()
    @StateObject var quizPlayerObserver = QuizPlayerObserver()
    @StateObject var presentationManager = QuizViewPresentationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(appState)
                .environmentObject(quizPlayerObserver)
                .environmentObject(presentationManager)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self, DownloadedAudioQuiz.self])
    }
}
