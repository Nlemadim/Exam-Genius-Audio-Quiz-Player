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
    
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    @Query(sort: \PerformanceModel.quizName) var performanceCollection: [PerformanceModel]
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State private var downloadedQuiz: DownloadedAudioQuiz? = nil
    @State private var answeredQuestions: Int = UserDefaultsManager.totalQuestionsAnswered()
    @State private var quizzesCompleted: Int = UserDefaultsManager.numberOfQuizSessions()
    @State var interactionState: InteractionState = .idle
    @State var audioQuiz: DownloadedAudioQuiz?
    @State var currentPerformance: [PerformanceModel] = []
    
    @Binding var refreshAudioQuiz: Bool
    
    @State private var expandSheet: Bool = false
    @State var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    @State var isDownloading: Bool = false
    @State var isUsingMic: Bool = false
    
    @State var currentQuestionIndex: Int = 0
    @State var userHighScore: Int = 0
    
    @State var quizName = UserDefaultsManager.quizName()
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
                            
                            VStack(spacing: 0) {
      
                                Text(user.downloadedQuiz?.quizname ??  "VOQA")
                                    .lineLimit(2, reservesSpace: true)
                                    .multilineTextAlignment(.center)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    //.padding()
                                    .hAlign(.center)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 280)
                        .padding()
                        .padding(.horizontal, 40)
                        .hAlign(.center)
                    }
                    .padding()
                    
                    Divider()
                        .foregroundStyle(generator.dominantLightToneColor)
                        .activeGlow(generator.dominantLightToneColor, radius: 1)
                    
                    VStack {
                        
                        NowPlayingView(currentquiz: user.downloadedQuiz, quizPlayerObserver: quizPlayerObserver, generator: generator, questionCount: user.downloadedQuiz?.questions.count ?? 0, currentQuestionIndex: currentQuestionIndex, color: generator.dominantLightToneColor, interactionState: $interactionState, isDownloading: $isDownloading, playAction: {
                            if self.quizPlayerObserver.playerState == .endedQuiz || quizPlayerObserver.playerState == .idle {
                                startPlayer()
                            } else {
                                self.quizPlayerObserver.playerState = .restartQuiz
                            }
                        })
                    }
                    .padding()
                    .padding(.horizontal)
                    
                    Divider()
                        .foregroundStyle(generator.dominantLightToneColor)
                        .activeGlow(generator.dominantLightToneColor, radius: 1)
                    
                    PerformanceHistoryGraph(history: currentPerformance, mainColor: generator.enhancedDominantColor, subColor: generator.enhancedDominantColor)
                        .padding(.horizontal)
                    
                    VStack {
                        HeaderView(title: "Summary")
                            .padding()
                        
                        ActivityInfoView(answeredQuestions: answeredQuestions, quizzesCompleted: quizzesCompleted, highScore: userHighScore, numberOfTestsTaken: 0)
                    }
                    
                    
                    Rectangle()
                        .fill(.black)
                        .frame(height: 100)
                }
            }
            .onAppear {
                updateUserQuizSelection()
                filterPerformanceCollection()
                generator.updateAllColors(fromImageNamed: user.downloadedQuiz?.quizImage ?? "Logo")

            }
            .onChange(of: user.downloadedQuiz, { _, _ in
                updateUserQuizSelection()
            })
            .onChange(of: performanceCollection, { _, _ in
                filterPerformanceCollection()
            })
            .onChange(of: quizPlayerObserver.playerState) { _, newState in
                DispatchQueue.main.async {
                    syncQuizPlayerState(newState)
                    print("QuizPlayer has Updated Player State")
                }
            }
            .onChange(of: sharedInteractionState.interactionState) { _, newState in
                DispatchQueue.main.async {
                    self.interactionState = newState
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {

                    NavigationLink(destination: QuizPlayerSettingsMenu()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20.0)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: QuizPlayerSettingsMenu()) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20.0)
                    }
                }
            }
        }
    }
    
    private func userHighScore(from performances: [PerformanceModel]) -> Int {
        guard let highestScore = performances.map({ $0.score }).max() else {
            return 0
        }
        return Int(highestScore)
    }

    
    private func filterPerformanceCollection() {
        let quizName = UserDefaultsManager.quizName()
        
        // Filter the performanceCollection based on user's downloaded quiz name
        let filteredPerformance = performanceCollection.filter { $0.quizName == quizName }
        self.userHighScore = userHighScore(from: filteredPerformance)
        
        // Sort the filtered collection by date in descending order
        let sortedPerformance = filteredPerformance.sorted { $0.date > $1.date }
        
        // Limit the results to the seven most recent entries
        currentPerformance = Array(sortedPerformance.prefix(7))
        print("Loaded \(currentPerformance.count) performance records")
    }

    
    private func syncQuizPlayerState(_ playerState: QuizPlayerState) {
        switch playerState {
        case .startedPlayingQuiz:
            self.interactionState = .isNowPlaying
        case .endedQuiz:
            self.interactionState = .isDonePlaying
            filterPerformanceCollection()
        case .donePlaying:
            self.interactionState = .isDonePlaying
        case .pausedCurrentPlay:
            self.interactionState = .pausedPlayback
            
        default:
            break
        }
    }
    
    private func startPlayer() {
        DispatchQueue.main.async {
            self.interactionState = .isNowPlaying
            self.quizPlayerObserver.playerState = .startedPlayingQuiz
        }
    }
    
    private func playPause() {
        DispatchQueue.main.async {
            if self.quizPlayerObserver.playerState == .startedPlayingQuiz {
                self.quizPlayerObserver.playerState = .pausedCurrentPlay
            }
            
            if self.quizPlayerObserver.playerState == .pausedCurrentPlay {
                self.quizPlayerObserver.playerState = .startedPlayingQuiz
            }
        }
    }
    
   

    
    private func updateUserQuizSelection() {
        print(user.downloadedQuiz?.quizname ?? "No User Quiz selected")
        guard let downloadedQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == self.quizName }), !downloadedQuiz.questions.isEmpty else { return }
        user.downloadedQuiz = downloadedQuiz
    }
    
    
    
    private func updateAudioQuizCollectionIfNeeded(newCollection: [AudioQuizPackage], oldCollection: [AudioQuizPackage]) {
        let newPackages = newCollection.filter { newPackage in
            !oldCollection.contains(where: { oldPackage in oldPackage.name == newPackage.name })
        }
        
        newPackages.forEach { package in
            if !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) {
                print("Creating New Audio Quiz")
                
                Task {
                    await loadNewAudioQuiz(quiz: package)
                
                }
            }
        }
    }

    
    private func loadNewAudioQuiz(quiz package: AudioQuizPackage) async {
        // Check if the package name already exists in the downloaded collection
        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) else { return }
        
        DispatchQueue.main.async {
            self.interactionState = .isDownloading
        }
        
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
            self.interactionState = .idle
        }
    }

    
