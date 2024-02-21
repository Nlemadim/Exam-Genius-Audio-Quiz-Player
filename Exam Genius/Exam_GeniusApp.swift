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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self])
    }
}
