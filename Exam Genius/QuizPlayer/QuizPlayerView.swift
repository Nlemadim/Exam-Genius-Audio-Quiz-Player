//
//  QuizPlayerView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/18/24.
//

import SwiftUI
import SwiftData


struct QuizPlayerView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @StateObject private var generator = ColorGenerator()
    @StateObject private var audioContentPlayer = AudioContentPlayer()
    
    @State var interactionState: InteractionState = .idle
    
    @State var audioQuiz: DownloadedAudioQuiz?
    
    @Binding var audioQuizPacket: AudioQuizPackage?
    
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    
    @State var currentQuestionIndex: Int = 0
    
    init(audioQuizPacket: Binding<AudioQuizPackage?>) {
        _audioQuizPacket = audioQuizPacket
    }
    
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
                                .frame(maxWidth: .infinity)
                                .offset(y: -30)
                        }
                        .frame(height: 300)
                        .padding()
                        .padding(.horizontal, 40)
                        .hAlign(.center)
                    }
                    .padding()
                    
                    HStack {
                        Text(self.audioQuiz == nil ? "Not Currently Playing" : "Now Playing")
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
                        
                        NowPlayingView(currentquiz: audioQuiz, quizPlayerObserver: quizPlayerObserver, questionCount: audioQuiz?.questions.count ?? 0, currentQuestionIndex: currentQuestionIndex, color: generator.dominantLightToneColor, interactionState: $interactionState, playAction: {
                            
                           startPlayer()
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
            .onAppear {
                generator.updateAllColors(fromImageNamed: self.audioQuiz?.quizImage ?? "Logo")
                print("\(self.audioQuizPacket?.name ?? "Packet is Nil")")
            }
            .onChange(of: audioQuizPacket) { _, newPackage in
                if newPackage != nil {
                    updateViewWithPackage()
                } else {
                    print("New Packet is Nil")
                }
            }
            .onChange(of: audioQuizPacket) {_, newPackage in
                if let package = newPackage, !package.questions.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        Task {
                            try await loadNewQuiz(audioQuizPackage: package)
                        }
                    }
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
    
    private func startPlayer() {
        DispatchQueue.main.async {
            if self.interactionState != .isNowPlaying {
                self.quizPlayerObserver.playerState = .startedPlayingQuiz
                self.interactionState = .isNowPlaying
            } else {
                self.interactionState = .isDonePlaying
                self.quizPlayerObserver.playerState = .idle
            }
        }
    }
    
    func updateViewWithPackage() {
        if let package = self.audioQuizPacket {
            self.loadNewUserQuiz(package)
        }
    }
    
    func loadNewUserQuiz(_ newPackage: AudioQuizPackage?) {
        if let package = newPackage {
            
            let newDownloadedQuiz = DownloadedAudioQuiz(quizname: package.name, shortTitle: package.acronym, quizImage: package.imageUrl)
            self.audioQuiz = newDownloadedQuiz
            user.downloadedQuiz = self.audioQuiz
            
            modelContext.insert(newDownloadedQuiz)
            try! modelContext.save()
        }
    }
    
    func loadNewQuiz(audioQuizPackage: AudioQuizPackage) async throws {
        guard !audioQuizPackage.questions.isEmpty else {
            print("No questions in Packet")
            return
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        
        let questions = audioQuizPackage.questions
        await contentBuilder.downloadAudioQuestions(for: questions)
        
        self.audioQuiz?.questions = questions
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
    
}




//#Preview {
//    let user = User()
//    let appState = AppState()
//    let observer = QuizPlayerObserver()
//    let presentMgr = QuizViewPresentationManager()
//    let audioQuiz = AudioQuizPackage(id: UUID(), name: "Quick Math", imageUrl: "Math-Exam")
//    return QuizPlayerView(audioQuizPacket: .constant(audioQuiz))
//        .environmentObject(user)
//        .environmentObject(appState)
//        .environmentObject(observer)
//        .preferredColorScheme(.dark)
//        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self, DownloadedAudioQuiz.self, VoiceFeedbackMessages.self], inMemory: true)
//    
//}



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
//    .background(
//        LinearGradient(colors: [Color.white.opacity(0), Color.white.opacity(0.1)], startPoint: .top, endPoint: .bottom)
//    )
//    .clipShape(RoundedRectangle(cornerRadius: 12))
//    .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 1)



//    func loadUserPackage() {
//        guard let userPackageName = UserDefaults.standard.string(forKey: "userSelectedPackageName"),
//              let matchingQuizPackage = audioQuizCollection.first(where: { $0.name == userPackageName }),
//              !matchingQuizPackage.questions.isEmpty else {
//            user.selectedQuizPackage = nil
//            return
//        }
//        user.selectedQuizPackage = matchingQuizPackage
//    }


//    func currentQuiz() -> DownloadedAudioQuizContainer {
//        let audioQuiz: DownloadedAudioQuizContainer = DownloadedAudioQuizContainer(name: "Quick Math", quizImage: "Math-Exam")
//        return audioQuiz
//    }
