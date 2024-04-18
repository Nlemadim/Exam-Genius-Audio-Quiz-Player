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
    @StateObject private var intermissionPlayer = IntermissionPlayer()
    @StateObject var sharedState = SharedQuizState()
    @StateObject var responseListener = ResponseListener()
    @StateObject private var configuration: MiniPlayerV2Configuration
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
        _configuration = StateObject(wrappedValue: MiniPlayerV2Configuration(sharedState: sharedState))
        
    }

    var body: some View {
        HStack(spacing: 10) {
            playerThumbnail
            playerDetails
            MiniQuizControlView(
                recordAction: {},
                playPauseAction: { startQuizAudioPlay(self.interactionState) },
                nextAction: { /*goToNextQuestion()*/ },
                repeatAction: {},
                interactionState: $interactionState
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
                playAction: { /*playSingleQuizQuestion()*/ },
                nextAction: { intermissionPlayer.playReceivedResponseBell() },
                recordAction: { intermissionPlayer.playListeningBell() }
            )
        }
        .sheet(isPresented: .constant(showMiniPlayerMicModal()), content: {
            MicModalView(
                interactionState: $interactionState,
                mainColor: generator.dominantBackgroundColor,
                subColor: generator.dominantLightToneColor)
                .presentationDetents([.height(100)])
        })
        .sheet(isPresented: .constant(showMiniPlayerConfirmationModal()), content: {
            ConfirmationModalView(
                interactionState: $interactionState,
                mainColor: generator.dominantBackgroundColor,
                subColor: generator.dominantLightToneColor,
                isCorrect: isCorrectAnswer)
                .presentationDetents([.height(200)])
                .onAppear {
                    //MARK: Simulating Overview readout and continuation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.interactionState = .resumingPlayback
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
        .onChange(of: audioContentPlayer.interactionState) { _, newState in
            syncInteractionState(newState)
//            checkPlayerState(newState)
        }
        .onChange(of: responseListener.interactionState) { _, newState in
            syncInteractionState(newState)
//            checkForResponse(newValue)
        }
        .onChange(of: interactionState) { _, newState in
            interactionStateAction(newState)
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
}


extension MiniPlayerV2 {
    
    // MARK: QUIZ LOGICS
    //MARK: STEP 1: Quiz Entry Point - Now Playing
    func startQuizAudioPlay(_ quizState: InteractionState) {
        if quizState == .idle {
            self.interactionState = .isNowPlaying
            configuration.interactionState = self.interactionState
            presentationManager.interactionState = self.interactionState
            presentationManager.expandSheet = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                playSingleQuizQuestion()
            }
        }
    }
    //MARK: STEP 1: Quiz Entry Point - Now Playing Method
    private func playSingleQuizQuestion() {
        // Access the current quiz package safely
        guard let package = configuration.currentQuizPackage else {
            print("Mini Player error: No quiz package currently selected")
            return
        }
        
        guard !package.questions.isEmpty else {
            print("Mini Player error: No available questions in the package")
            return
        }
        
        print("Selected quiz package: \(package.name), with questions count: \(package.questions.count)")
        print("Current MiniPlayer Questions Preloading is: \(self.currentQuestions.count)")
        
        // Ensure there are questions available
        
        let questions = package.questions
        currentQuestions = questions
        print("Current MiniPlayer Questions Postloading is: \(self.currentQuestions.count)")
        
        let currentlyPlayingQuestion = self.currentQuestions[currentQuestionIndex]
        let audioFile = currentlyPlayingQuestion.questionAudio
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            audioContentPlayer.playAudioFile(audioFile)
        }
    }
    
    func syncInteractionState(_ interactionState: InteractionState) {
        DispatchQueue.main.async {
            if interactionState == .isDonePlaying {
                self.interactionState = .isListening
                intermissionPlayer.playListeningBell()
                
            } else if interactionState  == .successfulTranscription {
                self.interactionState = .successfulResponse
                intermissionPlayer.playReceivedResponseBell()
            }
        }
    }
    
    func interactionStateAction(_ interactionState: InteractionState) {
        if interactionState == .isListening {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                responseListener.recordAnswer()
            }
        } else if interactionState == .successfulResponse {
            analyseResponse()
        } else if interactionState == .hasResponded {
            //MARK: TODO - Conditional check for continous playback
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.interactionState = .resumingPlayback
                proceedWithQuiz()
            }
        }
    }
    
    
    //MARK: Step 2  - checks Player Interaction states
    func checkPlayerState(_ interaction: InteractionState) {
        DispatchQueue.main.async {
            if interaction == .isDonePlaying {
                intermissionPlayer.playListeningBell()
                
                self.startRecordingAnswer()
                
            } else if interaction  == .successfulResponse {
                
                self.analyseResponse()
                
            } else if interaction == .hasResponded {
                //intermissionPlayer.playReceivedResponseBell()
                //MARK: TODO - Conditional check for continous playback
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.interactionState = .resumingPlayback
                    //Alternate method: self.pauseQuiz()
                }
                
            } else if interaction == .resumingPlayback  {
                self.proceedWithQuiz()
            }
        }
    }
    //MARK: Step 2 Processes  - Record Answer
    func startRecordingAnswer() {
        self.responseListener.recordAnswer()
    }
    //MARK: Step 2 Processes - Continue Playing Logic
    func proceedWithQuiz() {
        // Check if the current index is less than the count of current questions
        guard currentQuestions.indices.contains(currentQuestionIndex) else {
            print("Index out of bounds: \(currentQuestionIndex) for questions count: \(currentQuestions.count)")
            return
        }
        
        self.currentQuestionIndex += 1
        
        if currentQuestions.indices.contains(currentQuestionIndex) {
            self.continuePlaying()
            
        } else {
            print("Reached end of questions. Total questions: \(currentQuestions.count)")
            dismissAction()
            //MARK: TODO - IMPLEMENT INTERMISSION END QUIZ
        }
    }
    //MARK: Step 2 Processes - Continue Playing Method
    private func continuePlaying() {
        print("Continuation Condition Met")
        
        let currentQuestion = self.currentQuestions[currentQuestionIndex]
        let audioFile = currentQuestion.questionAudio
        interactionState = .isNowPlaying
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            audioContentPlayer.playAudioFile(audioFile)
        }
    }
    
    
    //MARK: Steps 3: Analyse Response
    func checkForResponse(_ interaction: InteractionState) {
        DispatchQueue.main.async {
            
            if interaction == .isListening {
                self.interactionState = interaction
                print("CheckForResponse Method registered interactionState as: \(interaction)")
            }
            
            if interaction == .successfulResponse  {
                self.selectedOption = responseListener.userTranscript
                print("Mini Player view has registered new selectedOption as: \(self.selectedOption)")
                analyseResponse()
            }
        }
    }
    //MARK: Step 3 Processes  - Analyzing Answer
    func analyseResponse() {
        let response = responseListener.userTranscript
        self.selectedOption = response
        selectOption(self.selectedOption)
    }
    //MARK: Step 3 Processes  - Selecting Option and Advancing interactionState to responded or errorResponse
    private func selectOption(_ option: String) {
        DispatchQueue.main.async {
            print("Saving response")
            let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
            currentQuestion.selectedOption = option
            
            //MARK: TODO - Check if answer was given before marking as true
            currentQuestion.isAnswered = true
            
            if currentQuestion.selectedOption == currentQuestion.correctOption {
                currentQuestion.isAnsweredCorrectly = true
            }
            
            self.isCorrectAnswer = currentQuestion.isAnsweredCorrectly
            self.interactionState = .hasResponded
            
            print("Presenting Confirmation")
            print("User selected \(self.currentQuestions[self.currentQuestionIndex].selectedOption) option")
            print("Current question is answered: \(self.currentQuestions[self.currentQuestionIndex].isAnswered)")
            print("Question \(self.currentQuestions[self.currentQuestionIndex].id) was answered correctly?: \(self.currentQuestions[self.currentQuestionIndex].isAnsweredCorrectly)")
            print("The correct option is: \(currentQuestion.correctOption)")
            print(self.interactionState)
        }
    }
    
    
    //MARK: Direct Click Action Methods.
    //MARK: Show Full Screen Method
    func expandAction() {
        self.interactionState = .isNowPlaying
        configuration.interactionState = self.interactionState
        presentationManager.interactionState = self.interactionState
        presentationManager.expandSheet = true
        playSingleQuizQuestion()
    }
    //MARK: Dismiss Full Screen Method
    func dismissAction() {
        presentationManager.interactionState = .idle
        presentationManager.expandSheet = false
        currentQuestionIndex = 0
        self.interactionState = .idle
    }
    
    
    //MARK: SCREEN TRANSITION OBSERVERS
    //MARK: Library/Homepage QuizStatus Observer
    func handleInteractionStateChange(_ state: QuizPlayerState) {
        if state == .startedPlayingQuiz {
            expandAction()
            startQuizAudioPlay(self.interactionState)
        }
        
        if state == .endedQuiz {
            dismissAction()
        }
    }
    //MARK: FullScreen Player Observer
    func showMiniPlayerMicModal() -> Bool {
        return expandSheet == false && interactionState == .isListening
    }
    //MARK: FullScreen Player Observer
    func showMiniPlayerConfirmationModal()  -> Bool  {
        return expandSheet == false && interactionState == .hasResponded
    }
    
    
    //MARK: TODO Continuity Methods
    func pauseQuiz(currentIndex: Int) {
        //Save currentIndex to userdefaults
        //change interactionState to .pausedPlayback
        //audioContentPlayer.pauseQuiz()
    }
    func continueFromPause() {
        //call on userdefaults to loadup last index
        //pass index to currentQuestionIndex
        //call startAudioQuiz(self.interactionState)
        
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

