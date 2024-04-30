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
    
    @State var questionTranscript: String = ""
    @State var interactionFeedbackMessage: String = ""
    @StateObject private var generator = ColorGenerator()
    @StateObject private var audioContentPlayer = AudioContentPlayer()
    @StateObject private var questionPlayer = QuestionPlayer()
    @StateObject private var intermissionPlayer = IntermissionPlayer()

    @StateObject var responseListener = ResponseListener()
    @StateObject private var configuration: MiniPlayerV2Configuration
    @State var currentQuestions: [Question] = []
    
    @Binding var selectedQuizPackage: DownloadedAudioQuiz?
    @Binding var feedbackMessageUrls: FeedBackMessageUrls?
    @State var expandSheet: Bool = false
    @Binding var interactionState: InteractionState
    @State var startPlaying: Bool = false
    
    @State var currentPlaylistItemIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    
    @State var presentMicModal: Bool = false
    @State var isCorrectAnswer: Bool = false
    @State var presentConfirmationModal: Bool = false
    
    init(selectedQuizPackage: Binding<DownloadedAudioQuiz?>, feedbackMessageUrls: Binding<FeedBackMessageUrls?>, interactionState: Binding<InteractionState>, startPlaying: Binding<Bool>) {
        _selectedQuizPackage = selectedQuizPackage
        _feedbackMessageUrls = feedbackMessageUrls
        _interactionState = interactionState
        
        let sharedState = SharedQuizState()
        _configuration = StateObject(wrappedValue: MiniPlayerV2Configuration(sharedState: sharedState))
    }

    var body: some View {
        HStack(spacing: 10) {
            playerThumbnail
            playerDetails
            MiniQuizControlView(
                recordAction: { self.interactionState = .isListening},
                playPauseAction: { startQuizAudioPlay(self.interactionState) },
                nextAction: { goToNextQuestion() },
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
                questionTranscript: $interactionFeedbackMessage,
                onViewDismiss: { },
                playAction: {playSingleQuizQuestion() /*startQuizAudioPlay(self.interactionState)*/ },
                nextAction: { goToNextQuestion() },
                recordAction: { self.interactionState = .isListening }
            )
        }
        .sheet(isPresented: .constant(showMiniPlayerMicModal()), content: {
            MicModalView(
                interactionState: $interactionState,
                mainColor: generator.dominantBackgroundColor,
                subColor: generator.dominantLightToneColor)
                .presentationDetents([.height(100)])
        })
        .onTapGesture {
            withAnimation {
                expandAction()
            }
        }
        .onAppear {
            setupViewConfigurations()
        }
        .onChange(of: currentQuestionIndex) { _, _ in
            updateQuestionScriptViewer()
        }
        .onChange(of: user.downloadedQuiz) { _, newPackage in
            updateViewWithPackage(newPackage)
        }
        .onChange(of: configuration.currentQuizPackage) { _, newPackage in
            updateCurrentQuestions(newPackage)
        }
        .onChange(of: questionPlayer.interactionState) { _, newState in
            syncInteractionState(newState)
        }
        .onChange(of: responseListener.interactionState) { _, newState in
            syncInteractionState(newState)
        }
        .onChange(of: intermissionPlayer.feedbackPlayerState) { _, newState in
            print("IntermissionPlayer feedBackState is : \(newState)")
            syncInteractionState(newState)
        }
        .onChange(of: audioContentPlayer.interactionState) { _, newState in
            syncInteractionState(newState)
        }
        .onChange(of: interactionState) { _, newState in
            DispatchQueue.main.async {
                self.interactionStateAction(newState)
                self.updateFeedbackMessage(newState)
//                self.configuration.sharedState.updateInteractionState(newState: newState)
                self.configuration.loadQuestionScriptViewer(question: self.interactionFeedbackMessage)
            }
        }
        .onChange(of: selectedQuizPackage) {_, newPackage in
            updateViewWithPackage(newPackage)
        }
        .onChange(of: quizPlayerObserver.playerState) {_, newValue in
            print("Mini Player Quiz-Player-Observer registered as: \(newValue)")
            handleQuizObserverInteractionStateChange(newValue)
        }
    }

    private var playerThumbnail: some View {
        GeometryReader { geometry in
            Image(user.downloadedQuiz?.quizImage ?? "Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
        }
        .frame(width: 45, height: 45)
    }

    private var playerDetails: some View {
        Text(user.downloadedQuiz?.shortTitle ?? "No Quiz Selected")
            .font(.footnote)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


extension MiniPlayerV2 {
    //MARK: VIEW SET UP METHODS
    func setupViewConfigurations() {
        generator.updateAllColors(fromImageNamed: self.configuration.configuration?.imageUrl ?? "")
        if let newPackage = self.selectedQuizPackage {
            configuration.loadQuizConfiguration(quizPackage: newPackage)
            configuration.quizQuestionCount = selectedQuizPackage?.questions.count ?? 0
        }
    }
    
    var transcript: String {
        return """
               \(currentQuestions[currentQuestionIndex].questionContent)
               
               A: \(currentQuestions[currentQuestionIndex].options[0])
               
               B: \(currentQuestions[currentQuestionIndex].options[1])
               
               C: \(currentQuestions[currentQuestionIndex].options[2])
               
               D: \(currentQuestions[currentQuestionIndex].options[3])
               
               """
    }
    
    func playFeedbackMessage(_ messageUrl: String?) {
        if let feedbackMessageUrl = messageUrl {
            intermissionPlayer.playVoiceFeedBack(feedbackMessageUrl)
            DispatchQueue.main.async {
                self.interactionState = .playingFeedbackMessage
            }
        }
    }
    
    func playEndQuizFeedbackMessage(_ messageUrl: String?) {
        if let feedbackMessageUrl = messageUrl {
            intermissionPlayer.playEndQuizFeedBack(feedbackMessageUrl)
            
        }
    }
    
    func updateQuestionScriptViewer() {
        guard currentQuestions.indices.contains(currentQuestionIndex) else { return }
        let question = currentQuestions[currentQuestionIndex].questionContent
        configuration.loadQuestionScriptViewer(question: question)
    }
    
    func updateViewWithPackage(_ newPackage: DownloadedAudioQuiz?) {
        if let package = newPackage {
            configuration.loadQuizConfiguration(quizPackage: package)
        }
    }
    
    
    // MARK: QUIZ LOGICS
    //MARK: READY QUESTIONS
    func updateCurrentQuestions(_ newPackage: DownloadedAudioQuiz?) {
        if let package = newPackage {
            self.currentQuestions = package.questions.filter { !$0.questionAudio.isEmpty }
        }
    }
    
    //MARK: STEP 1: Quiz Entry Point - Now Playing
    func startQuizAudioPlay(_ quizState: InteractionState) {
        if quizState == .idle {
            //intermissionPlayer.playVoiceFeedBack(feedbackMessageUrls?.startMessage ?? "")
            self.interactionState = .isNowPlaying
            configuration.interactionState = self.interactionState
            presentationManager.interactionState = self.interactionState
            presentationManager.expandSheet = true
            quizPlayerObserver.playerState = .startedPlayingQuiz
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        
//        print("Selected quiz package: \(package.quizname), with questions count: \(package.questions.count)")
//        print("Current MiniPlayer Questions Preloading is: \(self.currentQuestions.count)")
        
        // Ensure there are questions available
        
        let questions = package.questions
        currentQuestions = questions
        print("Current MiniPlayer Questions Postloading is: \(self.currentQuestions.count)")
        
        let currentlyPlayingQuestion = self.currentQuestions[currentQuestionIndex]
        let audioFile = currentlyPlayingQuestion.questionAudio
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            questionPlayer.playAudioFile(audioFile)
            
        }
    }
    
    func updateFeedbackMessage(_ interactionState: InteractionState) {
        switch interactionState {
        case .isNowPlaying:
            self.interactionFeedbackMessage = transcript
            
        case .errorTranscription:
            self.interactionFeedbackMessage = "Transcription Error!"
            
        case .isListening:
            self.interactionFeedbackMessage = transcript
            
        case .playingFeedbackMessage:
            self.interactionFeedbackMessage = "Skipping this question for now"
            
        case .idle:
            self.interactionFeedbackMessage = "Starting a new quiz!"
      
        case .isCorrectAnswer:
            self.interactionFeedbackMessage = "\(self.currentQuestions[self.currentQuestionIndex].selectedOption) is correct"
            
        case .isIncorrectAnswer:
            self.interactionFeedbackMessage = "Incorrect!\n The correct option is \(self.currentQuestions[self.currentQuestionIndex].correctOption)"
        
        case .nowPlayingCorrection:
            self.interactionFeedbackMessage = self.currentQuestions[self.currentQuestionIndex].questionNote
            print("interactionFeedbackMessage playing correction: \(self.currentQuestions[self.currentQuestionIndex].questionNote)")
            
        case .donePlayingFeedbackMessage:
            self.interactionFeedbackMessage = "Moving on..."
            
        default:
            break
        }
    }
    
    //MARK: Step 2  - InteractionState Sync and Update
    private func syncInteractionState(_ interactionState: InteractionState) {
        DispatchQueue.main.async {
            switch interactionState {
            case .isNowPlaying:
                //startPlaying Triggers the questionTranscriptView in Full screen to startTyping
                self.startPlaying = true
               
            case .isDonePlaying:
                self.startPlaying = false
                intermissionPlayer.playListeningBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .isListening
                }

            case .hasResponded:
                intermissionPlayer.playReceivedResponseBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .successfulResponse
                }
            
            case .isDonePlayingCorrection:
                self.intermissionPlayer.playErrorTranscriptionBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .resumingPlayback
                }
            case .donePlayingFeedbackMessage:
                self.intermissionPlayer.playErrorTranscriptionBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .resumingPlayback
                }
                
            case .endedQuiz:
                self.intermissionPlayer.playErrorTranscriptionBell()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .endedQuiz
                }
                
            default:
                break
            }
        }
    }
    
    func interactionStateAction(_ interactionState: InteractionState) {
        print("iteractionStateAction is acting on \(interactionState) state")
        switch interactionState {
       
        case .isListening:
            startRecordingAnswer() //Changes interaction to .isListening
        
        case .successfulResponse:
            analyseResponse()//Changes interaction to .isProcessing -> isCorrectAnswer OR isIncCorrectAnswer Or .errorResponse
            
        case .resumingPlayback:
            //self.interactionState = .idle
           proceedWithQuiz()//Changes interaction to .nowPlaying
            
        case .isIncorrectAnswer:
            playCorrectionAudio()//Changes interaction to .nowPlayingCorrection
            
        case .isCorrectAnswer:
            proceedWithQuiz()
            //setContinousPlayInteraction(learningMode: true) // Changes to resumingPlayback OR pausedPlayback based on User LearningMode Settings
            
        case .errorTranscription:
            playFeedbackMessage(feedbackMessageUrls?.errorMessage) // Changes to .playingFeedback
            //MARK: TODO - Create Method to check for repeat listen settings
            
        case .endedQuiz:
            dismissAction()
            
            //FOR Now Moving on
            
        default:
            break
       
        }
    }
    
    //MARK: Step 2 Processes  - Record Answer
    func startRecordingAnswer() {
        self.responseListener.recordAnswer()
    }
    
    //MARK: Step 2 Processes - Continue Playing Logic
    func proceedWithQuiz() {
        // Check if the current index is less than the count of current questions
//        guard currentQuestions.indices.contains(currentQuestionIndex) else {
//            print("Index out of bounds: \(currentQuestionIndex) for questions count: \(currentQuestions.count)")
//            return
//        }
        
        self.currentQuestionIndex += 1
        
        if currentQuestions.indices.contains(currentQuestionIndex) {
            self.continuePlaying()
            
        } else {

            playEndQuizFeedbackMessage(feedbackMessageUrls?.endMessage)
            self.currentQuestionIndex = 0
        }
    }
    
    private func playCorrectionAudio() {
        DispatchQueue.main.async {
            self.interactionState = .nowPlayingCorrection
            let correctionAudio = currentQuestions[currentQuestionIndex].questionNoteAudio
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                audioContentPlayer.playAudioFile(correctionAudio)
            }
        }
    }
    
    //MARK: Step 2 Processes - Continue Playing Method
    private func continuePlaying() {
        print("Continuation Condition Met")
        
        let currentQuestion = self.currentQuestions[currentQuestionIndex]
        let audioFile = currentQuestion.questionAudio
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.interactionState = .isNowPlaying
            questionPlayer.playAudioFile(audioFile)
        }
    }
    
    private func setContinousPlayInteraction(learningMode isEnabled: Bool) {
        //MARK: TODO - Conditional check for continous playback
        if isEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.interactionState = .resumingPlayback
            }
        } else {
            self.interactionState = .pausedPlayback
        }
    }
        
    //MARK: Steps 3: Analyse Response
    
    //MARK: Step 3 Processes  - Analyzing Answer
    func analyseResponse() {
        let response = responseListener.userTranscript
        self.selectedOption = response
        selectOption(self.selectedOption)
    }
    //MARK: Step 3 Processes  - Selecting Option and Advancing interactionState to responded or errorResponse
    private func selectOption(_ option: String) {
        guard !option.isEmptyOrWhiteSpace else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.interactionState = .errorTranscription
            }
            
            return
        }
        
        DispatchQueue.main.async {
            print("Saving response")
            let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
            currentQuestion.selectedOption = option
            
            //MARK: TODO - Check if answer was given before marking as true
            currentQuestion.isAnswered = true
            
            if currentQuestion.selectedOption == currentQuestion.correctOption {
                currentQuestion.isAnsweredCorrectly = true
                
                playFeedbackMessage(feedbackMessageUrls?.correctAnswerCallout)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.interactionState = .isCorrectAnswer
                }
                //intermissionPlayer.playCorrectBell()
//                if currentQuestions.indices.contains(currentQuestionIndex + 1) {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                        self.interactionState = .isCorrectAnswer
//                    }
//                    
//                } else {
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                        self.interactionState = .endedQuiz
//                    }
//                }
                
            } else {
                
                self.interactionState = .isIncorrectAnswer

                currentQuestion.isAnsweredCorrectly = false
            }
            
            self.isCorrectAnswer = currentQuestion.isAnsweredCorrectly
            
            print("Presenting Confirmation")
            print("User selected \(self.currentQuestions[self.currentQuestionIndex].selectedOption) option")
            print("Current question is answered: \(self.currentQuestions[self.currentQuestionIndex].isAnswered)")
            print("Question \(self.currentQuestions[self.currentQuestionIndex].id) was answered correctly?: \(self.currentQuestions[self.currentQuestionIndex].isAnsweredCorrectly)")
            print("The correct option is: \(currentQuestion.correctOption)")
            print(self.interactionState)
        }
    }
    
    private func resetQuizAndGetScore() {
        DispatchQueue.main.async {
            print("Reseting Quiz and Saving Score")
            
            self.currentQuestions.forEach { question in
                question.selectedOption = ""
                question.isAnswered = false
                question.isAnsweredCorrectly = false
            }
        }
    }
    
    func goToNextQuestion() {
        currentQuestionIndex += 1
        playSingleQuizQuestion()
    }
    
    
    //MARK: Direct Click Action Methods.
    //MARK: Show Full Screen Method
    func expandAction() {
        guard selectedQuizPackage != nil else { return }
        self.interactionState = .isNowPlaying
        configuration.interactionState = self.interactionState
        presentationManager.interactionState = self.interactionState
        presentationManager.expandSheet = true
        playSingleQuizQuestion()
    }
    
    //MARK: Dismiss Full Screen Method
    func dismissAction() {
        resetQuizAndGetScore()
        presentationManager.interactionState = .idle
        self.interactionState = .idle
        currentQuestionIndex = 0
        quizPlayerObserver.playerState = .endedQuiz
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presentationManager.expandSheet = false
        }
    }
    
    //MARK: SCREEN TRANSITION OBSERVERS
    //MARK: Library/Homepage QuizStatus Observer
    func handleQuizObserverInteractionStateChange(_ state: QuizPlayerState) {
        DispatchQueue.main.async {
            self.quizPlayerObserver.playerState = state
            if state == .startedPlayingQuiz {
                expandAction()
                startQuizAudioPlay(self.interactionState)
            }
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
        //questionPlayer.pauseQuiz()
    }
    
    func continueFromPause() {
        //call on userdefaults to loadup last index
        //pass index to currentQuestionIndex
        //call startAudioQuiz(self.interactionState)
        
    }
}


@Observable class SharedQuizState {
    var interactionState: InteractionState = .idle
    //@Published var currentQuizPackage: AudioQuizPackage?
    
    //MARK: updateInteractionState(newState: InteractionState) Method used to communicate State of Play between MiniPlay thorugh MiniPlayer extension MiniPlayConfiguration class
    //Update
    // Add any other shared states or methods to handle updates
    func updateInteractionState(newState: InteractionState) {
        self.interactionState = newState
    }
}

