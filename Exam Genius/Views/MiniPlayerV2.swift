//
//  MiniPlayerV2.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/13/24.
//

import SwiftUI
import Combine

struct MiniPlayerV2: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @EnvironmentObject var presentationManager: QuizViewPresentationManager
    
    @StateObject private var generator = ColorGenerator()
    @StateObject private var audioContentPlayer = AudioContentPlayer()
    @StateObject var sharedState = SharedQuizState()
    @StateObject var responseListener = ResponseListener()
    @StateObject private var configuration: MiniPlayerV2Configuration
    @StateObject private var questionPlayer: QuestionPlayer
    @State var currentQuestions: [Question] = []
    
    
    @Binding var selectedQuizPackage: AudioQuizPackage?
    @State var expandSheet: Bool = false
    @Binding var interactionState: InteractionState
    @Binding var startPlaying: Bool
    
    @State var currentPlaylistItemIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    
    @State var presentMicModal: Bool = false
    @State var isCorrectAnswer: Bool = false
    @State var presentConfirmationModal: Bool = false
    
    init(selectedQuizPackage: Binding<AudioQuizPackage?>, interactionState: Binding<InteractionState>, startPlaying: Binding<Bool>) {
        _selectedQuizPackage = selectedQuizPackage
        _interactionState = interactionState
        _startPlaying = startPlaying
        
        let sharedState = SharedQuizState()
        _questionPlayer = StateObject(wrappedValue: QuestionPlayer(sharedState: sharedState))
        _configuration = StateObject(wrappedValue: MiniPlayerV2Configuration(sharedState: sharedState))
    }

    var body: some View {
        HStack(spacing: 10) {
            playerThumbnail
            playerDetails
            MiniQuizControlView(
                recordAction: {},
                playPauseAction: { playSingleQuizQuestion() },
                nextAction: { /*goToNextQuestion()*/ },
                repeatAction: {}
            )
        }
        .contentShape(Rectangle())
        .fullScreenCover(isPresented: $presentationManager.shouldShowFullScreen) {
            FullScreenQuizPlayer2(
                quizSetter: configuration,
                currentQuestionIndex: $currentQuestionIndex,
                isCorrectAnswer: $isCorrectAnswer,
                presentMicModal: $presentMicModal,
                interactionState: $interactionState,
                onViewDismiss: { dismissAction()},
                playAction: { playSingleQuizQuestion() },
                nextAction: {},
                recordAction: {}
            )
        }
        .sheet(isPresented: .constant(showMiniPlayerMicModal()), content: {
            MicModalView(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor)
                .presentationDetents([.height(100)])
        })
        .sheet(isPresented: .constant(showMiniPlayerConfirmationModal()), content: {
            ConfirmationModalView(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor, isCorrect: isCorrectAnswer)
                .presentationDetents([.height(200)])
                .onAppear {
                    //print(isCorrectAnswer)
                    //MARK: Simulating Overview readout
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.interactionState = .idle
                    }
                }
        })
        .onTapGesture {
            withAnimation {
                expandAction()
            }
        }
        .onAppear {
            generator.updateAllColors(fromImageNamed: configuration.configuration?.imageUrl ?? "")
            if let newPackage = self.selectedQuizPackage {
                configuration.loadQuizConfiguration(quizPackage: newPackage)
            }
        }
        .onChange(of: configuration.currentQuizPackage) { _, newPackage in
            if let package = newPackage {
                self.currentQuestions = package.questions.filter { !$0.questionAudio.isEmpty }
            }
        }
//        .onReceive(audioContentPlayer.$didFinishPlayingSuccessfully, perform: { finishedPlaying in
//            if finishedPlaying {
//                proceedWithQuiz()
//            }
//        })
        .onChange(of: responseListener.interactionState) { _, newValue in
            checkForResponse(newValue)
        }
        .onChange(of: interactionState) {_, state in
            checkForResponse(state)
            if state == .hasResponded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.proceedWithQuiz()
                }
            }
        }
        .onChange(of: selectedQuizPackage) {_, newPackage in
            if let newPackage = newPackage {
                configuration.loadQuizConfiguration(quizPackage: newPackage)
            }
        }
        .onChange(of: quizPlayerObserver.playerState) {_, newValue in
            print("Mini Player Quiz-Player-Observer registered as: \(newValue)")
            handleInteractionStateChange(newValue)
        }
    }

    private var playerThumbnail: some View {
        GeometryReader { geometry in
            Image(user.selectedQuizPackage?.imageUrl ?? "Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
        }
        .frame(width: 45, height: 45)
    }

    private var playerDetails: some View {
        Text(user.selectedQuizPackage?.acronym ?? "Not Playing")
            .font(.footnote)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func handleInteractionStateChange(_ state: QuizPlayerState) {
        if state == .startedPlayingQuiz {
            expandAction()
            playSingleQuizQuestion()
        }
        
        if state == .endedQuiz {
            dismissAction()
        }
    }
    
    private func showMiniPlayerMicModal() -> Bool {
        return expandSheet == false && interactionState == .isListening
    }
    
    private func showMiniPlayerConfirmationModal()  -> Bool  {
        return expandSheet == false && interactionState == .hasResponded
    }
    
    private func expandAction() {
        self.interactionState = .isNowPlaying
        configuration.interactionState = self.interactionState
        presentationManager.interactionState = self.interactionState
        presentationManager.expandSheet = true
    }
    
    private func dismissAction() {
        presentationManager.interactionState = .idle
        presentationManager.expandSheet = false
    }
}



extension MiniPlayerV2 {
    class MiniPlayerV2Configuration: ObservableObject {
        @Published var configuration: QuizViewConfiguration?
        @Published var currentQuizPackage: AudioQuizPackage?
        @Published var stoppedPlaying: Bool = false
        @Published var interactionState: InteractionState = .idle
        @Published var quizQuestionCount: Int = 0
        
        private var sharedState: SharedQuizState
        
        init(sharedState: SharedQuizState) {
            self.sharedState = sharedState
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
                questions: questions
            )
            
            self.configuration = newConfiguration
            self.currentQuizPackage = quizPackage
            print("Quiz Setter has Set Configurations")
        }
    }
}



