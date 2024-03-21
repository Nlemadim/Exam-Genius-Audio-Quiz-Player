//
//  QuizPlayerView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/18/24.
//

import SwiftUI
import SwiftData
import Combine

struct QuizPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    @StateObject private var generator = ColorGenerator()
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State private var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    @State private var currentQuestionIndex: Int = 0
    
    @State private var selectedQuizPackage: AudioQuizPackage?
    @State private var path = [AudioQuizPackage]()
    @State var configuration: QuizViewConfiguration?
    @StateObject var quizSetter = QuizPlayerView.QuizSetter()

    var cancellables = Set<AnyCancellable>()
    
    @Namespace private var animation
    
    @ObservedObject var quizPlayer = QuizPlayer.shared
    
    @State var backgroundImage: String = "Logo"

    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, user.selectedQuizPackage == nil ? .themePurple: generator.dominantBackgroundColor.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .leading, spacing: 4.0) {
                        VStack(alignment: .leading, spacing: 4.0){
                            Text(user.selectedQuizPackage == nil ? "Not Playing" :"Currently Playing")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                            HStack {
                                Text(user.selectedQuizPackage?.name.uppercased() ?? "No Quiz Selected!")
                                    .font(.footnote)
                                    .lineLimit(2, reservesSpace: true)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        .padding()
                        
                        TabView {
                            ForEach(0 ..< 5) { item in
                                CurrentQuizViewV2(image: user.selectedQuizPackage?.imageUrl ?? "IconImage",
                                                  buttonLabel: user.hasStartedQuiz ? "Resume" : nil,
                                                  color: !user.hasSelectedAudioQuiz ? .gray : generator.dominantBackgroundColor,
                                                  backgroundImage: "", numberOfQuestions: numberOfQuestions,
                                                  numberOfQuizzes: quizzesCompleted,
                                                  questionsAnswered: questionsAnswered,
                                                  highScore: highestScore,
                                                  numberOfTopics: numberOfTopics,
                                                  isDisabled: nil,
                                                  playButtonAction: { self.expandSheet.toggle(); selectedQuizPackage = user.selectedQuizPackage }
                               )
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 530)
                    }
            }
            .onAppear {
                if let audioQuiz = selectedQuizPackage {
                    quizSetter.loadQuizConfiguration(quizPackage: audioQuiz)
                    
                    quizSetter.setActions(
                        playPauseQuiz: { self.playAudioQuiz() },
                        nextQuestion: { self.goToNextQuestion() },
                        repeatQuestion: { self.goToPreviousQuestion() },
                        endQuiz: { /* Handle end quiz */ }
                    )
                }
            }
            .onChange(of: selectedQuizPackage) { _, newValue in
                if let newPackage = newValue {
                    quizSetter.loadQuizConfiguration(quizPackage: newPackage)
                }
            }
        }
        .fullScreenCover(isPresented: $expandSheet) {
            TestQuizView(isNowPlaying: $playTapped, quizSetter: quizSetter, currentQuestionIndex: $currentQuestionIndex)
        }
        .onChange(of: playTapped, { _, _ in
            print("Play Pressed")
            print("Current Question Index on QuizPlayer is \(currentQuestionIndex)")
            playAudioQuiz()
        })
        .onAppear {
            generator.updateDominantColor(fromImageNamed: backgroundImage)
        }
        .preferredColorScheme(.dark)
        
        var backgroundImage: String {
            return user.selectedQuizPackage?.imageUrl ?? "Logo"
        }

    }
    
    var numberOfTopics: Int {
        if let selectedPackage = user.selectedQuizPackage {
            let numberOfTopics = selectedPackage.topics.count
            return numberOfTopics
        }
        
        return 0
    }
    
    var numberOfQuestions: Int {
        if let selectedPackage = user.selectedQuizPackage {
            let numberOfTopics = selectedPackage.questions.count
            return numberOfTopics
        }
        
        return 0
    }
    
    var questionsAnswered: Int {
        let total = UserDefaultsManager.totalQuestionsAnswered()
        return total
    }
    
    var quizzesCompleted: Int {
        let total = UserDefaultsManager.numberOfQuizSessions()
        return total
    }
    
    var highestScore: Int {
        let total = UserDefaultsManager.userHighScore()
        return total
    }
    
    func playAudioQuiz() {
        if let package = user.selectedQuizPackage {
            let list = package.questions
            let playList = list.compactMap{$0.questionAudio}
            quizPlayer.playSampleQuiz(audioFileNames: playList)
        }
    }
}

