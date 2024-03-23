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
    @StateObject var quizSetter = QuizPlayerView.QuizSetter()
    
    
    
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State private var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    @State private var nextTapped: Bool = false
    @State private var repeatTapped: Bool = false
    @State private var presentMicModal: Bool = false
    
    @State private var currentQuestionIndex: Int = 0
    @State private var currentQuizQuestions: [Question] = []
    @State private var currentQuestion: Question?
    @State private var selectedOption: String = ""
    
    @State private var interactionState: InteractionState = .idle
    @State private var selectedQuizPackage: AudioQuizPackage?
    @State private var path = [AudioQuizPackage]()
    @State var configuration: QuizViewConfiguration?
    
    init() {
        if let package = selectedQuizPackage {
            currentQuizQuestions.append(contentsOf: package.questions)
        }
    }
    

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
            .onChange(of: currentQuestionIndex) { _, newValue in
                goToNextQuestion()
            }
            .onChange(of: quizPlayer.isFinishedPlaying, initial: false, { _, _ in
                quizPlayer.recordAnswer()
            })
            .onReceive(quizPlayer.$interactionState, perform: { interactionState in
                self.interactionState = interactionState
                if interactionState == .awaitingResponse || interactionState == .isListening {
                    
                } else {
                    self.interactionState = interactionState
                }
            })
            .onReceive(quizPlayer.$selectedOption) { selectedOption in
                self.selectedOption = selectedOption
                analyseResponse()
            }
        }
        .fullScreenCover(isPresented: $expandSheet) {
            QuizView(quizSetter: quizSetter, currentQuestionIndex: $currentQuestionIndex, isNowPlaying: $playTapped, nextTapped: $nextTapped, repeatTapped: $repeatTapped, interactionState: $interactionState)
        }
        .onChange(of: playTapped, { _, _ in
            print("Play Pressed")
            print("Current Question Index on QuizPlayer is \(currentQuestionIndex)")
            playAudioQuestion()
        })
        .onAppear {
            generator.updateDominantColor(fromImageNamed: backgroundImage)
        }
        .preferredColorScheme(.dark)
        
        var backgroundImage: String {
            return user.selectedQuizPackage?.imageUrl ?? "Logo"
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
    }
}
        
 

extension QuizPlayerView {
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
    
    func playAudioQuestion() {
        if let package = user.selectedQuizPackage {
            let currentQuestions = package.questions
            self.currentQuizQuestions = currentQuestions
            playAudioFileAtIndex(self.currentQuestionIndex)

        }
    }
    
    private func playAudioFileAtIndex(_ index: Int) {
//        guard index < currentQuizQuestions.count else {
//            return
//        }
        let audiofile = currentQuizQuestions[index].questionAudio
        quizPlayer.playAudioQuestion(audioFile: audiofile)
    }
    
    func analyseResponse() {
        if !isPlaying, !self.selectedOption.isEmptyOrWhiteSpace {
            self.currentQuestion?.selectedOption = self.selectedOption
            currentQuestion?.isAnswered = true
            if currentQuestion?.selectedOption == currentQuestion?.correctOption {
                currentQuestion?.isAnsweredCorrectly = true
            }
        }
    }
    
    private func goToNextQuestion() {
        if let questionCount = configuration?.questions.count, currentQuestionIndex < questionCount - 1 {
            currentQuestionIndex += 1
            playAudioFileAtIndex(self.currentQuestionIndex)
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


