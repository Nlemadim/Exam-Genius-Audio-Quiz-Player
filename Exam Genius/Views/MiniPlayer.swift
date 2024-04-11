//
//  MiniPlayer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/10/24.
//

import Foundation
import SwiftUI
import SwiftData

struct MiniPlayer: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @ObservedObject var libraryPlaylist = MyLibrary.LibraryPlaylist()
    
    @StateObject var questionPlayer = QuestionPlayer()
    @StateObject var responseListener = ResponseListener()
    @StateObject var quizSetter = MiniPlayer.MiniPlayerConfiguration()
    @State var configuration: QuizViewConfiguration?
    @Binding var selectedQuizPackage: AudioQuizPackage?
    
    @State var interactionState: InteractionState = .idle
    
    @State var currentPlaylistItemIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    
    @State var presentConfirmationModal: Bool = false
    @State private var playTapped: Bool = false
    @State private var nextTapped: Bool = false
    @State private var repeatTapped: Bool = false
    @State private var presentMicModal: Bool = false
    
    @Binding var expandSheet: Bool
    @Binding var startPlaying: Bool
    
    
    var animation: Namespace.ID
    

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                if !expandSheet {
                    GeometryReader { geometry in
                        Image(user.selectedQuizPackage?.imageUrl ?? "Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                    }
                }
            }
            .frame(width: 45, height: 45)
            
            Text(user.selectedQuizPackage?.acronym ?? "Not Playing")
                .font(.footnote)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            MiniQuizControlView(
                recordAction: {},
                playPauseAction: { playQuestion() },
                nextAction: { goToNextQuestion() },
                repeatAction: {}
            )
        }
        .foregroundStyle(.teal)
        .padding(.horizontal)
        .padding(.bottom, 12)
        .frame(height: 70)
        .contentShape(Rectangle())
        .fullScreenCover(isPresented: $expandSheet) {
            FullScreenQuizPlayer2(quizSetter: quizSetter, expandSheet: $expandSheet, currentQuestionIndex: $currentQuestionIndex, isNowPlaying: $playTapped, isCorrectAnswer: $presentConfirmationModal, presentMicModal: $presentMicModal, nextTapped: $nextTapped, interactionState: $interactionState, animation: animation)
        }
        .onAppear {
            if let audioQuiz = selectedQuizPackage {
                quizSetter.loadQuizConfiguration(quizPackage: audioQuiz)
            }
        }
        .onReceive(libraryPlaylist.$startedPlaying, perform: { startPlaying in
            print("Observed Playlist has started playing: \(startPlaying)")
            startAudioQuiz(startPlaying)
        })
        .onChange(of: selectedQuizPackage) { _, newValue in
            if let newPackage = newValue {
                quizSetter.loadQuizConfiguration(quizPackage: newPackage)
                print("MiniPlayer has selected Quiz: \(newPackage.name)")
            }
        }
        .onChange(of: startPlaying) { _, newValue in
            if newValue {
                startAudioQuiz(true)
            }
        }
        .onChange(of: nextTapped) { _, _ in
            goToNextQuestion()
        }
        .onChange(of: questionPlayer.interactionState) { _, newValue in
            checkPlayerState(newValue)
        }
        .onChange(of: responseListener.interactionState) { _, newValue in
            checkForResponse(newValue)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}

extension MiniPlayer {
    
    func checkForResponse(_ interaction: InteractionState) {
        self.interactionState = interaction
        DispatchQueue.main.async {
            //self.interactionState = newValue
            print("QuizPlayer interaction State is: \(self.interactionState)")
            if interaction == .idle {
                self.selectedOption = responseListener.userTranscript
                print("Quiz view has registered new selectedOption as: \(self.selectedOption)")
                analyseResponse()
            }
        }
    }
    
    func checkPlayerState(_ interaction: InteractionState) {
        self.interactionState = interaction
        if interaction == .isDonePlaying {
            print("QuizPlayer interaction State is: \(self.interactionState)")
            responseListener.recordAnswer()
        }
    }
    
    func playQuestion() {
        guard !currentQuestions.isEmpty else { return }
        if currentQuestions.indices.contains(currentQuestionIndex) {
            let currentPosition = self.currentQuestionIndex
            let audio = self.currentQuestions[currentPosition].questionAudio
            self.expandSheet = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                questionPlayer.playSingleAudioQuestion(audioFile: audio)
            }
        }
    }
    
    func startAudioQuiz(_ startPlaying: Bool) {
        if startPlaying {
            if let package = user.audioQuizPackage {
                self.selectedQuizPackage = package
                playQuestion()
            }
        }
    }
    
    var currentQuestions: [Question] {
        var questions: [Question] = []
        if let selectedPackage = user.audioQuizPackage {
            let currentQuestions = selectedPackage.questions
            questions = currentQuestions
            print("Miniplayer has recieved \(questions.count) questions")
        }
        
        return questions
    }
    
    func analyseResponse() {
        self.interactionState = .hasResponded
        if !self.selectedOption.isEmptyOrWhiteSpace {
            selectOption(self.selectedOption)
        }
    }
    
    func goToNextQuestion() {
        if let questionCount = configuration?.questions.count, currentQuestionIndex < questionCount - 1 {
            self.currentQuestionIndex += 1
            questionPlayer.playSingleAudioQuestion(audioFile: self.currentQuestions[self.currentQuestionIndex].questionAudio)
        }
    }
    
    private func selectOption(_ option: String) {
        DispatchQueue.main.async {
            print("Saving response")
            let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
            currentQuestion.selectedOption = option
            currentQuestion.isAnswered = true

            if currentQuestion.selectedOption == currentQuestion.correctOption {
                currentQuestion.isAnsweredCorrectly = true
            }
            
            self.presentConfirmationModal = currentQuestion.isAnsweredCorrectly
        }
    }
}

extension MiniPlayer {
    class MiniPlayerConfiguration: ObservableObject {
        @Published var configuration: QuizViewConfiguration?
        @Published var stoppedPlaying: Bool = false
        
        func loadQuizConfiguration(quizPackage: AudioQuizPackage?) {
            guard let quizPackage = quizPackage else {
                return
            }
            
            let questions = QuestionVisualizerMaker.createVisualizers(from: quizPackage.questions)
            let newConfiguration = QuizViewConfiguration(
                imageUrl: quizPackage.imageUrl,
                name: quizPackage.name,
                shortTitle: quizPackage.acronym,
                questions: questions
            )
            
            self.configuration = newConfiguration
            print("Quiz Setter has Set Configurations")
        }
    }
}
