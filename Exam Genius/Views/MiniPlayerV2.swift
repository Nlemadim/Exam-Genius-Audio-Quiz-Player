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
    @StateObject var globalTimer = GlobalTimer()
    @StateObject var intermissionPlayer = IntermissionPlayer()

    @StateObject var responseListener = ResponseListener()
    @StateObject var configuration: MiniPlayerV2Configuration
    @State var currentQuestions: [Question] = []
    
    @Binding var selectedQuizPackage: DownloadedAudioQuiz?
    @Binding var feedbackMessageUrls: FeedBackMessageUrls?
    @State var expandSheet: Bool = false
    @Binding var interactionState: InteractionState
    @State var startPlaying: Bool = false
    @State var selectedOptionButton: String? = nil
    @State var miniPlayerState: MiniPlayerState = .minimized
    @State var presentMiniModal: Bool = false
    @State var mainThemeColor: Color = .themePurple
    @State var subThemeColor: Color = .teal
    
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
                playPauseAction: { playAction() },
                nextAction: { goToNextQuestion() },
                repeatAction: {},
                interactionState: $interactionState
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                expandSheet.toggle()
            }
        }
        .fullScreenCover(isPresented: $expandSheet/*.constant(expandSheet == true)*/) {
            FullScreenQuizPlayer2(
                quizSetter: configuration,
                currentQuestionIndex: .constant(currentQuestionIndex),
                selectedOptionButton: $selectedOptionButton,
                presentMicModal: $presentMicModal,
                interactionState: $configuration.interactionState,
                questionTranscript: $interactionFeedbackMessage,
                expandSheet: $expandSheet,
                onViewDismiss: { /*expandSheet = false*/ },
                playAction: { playAction() /*playPauseStop()*/ },
                nextAction: { goToNextQuestion() },
                recordAction: {  }
            )
        }
        .sheet(isPresented: $presentMiniModal) {
            ResponseModalPresenter(interactionState: $interactionState, selectedOption: $selectedOptionButton, mainColor: mainThemeColor, subColor: subThemeColor)
                .presentationDetents([.height(140)])
        }
        .onAppear {
            setupViewConfigurations()
            setThemeColors()
            
            //debugReset()
        }
        .onChange(of: expandSheet) { _, _ in
            selectResponsePresenter()
        }
        .onChange(of: currentQuestionIndex) { _, newValue in
            updateQuestionScriptViewer()
        }
        .onChange(of: user.downloadedQuiz) { _, newPackage in
            updateViewWithPackage(newPackage)
            setThemeColors()
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
        .onChange(of: selectedOptionButton) { _, newOptionSelection in
            registerSelectedOptionButton(newOptionSelection)
        }
        .onChange(of: globalTimer.interactionState) { _, newState in
            presentResponseInterface(newState)
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
    
    
    private func setThemeColors() {
        generator.updateAllColors(fromImageNamed: user.selectedQuizPackage?.imageUrl ?? "Logo")
        DispatchQueue.main.async {
            self.mainThemeColor = generator.dominantBackgroundColor
            self.subThemeColor = generator.enhancedDominantColor
        }
    }
    
    
    private func playAction() {
        if self.interactionState == .idle || self.interactionState == .pausedPlayback {
            startOrContinue()
        } else {
            pauseQuiz(currentIndex: self.currentQuestionIndex)
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
    
    func showFullScreen() -> Bool {
        return expandSheet == true &&  presentationManager.expandSheet == true
    }

    private var playerDetails: some View {
        Text(user.downloadedQuiz?.shortTitle ?? "No Quiz Selected")
            .font(.footnote)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func registerSelectedOptionButton(_ selectedButtonOption: String?) {
        guard selectedButtonOption != nil else { return }
        DispatchQueue.main.async {
            if let selectedButtonOption, !selectedButtonOption.isEmptyOrWhiteSpace {
                self.interactionState = .successfulResponse
            } else {
                //self.interactionState = .noResponse
                //playFeedbacMessage(noResponseFeedback)
            }
        }
    }
    
//    private func updatePublishedQuestionIndex(value: Int) {
//        guard currentQuestions.indices.contains(value) else { return }
//        DispatchQueue.main.async {
//            if value == 0 {
//                configuration.currentQuestionIndex =  1
//                print("Updated config index to : \(configuration.currentQuestionIndex)")
//            } else {
//                configuration.currentQuestionIndex = value + 1
//                print("Updated config index to : \(configuration.currentQuestionIndex)")
//            }
//        }
//    }
    
//    private func loadCurrentQuizStatus() {
//        let isInProgress = UserDefaultsManager.quizInProgress()
//        print("OnAppear quiz is in progress: \(isInProgress)")
//        let currentStreak = UserDefaultsManager.currentScoreStreak()
//        if isInProgress {
//            self.quizPlayerObserver.playerState = .pausedCurrentPlay
//            self.interactionState = .pausedPlayback
//            loadPlayerPositions()
//            self.correctAnswerCount = currentStreak
//        }
//    }
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
        // Calculate score percentage
        let scorePercentage = calculatedScore(correctAnswers: self.correctAnswerCount, totalQuestions: self.currentQuestions.count)

        // Determine the score enum case based on percentage
        let scoreEnum = self.scoreCategory(for: scorePercentage)

        // Define feedback messages using a switch statement
        let feedbackMessage: String
        switch scoreEnum {
        case .zero:
            feedbackMessage = feedbackMessageUrls?.zeroScoreComment ?? "No correct answers. Try again!"
        case .ten:
            feedbackMessage = feedbackMessageUrls?.tenPercentScoreComment ?? "You scored 10% Keep trying!"
        case .twenty:
            feedbackMessage = feedbackMessageUrls?.twentyPercentScoreComment ?? "20% You can do better!"
        case .thirty:
            feedbackMessage = feedbackMessageUrls?.thirtyPercentScoreComment ?? "You scored 30% Getting there!"
        case .forty:
            feedbackMessage = feedbackMessageUrls?.fortyPercentScoreComment ?? "You scored 40% Almost half way!"
        case .fifty:
            feedbackMessage = feedbackMessageUrls?.fiftyPercentScoreComment ?? "50% Half way there!"
        case .sixty:
            feedbackMessage = feedbackMessageUrls?.sixtyPercentScoreComment ?? "60% Better than average!"
        case .seventy:
            feedbackMessage = feedbackMessageUrls?.seventyPercentScoreComment ?? "You scored 70% Good job!"
        case .eighty:
            feedbackMessage = feedbackMessageUrls?.eightyPercentScoreComment ?? "You scored 80% Great work!"
        case .ninety:
            feedbackMessage = feedbackMessageUrls?.ninetyPercentScoreComment ?? "You scored 90% Excellent!"
        case .perfect:
            feedbackMessage = feedbackMessageUrls?.perfectScoreComment ?? "Perfect score!"
        }

        // Return the determined feedback message
        return feedbackMessage
    }
    
    // Helper method to categorize the score
    private func scoreCategory(for percentage: CGFloat) -> Score {
        switch percentage {
        case 0:
            return .zero
        case 1..<10:
            return .ten
        case 10..<20:
            return .twenty
        case 20..<30:
            return .thirty
        case 30..<40:
            return .forty
        case 40..<50:
            return .fifty
        case 50..<60:
            return .sixty
        case 60..<70:
            return .seventy
        case 70..<80:
            return .eighty
        case 80..<90:
            return .ninety
        case 90...100:
            return .perfect
        default:
            return .zero // handle unexpected values
        }
    }
   
    //error point
    
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
        print("OnAppear, current play position: \(savedPos)")
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
    
   
    
    //MARK: Step 2 Processes  - Record Answer
    
    
    func startRecordingAnswer() {
        self.responseListener.recordAnswer()
    }
    
    func presentOptionButtons() {
        DispatchQueue.main.async {
            self.interactionState = .awaitingResponse
        }
    }
    
    private func presentMic() {
        DispatchQueue.main.async {
            self.interactionState = .isListening
        }
    }
    
    private func startRecordingAnswerV2(answer options: [String]) {
        self.responseListener.recordAnswerV2(answer: options)
    }
    
    
    
    
    func resetQuizAndGetScore() {
        let score = calculatedScore(correctAnswers: self.correctAnswerCount, totalQuestions: self.currentQuestions.count)
        let newPerformance: PerformanceModel = PerformanceModel(id: UUID(), quizName: selectedQuizPackage?.quizname ?? "new Quiz", date: .now, score: score, numberOfQuestions: self.currentQuestions.count)
        modelContext.insert(newPerformance)
        try! modelContext.save()

        DispatchQueue.main.async {
            print("Reseting Quiz and Saving Score")
            self.correctAnswerCount = 0
            UserDefaultsManager.updateCurrentScoreStreak(correctAnswerCount: 0)
            UserDefaultsManager.updateCurrentPosition(0)
            UserDefaultsManager.incrementNumberOfQuizSessions()
            self.selectedQuizPackage?.quizzesCompleted += 1
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
    
    
    
    
  
    
    //MARK: Step 3 Processes - Analyzing Response
    func executeSuccessfulResponseSequence() {
        if presentMiniModal {
            self.presentMiniModal = false
        }
        let response = self.selectedOptionButton ?? responseListener.userTranscript

        guard !response.isEmptyOrWhiteSpace else {
            if self.selectedOptionButton == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.interactionState = .errorTranscription
                }
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
        UserDefaultsManager.incrementTotalQuestionsAnswered()
    }

//    private func analyseButtonResponse() {
//        guard !selectedOption.isEmptyOrWhiteSpace else { return }
//        selectOption(self.selectedOption)
//        UserDefaultsManager.incrementTotalQuestionsAnswered()
//    }
    
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
                self.interactionState = .isCorrectAnswer
                
                playFeedbackMessage(feedbackMessageUrls?.correctAnswerCallout)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.interactionState = .resumingPlayback
                }
                
            } else {
                
                self.interactionState = .isIncorrectAnswer
                currentQuestion.isAnsweredCorrectly = false
            }
            
            self.isCorrectAnswer = currentQuestion.isAnsweredCorrectly
        }
    }
    
    
    
    
    //Mark: Redundant Method
    func fetchQuizReview(review readOut: String) async -> String {
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        //let questions = audioQuiz.questions
        let readOutUrl = await contentBuilder.downloadReadOut(readOut: readOut) ?? ""
        
        return readOutUrl
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
    
    //MARK: TODO - Integrate Method For Continous Play Implementation
    func updateAudioQuizQuestions() async {
        let questionCount = UserDefaultsManager.numberOfTestQuestions()
        
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

enum MiniPlayerState {
    case minimized
    case expanded
    case isActive
    case isInActive
}