extension MiniPlayerV2 {
    func checkForResponse(_ interaction: InteractionState) {
        self.interactionState = interaction
        DispatchQueue.main.async {
            //self.interactionState = newValue
            print("QuizPlayer interaction State is: \(self.interactionState)")
            if interaction == .successfulResponse  {
                self.selectedOption = responseListener.userTranscript
                print("Mini Player view has registered new selectedOption as: \(self.selectedOption)")
                analyseResponse()
            } else if interaction == .errorResponse {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //Play Error SFX
                }
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
    
    func startRecordingAnswer() {
        responseListener.recordAnswer()
    }
    
//    func playQuizQuestions() {
//        // Access the current quiz package safely
//        guard let package = configuration.currentQuizPackage else {
//            print("Mini Player error: No quiz package currently selected")
//            return
//        }
//        
//        print("Selected quiz package: \(package.name), with questions count: \(package.questions.count)")
//        
//        // Ensure there are questions available
//        guard !package.questions.isEmpty else {
//            print("Mini Player error: No available questions in the package")
//            return
//        }
//        
//        // Extract audio files from the questions and initiate playing
//        let audioFiles = package.questions.map { $0.questionAudio }
//        questionPlayer.playAudioQuestions(audioFileNames: audioFiles)
//    }
    
    func proceedWithQuiz() {
        self.currentQuestionIndex += 1
        self.continuePlaying()
    }
    
    
    
    //MARK: TODO - Crash Causer To Be Fixed
    func playSingleQuizQuestion() {
//        // Access the current quiz package safely
//        guard let package = configuration.currentQuizPackage else {
//            print("Mini Player error: No quiz package currently selected")
//            return
//        }
//        
//        print("Selected quiz package: \(package.name), with questions count: \(package.questions.count)")
//        
//        // Ensure there are questions available
//        guard !package.questions.isEmpty else {
//            print("Mini Player error: No available questions in the package")
//            return
//        }
//        
//        let currentQuestion = self.currentQuestions[currentQuestionIndex]
//        let audioFile = currentQuestion.questionAudio
//        //audioContentPlayer.playAudioFile(audioFile)
//        interactionState = .isNowPlaying
    }
    
    private func continuePlaying() {
//        let currentQuestion = self.currentQuestions[currentQuestionIndex]
//        let audioFile = currentQuestion.questionAudio
//        audioContentPlayer.playAudioFile(audioFile)
//        interactionState = .isNowPlaying
    }
    
    func analyseResponse() {
        self.interactionState = .hasResponded
        selectOption(self.selectedOption)
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
            
            self.isCorrectAnswer = currentQuestion.isAnsweredCorrectly
            presentConfirmationModal.toggle()
            
            print(self.interactionState)
            print("Save complete")
            print("Question Answered")
            print("User selected \(self.currentQuestions[self.currentQuestionIndex].selectedOption) option")
            print("Current question is answered: \(self.currentQuestions[self.currentQuestionIndex].isAnswered)")
            print("Question \(self.currentQuestions[self.currentQuestionIndex].id) was answered correctly?: \(self.currentQuestions[self.currentQuestionIndex].isAnsweredCorrectly)")
            print("The correct option is: \(currentQuestion.correctOption)")
        }
    }
}


class SharedQuizState: ObservableObject {
    @Published var interactionState: InteractionState = .idle
    @Published var currentQuizPackage: AudioQuizPackage?
    
    
    //MARK: updateInteractionState(newState: InteractionState) Method used to communicate State of Play between MiniPlay thorugh MiniPlayer extension MiniPlayConfiguration class
    //Update
    // Add any other shared states or methods to handle updates
    func updateInteractionState(newState: InteractionState) {
        self.interactionState = newState
    }
}

