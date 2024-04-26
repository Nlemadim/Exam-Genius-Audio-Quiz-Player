//
//  QuizPlayerView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/18/24.
//

import SwiftUI
import SwiftData
import Combine
import AVKit

struct QuizPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @StateObject private var generator = ColorGenerator()
    @StateObject private var audioContentPlayer = AudioContentPlayer()
    
    @State private var currentQuestion: Question?
    @State var interactionState: InteractionState = .idle
    @State var audioQuiz: DownloadedAudioQuiz?
    
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    
    @State var currentQuestionIndex: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .center) {
                    Image(audioQuiz?.quizImage ?? "Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
                .frame(height: 280)
                .blur(radius: 60)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 5) {
                            Image(audioQuiz?.quizImage ?? "Logo")
                                .resizable()
                                .frame(width: 250, height: 250)
                                .cornerRadius(20)
                                .padding()
                            
                            Text(audioQuiz?.quizname ?? "Quiz Player")
                                .lineLimit(2, reservesSpace: true)
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .padding()
                                .hAlign(.center)
                                .offset(y: -30)
                        }
                        .frame(height: 300)
                        .padding()
                        .padding(.horizontal, 40)
                        .hAlign(.center)
                    }
                    .padding()
                    
                    HStack {
                        Text(downloadedAudioQuizCollection.isEmpty ? "Not Currently Playing" : "Now Playing")
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                        
                    
                    Divider()
                        .foregroundStyle(generator.dominantLightToneColor)
                        .activeGlow(generator.dominantLightToneColor, radius: 1)
                    
                    VStack {
                        
                        NowPlayingView(currentquiz: audioQuiz, quizPlayerObserver: quizPlayerObserver, questionCount: 25, currentQuestionIndex: 1, color: generator.dominantLightToneColor, interactionState: $interactionState, playAction: {
                            
                            playSingleQuizQuestion()
                        })
                       
                    }
                    .padding()
                    .padding(.horizontal)
                    
                    Divider()
                        .foregroundStyle(generator.dominantLightToneColor)
                        .activeGlow(generator.dominantLightToneColor, radius: 1)
                    
                    PerformanceHistoryGraph(history: [
                        Performance(id: UUID(), date: Date(), score: 40),
                        Performance(id: UUID(), date: Date(), score: 80),
                        Performance(id: UUID(), date: Date(), score: 30),
                        Performance(id: UUID(), date: Date(), score: 90),
                        Performance(id: UUID(), date: Date(), score: 30),
                        Performance(id: UUID(), date: Date(), score: 20),
                        Performance(id: UUID(), date: Date(), score: 70)
                    ], mainColor: generator.dominantBackgroundColor.opacity(3), subColor: generator.dominantLightToneColor.opacity(3))
                    .padding(.horizontal)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(height: 100)
                }
            }
            .onChange(of: user.selectedQuizPackage) { _, newPackage in
                updateViewWithPackage(newPackage)
            }
            .onAppear {
                generator.updateAllColors(fromImageNamed: audioQuiz?.quizImage ?? "Logo")
                Task {
                    try await loadNewQuiz()
                }

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { /*  shareAction() */}, label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20.0)
                    })
                }
            }
        }
    }
    
    func updateViewWithPackage(_ newPackage: AudioQuizPackage?) {
        if let package = newPackage, !package.questions.isEmpty {
            Task {
                try await loadNewUserQuiz(package)
            }
        }
    }
    
    func loadNewUserQuiz(_ newPackage: AudioQuizPackage) async throws {
       

        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: newPackage.name, quizImage: newPackage.imageUrl)
        newDownloadedQuiz.questions = newPackage.questions
        
        // Initialize and use the ContentBuilder to download audio for the questions
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        
        // Assuming `downloadAudioQuestions` is asynchronous and might throw, handle with try await
        await contentBuilder.downloadAudioQuestions(for: newDownloadedQuiz.questions)
        
        print("Downloaded 1 audio file for question: \(newDownloadedQuiz.questions[0].id) with audiofile path: \(newDownloadedQuiz.questions[0].questionAudio)")
        
        // Insert the new quiz into the model context and save it
        //modelContext.insert(newDownloadedQuiz)
       // try modelContext.save()
    }
    
    func loadNewQuiz() async throws {
        
        guard !audioQuizCollection.isEmpty else { return }
        
        guard downloadedAudioQuizCollection.isEmpty else { return }
        
        guard let quizPackage = user.selectedQuizPackage, !quizPackage.questions.isEmpty else { return }
        
        // Prepare the new quiz package with the associated questions
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: quizPackage.name, quizImage: quizPackage.imageUrl)
        newDownloadedQuiz.questions = quizPackage.questions
        
        // Initialize and use the ContentBuilder to download audio for the questions
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        
        // Assuming `downloadAudioQuestions` is asynchronous and might throw, handle with try await
        await contentBuilder.downloadAudioQuestions(for: newDownloadedQuiz.questions)
        
        print("Downloaded 1 audio file for question: \(newDownloadedQuiz.questions[0].id) with audiofile path: \(newDownloadedQuiz.questions[0].questionAudio)")
        
        // Insert the new quiz into the model context and save it
        //modelContext.insert(newDownloadedQuiz)
       // try modelContext.save()
    }
    
    private func playSingleQuizQuestion() {
        // Access the current quiz package safely
        guard let package = self.audioQuiz else {
           
            return
        }
        
        guard !package.questions.isEmpty else {
            print("Mini Player error: No available questions in the package")
            return
        }
        
        let question = package.questions[self.currentQuestionIndex]
        
        let audioFile = question.questionAudio
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            audioContentPlayer.playAudioFile(audioFile)
            
        }
    }
    
    func loadUserPackage() {
        guard let userPackageName = UserDefaults.standard.string(forKey: "userSelectedPackageName"),
              let matchingQuizPackage = audioQuizCollection.first(where: { $0.name == userPackageName }),
              !matchingQuizPackage.questions.isEmpty else {
            user.selectedQuizPackage = nil
            return
        }
        user.selectedQuizPackage = matchingQuizPackage
    }

    
    func currentQuiz() -> DownloadedAudioQuizContainer {
        let audioQuiz: DownloadedAudioQuizContainer = DownloadedAudioQuizContainer(name: "Quick Math", quizImage: "Math-Exam")
        return audioQuiz
    }
}