extension QuizPlayerView {
    class QuizSetter: ObservableObject, QuizPlayerDelegate {
        @Published var configuration: QuizViewConfiguration?
        
        private var quizPlayer = QuizPlayer.shared
        private var isFinishedPlaying = false
        private var isNowPlaying = false
        
       init() {
            self.quizPlayer.delegate = self
        }
        
        func quizPlayerDidFinishPlaying(_ player: QuizPlayer) {
            self.isFinishedPlaying = true
        }
        
        var playPauseQuiz: (() -> Void)?
        var nextQuestion: (() -> Void)?
        var repeatQuestion: (() -> Void)?
        var endQuiz: (() -> Void)?
        
        func setActions(playPauseQuiz: (() -> Void)? = nil,
                        nextQuestion: (() -> Void)? = nil,
                        repeatQuestion: (() -> Void)? = nil,
                        endQuiz: (() -> Void)? = nil) {
            self.playPauseQuiz = playPauseQuiz
            self.nextQuestion = nextQuestion
            self.repeatQuestion = repeatQuestion
            self.endQuiz = endQuiz
        }
        
        func loadQuizConfiguration(quizPackage: AudioQuizPackage?) {
            guard let quizPackage = quizPackage else {
                return
            }
            
            let questions = QuestionVisualizerMaker.createVisualizers(from: quizPackage.questions)
            let newConfiguration = QuizViewConfiguration(
                imageUrl: quizPackage.imageUrl,
                name: quizPackage.name,
                shortTitle: quizPackage.acronym,
                questions: questions,
                config: ControlConfiguration(
                    playPauseQuiz: { [weak self] in
                        self?.playPauseQuiz?()
                    },
                    nextQuestion: { [weak self] in
                        self?.nextQuestion?()
                    },
                    repeatQuestion: { [weak self] in
                        self?.repeatQuestion?()
                    },
                    endQuiz: { [weak self] in
                        self?.endQuiz?()
                    }
                )
            )
            
            self.configuration = newConfiguration
            print("Quiz Setter has Set Configurations")
        }
        
//        func loadQuizConfiguration2(quizPackage: AudioQuizPackage?) -> QuizControlConfiguration? {
//            guard let quizPackage = quizPackage else {
//                return nil
//            }
//            var config: QuizControlConfiguration
//            let questions = QuestionVisualizerMaker.createVisualizers(from: quizPackage.questions)
//            let newConfiguration = QuizViewConfiguration(
//                imageUrl: quizPackage.imageUrl,
//                name: quizPackage.name,
//                shortTitle: quizPackage.acronym,
//                questions: questions,
//                config: ControlConfiguration(
//                    playPauseQuiz: { [weak self] in
//                        self?.playPauseQuiz?()
//                    },
//                    nextQuestion: { [weak self] in
//                        self?.nextQuestion?()
//                    },
//                    repeatQuestion: { [weak self] in
//                        self?.repeatQuestion?()
//                    },
//                    endQuiz: { [weak self] in
//                        self?.endQuiz?()
//                    }
//                )
//            )
//            config = newConfiguration
//            return newConfiguration
//            print("Quiz Setter has Set Configurations")
//        }
        
    }
}
        
 

extension QuizPlayerView {
    private func goToNextQuestion() {
        if let questionCount = configuration?.questions.count, currentQuestionIndex < questionCount - 1 {
            currentQuestionIndex += 1
            print("Current Question Index on QuizPlayer is \(currentQuestionIndex)")
        }
        
    }
    
    private func goToPreviousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    private func selectOption(_ option: String) {
     
    }
}




#Preview {
    @State var package = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "USMLESTEP1-Exam")
    let user = User()
    let appState = AppState()
   return QuizPlayerView()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
  
}


