//
//  MiniPlayer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/10/24.
//

import Foundation
import SwiftUI
import SwiftData

//struct MiniPlayer: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject var user: User
//    @EnvironmentObject var appState: AppState
//    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
//    
//    var audioQuizCollection: [AudioQuizPackage]
//    
//    // Using StateObject during initialization
//    @StateObject var quizSetter: MiniPlayer.MiniPlayerConfiguration
//    @StateObject var questionPlayer: QuestionPlayer
//    @StateObject var responseListener = ResponseListener()
//    
//    @State var configuration: QuizViewConfiguration?
//    @Binding var selectedQuizPackage: AudioQuizPackage?
//    @Binding var expandSheet: Bool
//    @Binding var interactionState: InteractionState
//    @Binding var startPlaying: Bool
//    
//    @State var currentPlaylistItemIndex: Int = 0
//    @State var currentQuestionIndex: Int = 0
//    @State var selectedOption: String = ""
//    
//    @State var presentConfirmationModal: Bool = false
//    @State private var playTapped: Bool = false
//    @State private var nextTapped: Bool = false
//    @State private var repeatTapped: Bool = false
//    @State private var presentMicModal: Bool = false
//    
////    init(quizPlayerObserver: QuizPlayerObserver, audioQuizCollection: [AudioQuizPackage], selectedQuizPackage: Binding<AudioQuizPackage?>, expandSheet: Binding<Bool>, interactionState: Binding<InteractionState>, startPlaying: Binding<Bool>) {
////        self._selectedQuizPackage = selectedQuizPackage
////        self._expandSheet = expandSheet
////        self._interactionState = interactionState
////        self._startPlaying = startPlaying
////        self.audioQuizCollection = audioQuizCollection
////        // Initialize quizSetter and questionPlayer as StateObjects
////        let config = MiniPlayer.MiniPlayerConfiguration()
////        self._quizSetter = StateObject(wrappedValue: config)
////        self._questionPlayer = StateObject(wrappedValue: QuestionPlayer(miniPlayerConfig: config))
////    }
//    
//    var body: some View {
//        HStack(spacing: 10) {
//            ZStack {
//                if !expandSheet {
//                    GeometryReader { geometry in
//                        Image(user.selectedQuizPackage?.imageUrl ?? "Logo")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
//                    }
//                }
//            }
//            .frame(width: 45, height: 45)
//            
//            Text(user.selectedQuizPackage?.acronym ?? "Not Playing")
//                .font(.footnote)
//                .foregroundStyle(.white)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            MiniQuizControlView(
//                recordAction: {},
//                playPauseAction: { playQuizQuestions()},
//                nextAction: { goToNextQuestion() },
//                repeatAction: {}
//            )
//        }
//        .foregroundStyle(.teal)
//        .padding(.horizontal)
//        .padding(.bottom, 12)
//        .frame(height: 70)
//        .contentShape(Rectangle())
//        .fullScreenCover(isPresented: $expandSheet) {
//            FullScreenQuizPlayer2(quizSetter: quizSetter, expandSheet: $expandSheet, currentQuestionIndex: $currentQuestionIndex, isNowPlaying: $playTapped, isCorrectAnswer: $presentConfirmationModal, presentMicModal: $presentMicModal, nextTapped: $nextTapped, interactionState: $interactionState, onViewDismiss: { /*self.expandSheet = false*/ }, animation: animation)
//        }
//        .onAppear {
//            if let audioQuiz = selectedQuizPackage {
//                quizSetter.loadQuizConfiguration(quizPackage: audioQuiz)
//            }
//        }
//        .onChange(of: interactionState) {_, interactionState in
//            startAudioQuiz(interactionState)
//        }
//        .onChange(of: quizPlayerObserver.playerState) { _, newState in
//            if [.startedPlayingQuiz, .startedPlayingMusic, .startedPlayingTopic].contains(newState) {
//                DispatchQueue.main.async {
//                    self.expandSheet = true
//                    playQuizQuestions()
//                }
//            }
//        }
//        .onChange(of: startPlaying, { _, newValue in
//            if newValue {
//                print("MiniPlayer has started playing: \(newValue)")
//                DispatchQueue.main.async {
//                    self.interactionState = .isNowPlaying
//                    expandSheet = true
//                    startAudioQuiz(interactionState)
//                }
//            }
//        })
//        .onChange(of: selectedQuizPackage) { _, newValue in
//            if let newPackage = newValue {
//                quizSetter.loadQuizConfiguration(quizPackage: newPackage)
//            }
//        }
//        .onChange(of: playTapped) { _, newValue in
//            if newValue {
//                DispatchQueue.main.async {
//                    self.interactionState = .isNowPlaying
//                    startAudioQuiz(interactionState)
//                    playTapped = false
//                }
//            }
//        }
//        .onChange(of: currentQuestionIndex) { _, _ in
//            goToNextQuestion()
//        }
//        .onChange(of: questionPlayer.interactionState) { _, newValue in
//            checkPlayerState(newValue)
//        }
//        .onChange(of: responseListener.interactionState) { _, newValue in
//            checkForResponse(newValue)
//        }
//        .onTapGesture {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                expandSheet = true
//            }
//        }
//    }
//}
//
//extension MiniPlayer {
//    
//    func checkForResponse(_ interaction: InteractionState) {
//        self.interactionState = interaction
//        DispatchQueue.main.async {
//            //self.interactionState = newValue
//            print("QuizPlayer interaction State is: \(self.interactionState)")
//            if interaction == .idle {
//                self.selectedOption = responseListener.userTranscript
//                print("Quiz view has registered new selectedOption as: \(self.selectedOption)")
//                analyseResponse()
//            }
//        }
//    }
//    
//    func checkPlayerState(_ interaction: InteractionState) {
//        self.interactionState = interaction
//        if interaction == .isDonePlaying {
//            print("QuizPlayer interaction State is: \(self.interactionState)")
//            responseListener.recordAnswer()
//        }
//    }
//    
//    func playQuizQuestions() {
//        guard !currentQuestions.isEmpty else { return }
//
//        switch quizPlayerObserver.playerState {
//        case .startedPlayingQuiz:
//            // Play a sequence of question audios
//            let audioFiles = currentQuestions.map { $0.questionAudio }
//            questionPlayer.playAudioQuestions(audioFileNames: audioFiles)
//        case .startedPlayingMusic, .startedPlayingTopic:
//            // Play the current question's audio, assuming this corresponds to music or topic specific
//            if currentQuestions.indices.contains(currentQuestionIndex) {
//                let audio = currentQuestions[currentQuestionIndex].questionAudio
//                print(audio)
//                //questionPlayer.playSingleAudioFile(audio)
//            }
//        default:
//            print("Unhandled player state: \(quizPlayerObserver.playerState)")
//        }
//    }
//
//    
//    func playQuestion() {
//        guard !currentQuestions.isEmpty else { return }
//        if currentQuestions.indices.contains(currentQuestionIndex) {
//            let currentPosition = self.currentQuestionIndex
//            let audio = self.currentQuestions[currentPosition].questionAudio
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                print(audio)
//                //questionPlayer.playSingleAudioQuestion(audioFile: audio)
//            }
//        }
//    }
//    
//    func recordAnswerAction() {
//        self.presentMicModal.toggle()
//    }
//    
//    func startAudioQuiz(_ startPlaying: InteractionState) {
//        guard startPlaying == .isNowPlaying && self.selectedQuizPackage != nil else { return }
//        expandSheet = true
//        playQuestion()
//    }
//    
//    var currentQuestions: [Question] {
//        var questions: [Question] = []
//        if let selectedPackage = user.audioQuizPackage {
//            let currentQuestions = selectedPackage.questions
//            questions = currentQuestions
//            print("Miniplayer has recieved \(questions.count) questions")
//        }
//        
//        return questions
//    }
//    
//    func analyseResponse() {
//        self.interactionState = .hasResponded
//        if !self.selectedOption.isEmptyOrWhiteSpace {
//            selectOption(self.selectedOption)
//        }
//    }
//    
//    func goToNextQuestion() {
//        if let questionCount = configuration?.questions.count, currentQuestionIndex < questionCount - 1 {
//            self.currentQuestionIndex += 1
//            //questionPlayer.playSingleAudioQuestion(audioFile: self.currentQuestions[self.currentQuestionIndex].questionAudio)
//        }
//    }
//    
//    private func selectOption(_ option: String) {
//        DispatchQueue.main.async {
//            print("Saving response")
//            let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
//            currentQuestion.selectedOption = option
//            currentQuestion.isAnswered = true
//
//            if currentQuestion.selectedOption == currentQuestion.correctOption {
//                currentQuestion.isAnsweredCorrectly = true
//            }
//            
//            self.presentConfirmationModal = currentQuestion.isAnsweredCorrectly
//        }
//    }
//}
//
//extension MiniPlayer {
//    class MiniPlayerConfiguration: ObservableObject {
//        @Published var configuration: QuizViewConfiguration?
//        @Published var stoppedPlaying: Bool = false
//        @Published var interactionState: InteractionState = .idle
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
//            )
//            
//            self.configuration = newConfiguration
//            print("Quiz Setter has Set Configurations")
//        }
//    }
//}
//


