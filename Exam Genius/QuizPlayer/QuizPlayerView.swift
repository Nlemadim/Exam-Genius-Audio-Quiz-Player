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
    @State private var downloadedQuiz: DownloadedAudioQuiz? = nil
    @State var userQuizName: String = "UserQuiz"
    
    
    
    @State var interactionState: InteractionState = .idle
    
    @State var audioQuiz: DownloadedAudioQuiz?
    
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    @Query(sort: \PerformanceModel.id) var performanceCollection: [PerformanceModel]
    
//    @Query(filter: #Predicate<DownloadedAudioQuiz> { audioQuiz in
//        if audioQuiz.quizname.localizedStandardContains(userQuizName) {
//            downloadedQuiz = audioQuiz
//        }
//    }, sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    
    @State private var expandSheet: Bool = false
  
    @State var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    
    @State var currentQuestionIndex: Int = 0
    
    @State var isDownloading: Bool = false
    
//    @State var isDownloading: Bool = false {
//        didSet {
//            if let quiz = user.downloadedQuiz,
//               !quiz.questions.contains(where: { !$0.questionAudio.isEmptyOrWhiteSpace }) {
//                isDownloading = false
//            }
//        }
//    }
    
    let sharedInteractionState = SharedQuizState()


    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .center) {
                    Image(user.downloadedQuiz?.quizImage ?? "Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
                .frame(height: 280)
                .blur(radius: 60)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 5) {
                            Image(user.downloadedQuiz?.quizImage ?? "Logo")
                                .resizable()
                                .frame(width: 250, height: 250)
                                .cornerRadius(20)
                                .padding()
                            
                            Text(user.downloadedQuiz?.quizname ?? "Quiz Player")
                                .lineLimit(2, reservesSpace: true)
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .padding()
                                .hAlign(.center)
                                .frame(maxWidth: .infinity)
                                .offset(y: -30)
                        }
                        .frame(height: 280)
                        .padding()
                        .padding(.horizontal, 40)
                        .hAlign(.center)
                    }
                    .padding()
                    
                    HStack {
                        Text(user.downloadedQuiz == nil ? "Not Currently Playing" : "Now Playing")
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
                        
                        NowPlayingView(currentquiz: user.downloadedQuiz, quizPlayerObserver: quizPlayerObserver, questionCount: user.downloadedQuiz?.questions.count ?? 0, currentQuestionIndex: currentQuestionIndex, color: generator.dominantLightToneColor, interactionState: $interactionState, isDownloading: $isDownloading, playAction: {
                            
                           startPlayer()
                        })
                    }
                    .padding()
                    .padding(.horizontal)
                    
                    Divider()
                        .foregroundStyle(generator.dominantLightToneColor)
                        .activeGlow(generator.dominantLightToneColor, radius: 1)
                    
                    PerformanceHistoryGraph(history: performanceCollection, mainColor: generator.dominantLightToneColor, subColor: .themePurpleLight)
                        .padding(.horizontal)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(height: 100)
                }
            }
            .onAppear {
                fetchUserQuizName()
                updateUserQuizSelection()
                generator.updateAllColors(fromImageNamed: user.downloadedQuiz?.quizImage ?? "Logo")

            }
            .onChange(of: quizPlayerObserver.playerState) { _, newState in
                DispatchQueue.main.async {
                    syncQuizPlayerState(newState)
                }
            }
            .onChange(of: sharedInteractionState.interactionState) { _, newState in
                DispatchQueue.main.async {
                    self.interactionState = newState
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
    
    private func syncQuizPlayerState(_ playerState: QuizPlayerState) {
        switch playerState {
        case .startedPlayingQuiz:
            self.interactionState = .isNowPlaying
        case .endedQuiz:
            self.interactionState = .isDonePlaying
        case .donePlaying:
            self.interactionState = .isDonePlaying
            
        default:
            break
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
    
    func fetchUserQuizName() {
        guard let userQuizName = UserDefaults.standard.string(forKey: "userDownloadedAudioQuizName") else {
            return
        }
        
        self.userQuizName = userQuizName
    }

    
    private func updateUserQuizSelection() {
        guard let userQuizName = UserDefaults.standard.string(forKey: "userDownloadedAudioQuizName"),
              let matchingQuizPackage = downloadedAudioQuizCollection.first(where: { $0.quizname == userQuizName }),
              !matchingQuizPackage.questions.isEmpty else {
            user.downloadedQuiz = nil
            return
        }
        
        user.downloadedQuiz = matchingQuizPackage
    
    }


    
//    func laodNewAudioQuiz(quiz package: AudioQuizPackage) async  {
//        
//        guard downloadedAudioQuizCollection.isEmpty else { return }
//        
//        DispatchQueue.main.async {
//            self.interactionState = .isDownloading
//        }
//        
//        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
//       
//        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: package.name, shortTitle: package.acronym, quizImage: package.imageUrl)
//        
//        let audioQuestions = package.questions
//        
//        await contentBuilder.downloadAudioQuestions(for: audioQuestions)
//        
//        newDownloadedQuiz.questions = audioQuestions
//        
//        modelContext.insert(newDownloadedQuiz)
//        try! modelContext.save()
//        
//        DispatchQueue.main.async {
//            user.downloadedQuiz = newDownloadedQuiz
//            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
//            self.interactionState = .idle
//        }
//    }
    
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
//    return QuizPlayerView()
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
    @Binding var isDownloading: Bool
    
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
            .overlay {
                if interactionState == .isDownloading {
                    ProgressView {
                        Text("Downloading")
                    }
                    .foregroundStyle(.white)
                }
            }
            
            
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
                    CircularPlayButton(interactionState: $interactionState, isDownloading: $isDownloading, color: color, playAction: { playAction() })
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