//    private func downlaodNewAudioQuiz(quiz package: AudioQuizPackage) async  {
//        //Please Modify guard statement to check that package name is not already contained in collection
//        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) else { return }
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
    
    @ViewBuilder
    func ActivityInfoView(
        answeredQuestions: Int,
        quizzesCompleted: Int,
        highScore: Int,
        numberOfTestsTaken: Int
    ) -> some View {
        
        
        VStack(spacing: 15) {
            
            scoreLabel(
                withTitle: "Quizzes Completed",
                iconName: "doc.questionmark",
                score: "\(numberOfTestsTaken)"
            )
            
            scoreLabel(
                withTitle: "High Score",
                iconName: "trophy",
                score: "\(highScore)%"
            )
            
            scoreLabel(
                withTitle: "Total Number of Questions",
                iconName: "questionmark.circle",
                score: "∞"
            )
            
            scoreLabel(
                withTitle: "Questions Answered",
                iconName: "checkmark.circle",
                score: "\(answeredQuestions)"
            )
            
            scoreLabel(
                withTitle: "Questions Skipped",
                iconName: "arrowshape.bounce.forward",
                score: "\(0)"
            )
        }
        .padding()
        .background(Color.gray.opacity(0.07).gradient)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func scoreLabel(withTitle title: String, iconName: String, score: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(.mint)
            
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(score)
                .font(.subheadline)
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
//


struct NowPlayingView: View {
    var currentquiz: DownloadedAudioQuiz?
    var quizPlayerObserver: QuizPlayerObserver
    var generator: ColorGenerator
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
            
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(currentquiz?.quizname.uppercased() ?? "VOQA")
                    .font(.body)
                    .fontWeight(.semibold)
                
                
                HStack(spacing: 12) {
                    Text(quizPlayerObserver.playerState.status)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    
                    Image(systemName: "headphones")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                
                Text("Completed Quizzes: \(currentquiz?.quizzesCompleted ?? 0)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                HStack {
                    
                    VUMeterView(interactionState: .constant(animateMeter()))
                    
                    CircularPlayButton(interactionState: $interactionState, isDownloading: .constant(false), color: generator.dominantBackgroundColor, playAction: {  })
                            .hAlign(.trailing)
                            //.offset(y: 20)
                }
 
            }
            .padding(.top, 5)
            .frame(height: 150)
            .padding(.horizontal, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear {
//            animateMeter()
//        }
//        .onChange(of: quizPlayerObserver.playerState) { _, _ in
//            animateMeter()
//        }
        
    }
    
    private func buttonText() -> String {
        if self.interactionState == .startedQuiz {
            return "End Quiz"
        } else if self.interactionState == .pausedPlayback {
            return "Paused"
        } else {
            return "Start Quiz"
        }
    }
    
    private func animateMeter() -> QuizPlayerState {
        if self.interactionState == .startedQuiz {
            return .startedPlayingQuiz
        } else if self.interactionState == .pausedPlayback {
            return .startedPlayingQuiz
        } else {
            return .idle
        }
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
