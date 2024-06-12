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
    @EnvironmentObject var errorManager: ErrorManager
    @ObservedObject var connectionMonitor = ConnectionMonitor()
    
    @State var questionTranscript: String = ""
    @State var interactionFeedbackMessage: String = ""
    @StateObject private var generator = ColorGenerator()
    @StateObject var audioContentPlayer = AudioContentPlayer()
    @StateObject var questionPlayer = QuestionPlayer()
    @StateObject var globalTimer = GlobalTimer()
    @StateObject var intermissionPlayer = IntermissionPlayer()

    @StateObject var responseListener = ResponseListener()
    @StateObject var configuration: MiniPlayerV2Configuration
    @State var miniPlayerState: MiniPlayerState = .minimized
    @State var currentQuestions: [Question] = []
    
    @Binding var selectedQuizPackage: DownloadedAudioQuiz?
    @Binding var feedbackMessageUrls: FeedBackMessageUrls?
    @State var isQandA: Bool = UserDefaultsManager.isQandAEnabled()
    @State var defaultQuestionCount: Int = UserDefaultsManager.numberOfTestQuestions()
    @State var quizName: String = UserDefaultsManager.quizName()
    
    
    @Binding var interactionState: InteractionState
    @Binding var refreshQuiz: Bool
    @State var selectedOptionButton: String? = nil
   
    @State var expandSheet: Bool = false
    @State var presentMiniModal: Bool = false
    @State var mainThemeColor: Color = .purple
    @State var subThemeColor: Color = .teal
    
    @State var currentPlaylistItemIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    @State var correctAnswerCount: Int = 0
    
    @State var presentMicModal: Bool = false
    @State var isCorrectAnswer: Bool = false
    @State var presentConfirmationModal: Bool = false
    
    init(selectedQuizPackage: Binding<DownloadedAudioQuiz?>, feedbackMessageUrls: Binding<FeedBackMessageUrls?>, interactionState: Binding<InteractionState>, refreshQuiz: Binding<Bool>) {
        _selectedQuizPackage = selectedQuizPackage
        _feedbackMessageUrls = feedbackMessageUrls
        _interactionState = interactionState
        _refreshQuiz = refreshQuiz
        
        let sharedState = SharedQuizState()
        _configuration = StateObject(wrappedValue: MiniPlayerV2Configuration(sharedState: sharedState))
    }
        
    var body: some View {
        HStack(spacing: 10) {
            playerThumbnail
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    playerDetails
                    //currentQuizStatus
                    currentQuestionNumber
                }
            }
            .padding(.top, 10)
            
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
                presentMiniModal = false
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
                onViewDismiss: { selectResponsePresenter() },
                playAction: { playAction() /*playPauseStop()*/ },
                nextAction: { goToNextQuestion() },
                recordAction: {  }
            )
        }
        .sheet(isPresented: .constant(presentMiniPlayerResponder())) {
            ResponseModalPresenter(interactionState: $interactionState, selectedOption: $selectedOptionButton, mainColor: mainThemeColor, subColor: subThemeColor)
                .presentationDetents([.height(140)])
                
        }
        .onAppear {
            setupViewConfigurations()
            setThemeColors()
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
        .onChange(of: selectedOptionButton) { _, selectedButton in
            registerSelectedOptionButton(selectedButton)
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
        selectResponsePresenter()
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

    private var playerDetails: some View {
        Text(user.downloadedQuiz?.shortTitle.uppercased() ?? "Not Playing")
            .font(.footnote)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4.0)
    }
    
    private var currentQuizStatus: some View {
        Text(quizPlayerObserver.playerState.status)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    private var currentQuestionNumber: some View {
        Text("Question \(currentQuestionIndex + 1) of \(currentQuestions.count)")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(quizPlayerObserver.playerState == .startedPlayingQuiz || quizPlayerObserver.playerState == .pausedCurrentPlay && expandSheet == false ? 1 : 0)
    }
    
    private var connectionErrorView: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundStyle(.black.dynamicTextColor())
            Text("No internet connection")
                .font(.system(size: 18))
                .foregroundStyle(.black.dynamicTextColor())
                .padding()
            
        }
    }
    
    func registerSelectedOptionButton(_ selectedButtonOption: String?) {
        guard selectedButtonOption != nil else { return }
        
        intermissionPlayer.playReceivedResponseBell()
    }
}


