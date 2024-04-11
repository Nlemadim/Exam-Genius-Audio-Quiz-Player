//
//  QuizPlayerView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/18/24.
//

//import SwiftUI
//import SwiftData
//import Combine
//import AVKit
//
//
//struct QuizPlayerView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject var user: User
//    @EnvironmentObject var appState: AppState
//    
//    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
//    
//    @StateObject private var generator = ColorGenerator()
//    @StateObject var questionPlayer = QuestionPlayer()
//    @StateObject var responseListener = ResponseListener()
//    @StateObject var quizSetter = QuizPlayerView.QuizSetter()
//    
//    @State private var currentQuestion: Question?
//    @State var interactionState: InteractionState = .idle
//    @State private var selectedQuizPackage: AudioQuizPackage?
//    @State private var path = [AudioQuizPackage]()
//    @State var configuration: QuizViewConfiguration?
//    
//    @State private var expandSheet: Bool = false
//    @State var isDownloading: Bool = false
//    @State var isPlaying: Bool = false
//    @State private var playTapped: Bool = false
//    @State private var nextTapped: Bool = false
//    @State private var repeatTapped: Bool = false
//    @State private var presentMicModal: Bool = false
//    @State var presentConfirmationModal: Bool = false
//    
//    @State var currentQuestionIndex: Int = 0
//    @State var selectedOption: String = ""
//    
//    @Namespace private var animation
//    
//    @State var backgroundImage: String = "Logo"
//
//    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
//    
//    var body: some View {
//        NavigationView {
//            ZStack(alignment: .topLeading) {
//                VStack(alignment: .leading, spacing: 4.0) {
//                    ScrollView(showsIndicators: false) {
//                        VStack(alignment: .leading, spacing: 4.0){
//                            Image(user.selectedQuizPackage?.imageUrl ?? "IconImage")
//                                .resizable()
//                                .frame(width: 280, height: 280)
//                                .cornerRadius(25)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 300)
//                        .padding(.top, 20)
//                        .padding()
//                        .background(
//                            Image(user.selectedQuizPackage?.imageUrl ?? "IconImage")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .blur(radius: 50)
//                        )
//                        
//                        Text(user.selectedQuizPackage?.name.uppercased() ?? "No Quiz Selected!")
//                            .font(.title3)
//                            .lineLimit(2, reservesSpace: true)
//                            .fontWeight(.medium)
//                            .foregroundStyle(.primary)
//                            .multilineTextAlignment(.center)
//                        
//                        VStack(alignment: .leading, spacing: 12.0) {
//                            LabeledContent("Total Questions", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
//                            LabeledContent("Questions Answered", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
//                            LabeledContent("Quizzes Completed", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
//                            LabeledContent("Current High Score", value: "\(user.selectedQuizPackage?.questions.count ?? 0)%")
//                        }
//                        .padding(.horizontal)
//                        
//                        VStack {
//                            PlainClearButton(color: .clear, label: "Start", image: nil, isDisabled: nil, playAction: { self.expandSheet.toggle(); selectedQuizPackage = user.selectedQuizPackage })
//                        }
//                        .padding(.all, 20.0)
//                    }
//                }
//            }
//            .navigationTitle("Quiz Player").navigationBarTitleDisplayMode(.inline)
//            .onAppear {
//                if let audioQuiz = selectedQuizPackage {
//                    quizSetter.loadQuizConfiguration(quizPackage: audioQuiz)
//                }
//            }
//            .onChange(of: selectedQuizPackage) { _, newValue in
//                if let newPackage = newValue {
//                    quizSetter.loadQuizConfiguration(quizPackage: newPackage)
//                }
//            }
//            .onChange(of: nextTapped) { _, _ in
//                goToNextQuestion()
//            }
//            .onChange(of: questionPlayer.interactionState) { _, newValue in
//                self.interactionState = newValue
//                if newValue == .isDonePlaying {
//                    print("QuizPlayer interaction State is: \(self.interactionState)")
//                    responseListener.recordAnswer()
//                }
//            }
//            .onChange(of: responseListener.interactionState) { _, newValue in
//                self.interactionState = newValue
//                DispatchQueue.main.async {
//                    //self.interactionState = newValue
//                    print("QuizPlayer interaction State is: \(self.interactionState)")
//                    if newValue == .idle {
//                        self.selectedOption = responseListener.userTranscript
//                        print("Quiz view has registered new selectedOption as: \(self.selectedOption)")
//                        analyseResponse()
//                    }
//                }
//            }
//            .background(
//                generator.dominantBackgroundColor.opacity(0.5)
//            )
//        }
//        .fullScreenCover(isPresented: $expandSheet) {
//            QuizView(quizSetter: quizSetter, currentQuestionIndex: $currentQuestionIndex, isNowPlaying: $playTapped, isCorrectAnswer: $presentConfirmationModal, presentMicModal: $presentMicModal, nextTapped: $nextTapped, interactionState: $interactionState)
//        }
//        .onChange(of: playTapped, { _, _ in
//            playQuestion()
//            
//            print("Play Pressed")
//            print("Current Question Index on QuizPlayerView is \(currentQuestionIndex)")
//            print("Current Question count is \(currentQuestions.count)")
//            print("\(self.currentQuestions[self.currentQuestionIndex].questionAudio)")
//            
//        })
//        .onAppear {
//            generator.updateDominantColor(fromImageNamed: backgroundImage)
//        }
//        .preferredColorScheme(.dark)
//        
//        var backgroundImage: String {
//            return user.selectedQuizPackage?.imageUrl ?? "IconImage"
//        }
//    }
//}
//
//extension QuizPlayerView {
//    class QuizSetter: ObservableObject, QuizPlayerDelegate {
//        @Published var configuration: QuizViewConfiguration?
//        
//        private var quizPlayer = QuizPlayer.shared
//        private var isFinishedPlaying = false
//        private var isNowPlaying = false
//        
//       init() {
//            self.quizPlayer.delegate = self
//        }
//        
//        func quizPlayerDidFinishPlaying(_ player: QuizPlayer) {
//            self.isFinishedPlaying = true
//        }
//    
//        var playPauseQuiz: (() -> Void)?
//        var nextQuestion: (() -> Void)?
//        var repeatQuestion: (() -> Void)?
//        var endQuiz: (() -> Void)?
//        
//        func setActions(playPauseQuiz: (() -> Void)? = nil,
//                        nextQuestion: (() -> Void)? = nil,
//                        repeatQuestion: (() -> Void)? = nil,
//                        endQuiz: (() -> Void)? = nil) {
//            self.playPauseQuiz = playPauseQuiz
//            self.nextQuestion = nextQuestion
//            self.repeatQuestion = repeatQuestion
//            self.endQuiz = endQuiz
//        }
//        
//        func loadQuizConfiguration(quizPackage: AudioQuizPackage?) {
//            guard let quizPackage = quizPackage else {
//                return
//            }
//            
//            let questions = QuestionVisualizerMaker.createVisualizers(from: quizPackage.questions)
//            let newConfiguration = QuizViewConfiguration(
//                imageUrl: quizPackage.imageUrl,
//                name: quizPackage.name,
//                shortTitle: quizPackage.acronym,
//                questions: questions
//                
//            )
//            
//            self.configuration = newConfiguration
//            print("Quiz Setter has Set Configurations")
//        }
//    }
//}
//        
//
//
//#Preview {
//    @State var package = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "USMLESTEP1-Exam")
//    let user = User()
//    let appState = AppState()
//   return QuizPlayerView()
//        .environmentObject(user)
//        .environmentObject(appState)
//        .preferredColorScheme(.dark)
//        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
//  
//}


