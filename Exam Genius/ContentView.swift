//
//  ContentView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @EnvironmentObject var presentationManager: QuizViewPresentationManager
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @StateObject private var generator = ColorGenerator()
    let quizDataManager = QuizDataManager()
    
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    @Query(sort: \VoiceFeedbackMessages.id) var voiceFeedbackMessages: [VoiceFeedbackMessages]
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    
    var body: some View {
        VStack {
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
        .task {
            await loadMainDefaultCollection()
            await loadMainVoiceFeedBackMessages()
        }
        .onAppear {
            UserDefaultsManager.setDefaultNumberOfTestQuestions(15)
            UserDefaultsManager.setDefaultResponseTime()
            loadUserMainPackage()
            fetchDownloadedMainAudioQuiz()
        }
    }
    
    private func loadMainDefaultCollection() async {
        guard audioQuizCollection.isEmpty else { return }
        
        let collection = DefaultDatabase().getAllExamDetails()
        collection.forEach { examDetail in
            
            let newPackage = AudioQuizPackage(from: examDetail)
            
            modelContext.insert(newPackage)
            
            try! modelContext.save()
        }
    }
    
    private func loadMainVoiceFeedBackMessages() async {
        guard voiceFeedbackMessages.isEmpty else { return }
        
        let messageData = await quizDataManager.downloadAllFeedbackAudio()
        let newVoiceMessages = VoiceFeedbackMessages(from: messageData)
        
        modelContext.insert(newVoiceMessages)
        
        try! modelContext.save()
    }
    
    func loadUserMainPackage() {
        let quizTitle = UserDefaultsManager.quizName()
        guard let userPacket = audioQuizCollection.first(where: { $0.name == quizTitle }),
        !userPacket.questions.isEmpty else {
            print("Content View did not find quiz package in collection")
            user.selectedQuizPackage = nil
            return
        }
        print("Content view has assigned package to user")
        user.selectedQuizPackage = userPacket
        generator.updateAllColors(fromImageNamed: userPacket.name)
        UserDefaultsManager.setQuizName(quizName: userPacket.name)
       
    }
    
    func fetchDownloadedMainAudioQuiz() {
        guard !downloadedAudioQuizCollection.isEmpty else { return }
        let quizTitle = UserDefaultsManager.quizName()
        guard let userAudioQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == quizTitle }),
        
        !userAudioQuiz.questions.isEmpty else {
            print("Content View did not find downloaded quiz in collection")
            user.downloadedQuiz = nil
            return
        }
        
       // user.downloadedQuiz = userAudioQuiz
        print("Assigned User Downloaded Quiz")
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    let observer = QuizPlayerObserver()
    let presentMgr = QuizViewPresentationManager()
    return ContentView()
        .environmentObject(user)
        .environmentObject(appState)
        .environmentObject(observer)
        .environmentObject(presentMgr)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self, DownloadedAudioQuiz.self, VoiceFeedbackMessages.self], inMemory: true)
    
}


/*@Environment(\.scenePhase) var scenePhase
 
 var body: some View {
 Text("Example Text")
 .onChange(of: scenePhase) { newPhase in
 if newPhase == .inactive {
 print("Inactive")
 // Handle logic when the app becomes inactive (e.g., call comes in)
 } else if newPhase == .active {
 print("Active")
 // Handle logic when the app becomes active (foreground)
 } else if newPhase == .background {
 print("Background")
 // Handle logic when the app goes to the background
 }
 }
 }
 }*/
