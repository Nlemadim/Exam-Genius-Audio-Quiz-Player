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
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @EnvironmentObject var presentationManager: QuizViewPresentationManager
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
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
                QuizPlayerView()
                
            case .none:
                LaunchPage()
            }
        }
        .task {
            await loadMainDefaultCollection()
            await loadMainVoiceFeedBackMessages()
        }
        .onAppear {
            fetchDownloadedMainAudioQuiz()
        }
        .onChange(of: user.selectedQuizPackage, { _, audioQuiz in
            if let audioQuiz = audioQuiz {
                Task {
                    await downlaodNewAudioQuiz(quiz: audioQuiz)
                }
            }
        })
        .onChange(of: user.downloadedQuiz, { _, _ in
            fetchDownloadedMainAudioQuiz()
        })
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
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        let container = VoiceFeedbackContainer(
            id: UUID(),
            quizStartMessage: "Starting a new quiz now.",
            quizEndingMessage: "Great job! This quiz is now complete.",
            correctAnswerCallout: "That's the correct Answer!",
            skipQuestionMessage: "Thats an invalid response. Skipping this question for now.",
            errorTranscriptionMessage: "Error transcribing your response. Skipping this question for now.",
            finalScoreMessage: "Calculating you final score...",
            quizStartAudioUrl: "",
            quizEndingAudioUrl: "",
            correctAnswerCalloutUrl: "",
            skipQuestionAudioUrl: "",
            errorTranscriptionAudioUrl: "",
            finalScoreAudioUrl: ""
        )
        
        let messageData = await contentBuilder.downloadAllFeedbackAudio(for: container)
        let newVoiceMessages = VoiceFeedbackMessages(from: messageData)
        print("Downloaded new voice feedback messages with id \(newVoiceMessages.id.uuidString) and testing file path start quiz is printing: \(newVoiceMessages.quizEndingAudioUrl)")
        
        modelContext.insert(newVoiceMessages)
        
        try! modelContext.save()
        
    }
    
    private func downlaodNewAudioQuiz(quiz package: AudioQuizPackage) async  {
        //Please Modify guard statement to check that package name is not already contained in collection
        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) else { return }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
       
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: package.name, shortTitle: package.acronym, quizImage: package.imageUrl)
        
        let audioQuestions = package.questions
        
        await contentBuilder.downloadAudioQuestions(for: audioQuestions)
        
        newDownloadedQuiz.questions = audioQuestions
        
        modelContext.insert(newDownloadedQuiz)
        try! modelContext.save()
        
        DispatchQueue.main.async {
            user.downloadedQuiz = newDownloadedQuiz
            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
        }
    }
    
    func loadUserMainPackage() {
        guard let userPackageName = UserDefaults.standard.string(forKey: "userSelectedPackageName"),
              let matchingQuizPackage = audioQuizCollection.first(where: { $0.name == userPackageName }),
              !matchingQuizPackage.questions.isEmpty else {
            user.selectedQuizPackage = nil
            return
        }
        user.selectedQuizPackage = matchingQuizPackage
    }
    
    func fetchDownloadedMainAudioQuiz() {
        guard !downloadedAudioQuizCollection.isEmpty else { return }
        guard let userQuizName = UserDefaults.standard.string(forKey: "userDownloadedAudioQuizName"),
              let matchingQuizPackage = downloadedAudioQuizCollection.first(where: { $0.quizname == userQuizName }),
              !matchingQuizPackage.questions.isEmpty else {
            user.downloadedQuiz = nil
            return
        }
        
        user.downloadedQuiz = matchingQuizPackage
    }
    
//    func loadUserMainQuiz() {
//        guard !downloadedAudioQuizCollection.isEmpty else { return }
//        let newQuiz = downloadedAudioQuizCollection.first
//        user.downloadedQuiz = newQuiz
//        print("loaded new user quiz: \(String(describing: user.downloadedQuiz?.quizname))")
//    }
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
