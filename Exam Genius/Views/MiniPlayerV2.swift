//
//  MiniPlayerV2.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/13/24.
//

import SwiftUI
import Combine

struct MiniPlayerV2: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var user: User
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @EnvironmentObject var presentationManager: QuizViewPresentationManager
    
    @State var questionTranscript: String = ""
    @State var interactionFeedbackMessage: String = ""
    @StateObject private var generator = ColorGenerator()
    @StateObject var audioContentPlayer = AudioContentPlayer()
    @StateObject var questionPlayer = QuestionPlayer()
//    @StateObject private var intermissionPlayer = IntermissionPlayerV2()
    @StateObject var intermissionPlayer = IntermissionPlayer()

    @StateObject var responseListener = ResponseListener()
    @StateObject var configuration: MiniPlayerV2Configuration
    @State var currentQuestions: [Question] = []
    
    @Binding var selectedQuizPackage: DownloadedAudioQuiz?
    @Binding var feedbackMessageUrls: FeedBackMessageUrls?
    @State var expandSheet: Bool = false
    @Binding var interactionState: InteractionState
    @State var startPlaying: Bool = false
    @State var outputPower: Float = 0.0
    
    @State var currentPlaylistItemIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    @State var correctAnswerCount: Int = 0
    
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
                recordAction: { self.interactionState = .isListening },
                playPauseAction: { playPauseStop() },
                nextAction: { goToNextQuestion() },
                repeatAction: {},
                interactionState: $interactionState
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                appearIfQuiz()
            }
        }
        .fullScreenCover(isPresented: $presentationManager.shouldShowFullScreen) {
            FullScreenQuizPlayer2(
                quizSetter: configuration,
                currentQuestionIndex: $currentQuestionIndex,
                isCorrectAnswer: $isCorrectAnswer,
                presentMicModal: $presentMicModal,
                interactionState: $configuration.interactionState,
                questionTranscript: $interactionFeedbackMessage,
                powerSimulator: $outputPower,
                onViewDismiss: { simpleDismiss() },
                playAction: { playPauseStop() },
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
                self.updateConfigurationState(interactionState: newState)
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
    
    private func simpleDismiss() {
        presentationManager.expandSheet = false
        expandSheet = false
    }
    
    private func appearIfQuiz() {
        presentationManager.expandSheet = true
        expandSheet = true
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
    
    func getPercentage(correctAnswers: Int, totalQuestions: Int) -> String {
        let scorePercentage = calculatedScore(correctAnswers: correctAnswers, totalQuestions: totalQuestions)
        return String(format: "%.0f%%", scorePercentage)
    }
    
    private func calculatedScore(correctAnswers: Int, totalQuestions: Int) -> CGFloat {
        guard totalQuestions > 0 else { return 0.0 }  // Prevent division by zero
        let score = (CGFloat(correctAnswers) / CGFloat(totalQuestions)) * 100.0
        return score
    }
    
    func scoreReadout() -> String {
        let scorePercentage = calculatedScore(correctAnswers: self.correctAnswerCount, totalQuestions: self.currentQuestions.count)
        let compliments = ["", "Well Done", "Good Job", "Very Nice", "Excellent"] // compliments based on 0-25, 26-50, 51-75, 76-99, 100
        let index = min(Int(scorePercentage / 25), compliments.count - 1) // Calculate index for selecting compliment
        
        let compliment = compliments[index] // Select compliment based on score
        
        let scoreString: String
        if scorePercentage == 0.0 {
            scoreString = "You did not get any questions correct"
        } else {
            scoreString = "You Scored "+(String(format: "%.0f %%", scorePercentage))
        }
         
        
        let readOut = """
        
        \(compliment)
        
        \(scoreString)
        
        """
        print(readOut)
        return readOut
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
    
    func loadPlayerPositions() {
         let savedPos = UserDefaultsManager.currentPlayPosition()
         self.currentQuestionIndex = savedPos
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
    
   
    //MARK: Step 2  - InteractionState Sync and Update
   
    
    //MARK: Step 2 Processes  - Record Answer
    func startRecordingAnswer() {
        self.responseListener.recordAnswer()
    }
    
    func startRecordingAnswerV2(answer options: [String]) {
        self.responseListener.recordAnswerV2(answer: options)
    }
    
    
    private func resetQuizAndGetScore() {
        let score = calculatedScore(correctAnswers: self.correctAnswerCount, totalQuestions: self.currentQuestions.count)
        let newPerformance: PerformanceModel = PerformanceModel(id: UUID(), date: .now, score: score, numberOfQuestions: self.currentQuestions.count)
        modelContext.insert(newPerformance)
        try! modelContext.save()
        
//        Task {
//            await updateAudioQuizQuestions()
//        }
        DispatchQueue.main.async {
            print("Reseting Quiz and Saving Score")
            self.currentQuestions.forEach { question in
                question.selectedOption = ""
                question.isAnswered = false
                question.isAnsweredCorrectly = false
            }
        }
    }
    
//    func prepareToUpdateAudioQuiz() async {
//        guard let package = user.selectedQuizPackage, package.questions.count <= 100 else { return }
//        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
//        
//    }
    
    func updateAudioQuizQuestions() async {
        let questionCount = 10
        
        if let audioQuiz = user.selectedQuizPackage {
            let newQuestions = audioQuiz.questions.filter { $0.questionAudio.isEmptyOrWhiteSpace && !$0.isAnswered }
            var questionsToDownload = newQuestions.shuffled()
            
            // Ensure we do not exceed the questionCount
            if questionsToDownload.count > questionCount {
                questionsToDownload = Array(questionsToDownload.prefix(questionCount))
            }
            
            let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
            await contentBuilder.downloadAudioQuestions(for: questionsToDownload)
            selectedQuizPackage?.questions = questionsToDownload
            
            DispatchQueue.main.async {
                user.downloadedQuiz = self.selectedQuizPackage
            }
        }
    }
    
    func fetchQuizReview(review readOut: String) async -> String {
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        //let questions = audioQuiz.questions
        let readOutUrl = await contentBuilder.downloadReadOut(readOut: readOut) ?? ""
        
        return readOutUrl
        
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
        
        guard !response.isEmptyOrWhiteSpace  else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.interactionState = .errorTranscription
            }
            
            return
        }
        
        guard response != "Invalid Response" else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.interactionState = .errorResponse
            }
            
            return
        }
        
        self.selectedOption = response
        selectOption(self.selectedOption)
    }
    
    //MARK: Step 3 Processes  - Selecting Option and Advancing interactionState to responded or errorResponse
    private func selectOption(_ option: String) {

        DispatchQueue.main.async {
            print("Saving response")
            let currentQuestion = self.currentQuestions[self.currentQuestionIndex]
            currentQuestion.selectedOption = option
            currentQuestion.isAnswered = true
            
            if currentQuestion.selectedOption == currentQuestion.correctOption {
                currentQuestion.isAnsweredCorrectly = true
                self.correctAnswerCount += 1
                
                playFeedbackMessage(feedbackMessageUrls?.correctAnswerCallout)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.interactionState = .isCorrectAnswer
                }
                
            } else {
                
                self.interactionState = .isIncorrectAnswer
                currentQuestion.isAnsweredCorrectly = false
            }
            
            self.isCorrectAnswer = currentQuestion.isAnsweredCorrectly
            
        }
    }
    
    func isActivePlay() -> Bool {
        let activeStates: [InteractionState] = [.isNowPlaying, .nowPlayingCorrection, .playingErrorMessage, .playingFeedbackMessage]
        return activeStates.contains(self.interactionState)
        
    }
    
    //MARK: FullScreen Player Observer
    func showMiniPlayerMicModal() -> Bool {
        return expandSheet == false && interactionState == .isListening
    }
    //MARK: FullScreen Player Observer
    func showMiniPlayerConfirmationModal()  -> Bool  {
        return expandSheet == false && interactionState == .hasResponded
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

