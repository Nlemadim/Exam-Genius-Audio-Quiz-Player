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
    @ObservedObject var questionPlayer = QuestionPlayer()
    @ObservedObject var responseListener = ResponseListener()
    @StateObject var quizSetter = QuizPlayerView.QuizSetter()
    
   
    @State private var currentQuestion: Question?
    @State private var interactionState: InteractionState = .idle
    @State private var selectedQuizPackage: AudioQuizPackage?
    @State private var path = [AudioQuizPackage]()
    @State var configuration: QuizViewConfiguration?
    
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State private var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    @State private var nextTapped: Bool = false
    @State private var repeatTapped: Bool = false
    @State private var presentMicModal: Bool = false
    
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedOption: String = ""
    
    
    

    var cancellables = Set<AnyCancellable>()
    
    @Namespace private var animation
    
    //@ObservedObject var quizPlayer = QuizPlayer.shared
    
    @State var backgroundImage: String = "Logo"

    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {

                VStack(alignment: .leading, spacing: 4.0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 4.0){
                            Image(user.selectedQuizPackage?.imageUrl ?? "IconImage")
                                .resizable()
                                .frame(width: 280, height: 280)
                                .cornerRadius(25)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .padding(.top, 20)
                        .padding()
                        .background(
                            Image(user.selectedQuizPackage?.imageUrl ?? "IconImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .blur(radius: 50)
                        )
                        
                        Text(user.selectedQuizPackage?.name.uppercased() ?? "No Quiz Selected!")
                            .font(.title3)
                            .lineLimit(2, reservesSpace: true)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 12.0) {
                            LabeledContent("Total Questions", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
                            LabeledContent("Questions Answered", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
                            LabeledContent("Quizzes Completed", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
                            LabeledContent("Current High Score", value: "\(user.selectedQuizPackage?.questions.count ?? 0)%")
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            PlainClearButton(color: .clear, label: "Start", image: nil, isDisabled: nil, playAction: { self.expandSheet.toggle(); selectedQuizPackage = user.selectedQuizPackage })
                        }
                        .padding(.all, 20.0)
                    }
                }
            }
            .navigationTitle("Quiz Player").navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let audioQuiz = selectedQuizPackage {
                    quizSetter.loadQuizConfiguration(quizPackage: audioQuiz)
                }
            }
            .onChange(of: selectedQuizPackage) { _, newValue in
                if let newPackage = newValue {
                    quizSetter.loadQuizConfiguration(quizPackage: newPackage)
                }
            }
            .onChange(of: currentQuestionIndex) { _, newValue in
                self.currentQuestionIndex = newValue
                goToNextQuestion()
            }
            .onChange(of: questionPlayer.isFinishedPlaying, initial: false, { _, newValue in
                if newValue == true {
                    responseListener.recordAnswer()
                }
            })
            .onReceive(responseListener.$interactionState, perform: { interactionState in
                self.interactionState = interactionState

            })
            .onReceive(responseListener.$selectedOption) { selectedOption in
                if user.selectedQuizPackage != nil {
                    self.currentQuestions[self.currentQuestionIndex].selectedOption = selectedOption
                    analyseResponse()
                }     
            }
            .background(
                generator.dominantBackgroundColor.opacity(0.5)
            )
        }
        .fullScreenCover(isPresented: $expandSheet) {
            QuizView(quizSetter: quizSetter, currentQuestionIndex: $currentQuestionIndex, isNowPlaying: $playTapped, presentMicModal: $presentMicModal, repeatTapped: $repeatTapped, interactionState: $interactionState)
        }
        .onChange(of: playTapped, { _, _ in
            print("Play Pressed")
            print("Current Question Index on QuizPlayerView is \(currentQuestionIndex)")
            print("Current Question Index on QuizPlayerView is \(currentQuestions.count)")
            print("\(self.currentQuestions[self.currentQuestionIndex].questionAudio)")
            questionPlayer.playAudioQuestions(audioFile: self.currentQuestions[self.currentQuestionIndex].questionAudio)
//            questionPlayer.playAudioQuestions(audioFile: self.currentQuestions[self.currentQuestionIndex].questionAudio)

        })
        .onAppear {
            generator.updateDominantColor(fromImageNamed: backgroundImage)
        }
        .preferredColorScheme(.dark)
        
        var backgroundImage: String {
            return user.selectedQuizPackage?.imageUrl ?? "IconImage"
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
    
    var currentQuestions: [Question] {
        var questions: [Question] = []
        if let selectedPackage = user.selectedQuizPackage {
            let currentQuestions = selectedPackage.questions
            questions.append(contentsOf: currentQuestions)
        }
        return questions
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
    
//    func playAudioQuiz() {
//        if let package = user.selectedQuizPackage {
////            let list = package.questions
////            let playList = list.compactMap{$0.questionAudio}
//           // quizPlayer.playSampleQuiz(audioFileNames: playList)
//        }
//    }
    

    
    func analyseResponse() {
        if !isPlaying, !self.selectedOption.isEmptyOrWhiteSpace {
            self.currentQuestion?.selectedOption = self.selectedOption
            currentQuestion?.isAnswered = true
            print("Question Answered")
            if currentQuestion?.selectedOption == currentQuestion?.correctOption {
                currentQuestion?.isAnsweredCorrectly = true
                print("Question was answered correctly!")
            }
        }
    }
    
    private func goToNextQuestion() {
        if let questionCount = configuration?.questions.count, currentQuestionIndex < questionCount - 1 {
            questionPlayer.playSingleAudioQuestion(audioFile: self.currentQuestions[self.currentQuestionIndex].questionAudio)
            print("Current Question Index on QuizPlayer is \(self.currentQuestions[self.currentQuestionIndex].questionAudio)")
        }
    }
    
    private func goToPreviousQuestion() {
        if self.currentQuestionIndex > 0 {
            //questionPlayer.playQuestion(audioFileName: self.currentQuestions[self.currentQuestionIndex].questionAudio)
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