struct NowPlayingView: View {
    var currentquiz: DownloadedAudioQuiz?
    var quizPlayerObserver: QuizPlayerObserver
    var questionCount: Int
    var currentQuestionIndex: Int
    var color: Color
    @Binding var interactionState: InteractionState
    
    var playAction: () -> Void
    
    var body: some View {
        
        HStack {
            VStack(spacing: 4) {
                Image(currentquiz?.quizImage ?? "IconImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    
            }
            .frame(height: 150)
            
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(currentquiz?.quizname.uppercased() ?? "Empty")
                    .font(.title3)
                    .fontWeight(.semibold)
                    
                
                HStack(spacing: 12) {
                    Text("Audio Quiz")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    
                    Image(systemName: "headphones")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                
                Text("Question: \(currentQuestionIndex)/ \(questionCount)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Spacer()
                    CircularPlayButton(interactionState: $interactionState, isDownloading: .constant(false), color: color, playAction: { playAction() })
                }
                .padding()
            }
            .padding(.top, 5)
            .frame(height: 150)
            .padding(.horizontal, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
}


#Preview {
    let user = User()
    let appState = AppState()
    let observer = QuizPlayerObserver()
    let presentMgr = QuizViewPresentationManager()
    return QuizPlayerView()
        .environmentObject(user)
        .environmentObject(appState)
        .environmentObject(observer)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self, DownloadedAudioQuiz.self, VoiceFeedbackMessages.self], inMemory: true)
  
}


//    .background(
//        LinearGradient(colors: [Color.white.opacity(0), Color.white.opacity(0.1)], startPoint: .top, endPoint: .bottom)
//    )
//    .clipShape(RoundedRectangle(cornerRadius: 12))
//    .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 1)