extension MiniPlayerV2 {
    //MARK: VIEW SET UP METHODS
    func setupViewConfigurations() {
        generator.updateAllColors(fromImageNamed: self.configuration.configuration?.imageUrl ?? "")
        if let newPackage = self.selectedQuizPackage {
            configuration.loadQuizConfiguration(quizPackage: newPackage)
            //configuration.quizQuestionCount = selectedQuizPackage?.questions.count ?? 0
            configuration.quizQuestionCount = currentQuestions.count
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
        configuration.quizQuestionCount = currentQuestions.count
    }
    
    func updateViewWithPackage(_ newPackage: DownloadedAudioQuiz?) {
        if let package = newPackage {
            configuration.loadQuizConfiguration(quizPackage: package)
            configuration.quizQuestionCount = currentQuestions.count
        }
    }
    
    // MARK: QUIZ LOGICS
    //MARK: READY QUESTIONS
//    func updateCurrentQuestions(_ newPackage: DownloadedAudioQuiz?) {
//        if let package = newPackage {
//            self.currentQuestions = package.questions.filter { !$0.questionAudio.isEmpty && !$0.isAnswered }
//        }
//    }
    
    func updateCurrentQuestions(_ newPackage: DownloadedAudioQuiz?) {
        if let package = newPackage {
            var filteredQuestions = package.questions.filter { !$0.questionAudio.isEmpty && !$0.isAnswered }
            
            // Limit the number of questions to defaultQuestionCount
            if filteredQuestions.count > 15 {
                filteredQuestions = Array(filteredQuestions.shuffled().prefix(15))
            }
            
            self.currentQuestions = filteredQuestions
            configuration.quizQuestionCount = self.currentQuestions.count
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
    
    func startRecordingAnswerV2(answer options: [String]) {
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
            UserDefaultsManager.incrementNumberOfCurrentQuizSessions()
            self.selectedQuizPackage?.quizzesCompleted += 1
            self.currentQuestions = []
//            self.currentQuestions.forEach { question in
//                question.selectedOption = ""
//                question.isAnswered = false
//                question.isAnsweredCorrectly = false
//            }
        }
    }
    
    
    
   
    
    //MARK: Step 3 Processes - Analyzing Response
    func executeSuccessfulResponseSequence() {
        resetMiniplayerResponsePresenter() 
        let response = self.selectedOptionButton ?? responseListener.userTranscript

        guard !response.isEmptyOrWhiteSpace else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.interactionState = .noResponse
                    
                }
           
            return
        }

        guard response != "Invalid Response" || response != "IncorrectAnswer" else {

            //MARK:TODO Modify to NoResponse
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.interactionState = .isIncorrectAnswer
            }
            return
        }

        self.selectedOption = response
        selectOption(self.selectedOption)
        self.selectedOptionButton = nil
        UserDefaultsManager.incrementTotalQuestionsAnswered()
    }
    
    func executeCorrectAnswerSequence() {
        if self.isQandA {
            playFeedbackMessage(feedbackMessageUrls?.correctAnswerCallout)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.interactionState = .resumingPlayback
            }
        } else {
            self.intermissionPlayer.playErrorTranscriptionBell()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.interactionState = .resumingPlayback
            }
        }
    }

    private func resetMiniplayerResponsePresenter() {
        if presentMiniModal {
            self.presentMiniModal = false
        }
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
                self.interactionState = .isCorrectAnswer
                
                self.executeCorrectAnswerSequence()
            
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
    func presentMiniPlayerResponder() -> Bool {
        return expandSheet == false && interactionState == .isListening || interactionState == .awaitingResponse
    }

    
    //Mark: Redundant Method
    func fetchQuizReview(review readOut: String) async -> String {
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared, errorManager: errorManager)
        //let questions = audioQuiz.questions
        let readOutUrl = await contentBuilder.downloadReadOut(readOut: readOut) ?? ""
        
        return readOutUrl
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


