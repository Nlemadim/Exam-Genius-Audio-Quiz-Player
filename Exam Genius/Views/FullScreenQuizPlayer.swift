//
//  FullScreenQuizPlayer.swift
//  Exam Genius Audio Quiz Player
//
//  Created by Tony Nlemadim on 1/15/24.
//


//                HStack(alignment: .center, spacing: 15) {
//                    /// Exam Icon Image
//                    Image(quizSetter.configuration?.imageUrl ?? "IconImage")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 100, height: 100)
//                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
//
//                    VStack(alignment: .leading, spacing: 4) {
//                        /// Long Name
//                        Text(quizSetter.configuration?.name ?? "Error! No Quiz Content")
//                            .font(.body)
//                            .foregroundStyle(.white)
//                            .fontWeight(.semibold)
//                            .lineLimit(2, reservesSpace: false)
//
//                        Spacer().frame(height: 40)
//
//                        //MARK: TODO - Place Quiz Progress Bar Here
//
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                }
//                .padding(.horizontal)


import SwiftUI
import SwiftData


struct FullScreenQuizPlayer2: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generator = ColorGenerator()
    @ObservedObject var quizSetter: MiniPlayerV2.MiniPlayerV2Configuration
   
    @State var showText: Bool = false
    @State var isMuted: Bool = false
    @State private var offsetY: CGFloat = 0
    @State private var animateContent: Bool = false
    @State private var timer: Timer?
    @State var optionA: String = ""
    @State var optionB: String = ""
    @State var optionC: String = ""
    @State var optionD: String = ""
    @State var question: String = ""
    @Binding var currentQuestionIndex: Int
    @Binding var isCorrectAnswer: Bool
    @Binding var presentMicModal: Bool
    @Binding var interactionState: InteractionState
    @Binding var questionTranscript: String
    
    var onViewDismiss: () -> Void?
    var playAction: () -> Void
    var nextAction: () -> Void
    var recordAction: () -> Void
    
    //var animation: Namespace.ID
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 10) {
                    VStack {
                        VStack(spacing: 10){
                            
                            Image(quizSetter.configuration?.imageUrl ??  "IconImage")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .hAlign(.leading)
                            
                            Text((quizSetter.configuration?.shortTitle ?? "") + " Audio Quiz")
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .hAlign(.leading)
                            
                            QuestionCountVisualizer(index: currentQuestionIndex + 1, count: quizSetter.quizQuestionCount, fillColor:  generator.dominantBackgroundColor.dynamicTextColor())
                                //.padding(.horizontal, 3)
                               
                            Divider()
                               
                            
                        }
                        .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                        .padding()
                        .frame(width: 380, height: 180)
                        .frame(maxWidth: 380)
                        .padding(.horizontal, 3)
                        .padding(.bottom, 15)
                        //.offset(y: -30)
                        
                        
                        VStack(alignment: .center) {
                            Text(quizSetter.questionTranscript)
                                .fontWeight(.black)
                                .multilineTextAlignment(.center)
                                .kerning(0.3)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()

                        }
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                        
                        Divider()
                       
                        PlayerControlButtons(interactionState: $interactionState,
                                             themeColor: generator.dominantLightToneColor,
                                             recordAction: { recordAction() },
                                             playAction: { playAction()},
                                             nextAction: { goToNextQuestion() }
                        )
                    }
                    //.padding()
                    .hAlign(.center)
                    
                }
//                .navigationTitle((quizSetter.configuration?.shortTitle ?? "") + " Audio Quiz").foregroundStyle(.red)
//                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {dismiss()}, label: {
                            Image(systemName: "chevron.down.circle")
                                .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                        })
                    }
                }
                .background(generator.dominantBackgroundColor)
                .onAppear {
                    generator.updateAllColors(fromImageNamed: quizSetter.configuration?.imageUrl ?? "IconImage")
                    withAnimation(.easeInOut(duration: 0.35)) {
                        animateContent = true
                    }
                   // showContent()
                }
//                .onChange(of: currentQuestionIndex) { _, _ in
//                    showContent()
//                }
//                .onChange(of: quizSetter.configuration) { _, _ in
//                    showContent()
//                }
                .onChange(of: questionTranscript, { _, newValue in
                    startTypingAnimation(for: newValue)
                })
                .onChange(of: interactionState) { _, newState in
                    DispatchQueue.main.async {
                        self.interactionState = newState
                    }
                }
            }
            .sheet(isPresented: .constant(interactionState == .isListening), content: {
                MicModalView(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor)
                    .presentationDetents([.height(100)])
            })
            .onDisappear(perform: {
                onViewDismiss()
            })
        }
    }
    
    var progress: CGFloat {
        return CGFloat(currentQuestionIndex) / CGFloat(quizSetter.configuration?.question.count ?? 0)
    }

    func playButtonIconSetter() -> Bool {
        return interactionState == .isNowPlaying || interactionState == .resumingPlayback
    }
    
    
    func goToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func showContent() {
        // Safely unwrap configuration and ensure currentIndex is within the range of questions.
//        guard let questions = quizSetter.configuration?.question, questions.indices.contains(currentQuestionIndex) else { return }
//        
//        let currentQuestion = questions[currentQuestionIndex]
        
        // Update state with the current question and options
//        question = currentQuestion.questionContent
//        optionA = currentQuestion.optionA
//        optionB = currentQuestion.optionB
//        optionC = currentQuestion.optionC
//        optionD = currentQuestion.optionD
    }
    
    private func startTypingAnimation(for text: String) {
        var displayedText = ""
        var messageIndex = 0
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if messageIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: messageIndex)
                displayedText += String(text[index])
                messageIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}


struct TranscriptView: View {
    @Binding var interactionState: InteractionState
    @Binding var questionTranscript: String
    var color: Color
    @State private var timer: Timer?
    @State private var feedBackImage: String = ""
    @State private var showImageFeedback: Bool = false
    @State private var showTextFeedback: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image(systemName: interactionStateFeedBack(interactionState))
                    .resizable()
                    .foregroundStyle(color)
                    .frame(width: 80, height: 80)
                    .padding()
            }
            .opacity(showImageFeedback ? 1 : 0)
            
            VStack {
                Text(questionTranscript)
                    .font(.title2)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .kerning(0.3)
                    .foregroundStyle(color)
                    .offset(y: -50)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onAppear {
                        startTypingAnimation(for: questionTranscript)
                    }
            }
            .frame(maxHeight: .infinity)
            .opacity(showTextFeedback ? 1 : 0)
            
        }
        .onChange(of: self.interactionState) { _, newValue in
            DispatchQueue.main.async {
                self.feedbackSelector(newValue)
            }
        }
    }
    
    func feedbackSelector(_ interactionState: InteractionState)  {
        switch interactionState {
        case .isNowPlaying:
            showTextFeedback = true
            showImageFeedback = false
            
        case .isListening:
            showTextFeedback = false
            showImageFeedback = true
            
        case .errorResponse:
            showTextFeedback = false
            showImageFeedback = true
            
        case .isCorrectAnswer:
            showImageFeedback = true
            
        case .isIncorrectAnswer:
            showTextFeedback = true
            showImageFeedback = false
            
        case .nowPlayingCorrection:
            showTextFeedback = true
            showImageFeedback = false
            
        default:
            showTextFeedback = false
            showImageFeedback = false
        }
    }
    
    func interactionStateFeedBack(_ interactionState: InteractionState) -> String {
        switch interactionState {
            
        case .isListening:
            return "mic.fill"
        case .errorResponse:
            return "ear.trianglebadge.exclamationmark"
        case .isCorrectAnswer:
            return "hand.thumbsup.fill"
        case .isIncorrectAnswer:
            return "hand.thumbsdown.fill"
        case .resumingPlayback:
            return "book.fill"
        case .nowPlayingCorrection:
            return "book.fill"
        default:
            return ""
        }
    }
    
    private func startTypingAnimation(for text: String) {
        var displayedText = ""
        var messageIndex = 0
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if messageIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: messageIndex)
                displayedText += String(text[index])
                messageIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}



#Preview {
    let user = User()
    @Namespace var animation
    @State var curIndex = 0
    @State var config = QuizViewConfiguration(imageUrl: "CHFP-Exam-Pro", name: "CHFP Exam", shortTitle: "CHFP", question: "")
    let sharedState = SharedQuizState()
    let quizSetter = MiniPlayerV2.MiniPlayerV2Configuration(sharedState: sharedState)
    quizSetter.configuration = config
    
    return FullScreenQuizPlayer2(quizSetter: quizSetter, currentQuestionIndex: .constant(curIndex), isCorrectAnswer: .constant(false), presentMicModal: .constant(false), interactionState: .constant(.idle), questionTranscript: .constant("Hello Transcript"), onViewDismiss: {}, playAction: {}, nextAction: {}, recordAction: {})
        .environmentObject(user)
        .preferredColorScheme(.dark)
}


//#Preview {
//    let user = User()
//    @Namespace var animation
//    @State var curIndex = 0
//    @State var config = QuizViewConfiguration(imageUrl: "CHFP-Exam-Pro", name: "CHFP Exam", shortTitle: "CHFP")
//    let quizSetter = QuizPlayerView.QuizSetter()
//    quizSetter.configuration = config
//    return FullScreenQuizPlayer(expandSheet: .constant(false), quizSetter: quizSetter, currentQuestionIndex: .constant(0),  isNowPlaying: .constant(false), isCorrectAnswer: .constant(false), presentMicModal: .constant(false), nextTapped: .constant(false), interactionState: .constant(.idle), animation: animation)
//        .environmentObject(user)
//        .preferredColorScheme(.dark)
//}



//FullScreenQuizPlayer(expandSheet: .constant(false), animation: animation, quizSetter: quizSetter, currentQuestionIndex: .constant(0), isNowPlaying: .constant(false), isCorrectAnswer: .constant(false), presentMicModal: .constant(false), nextTapped: .constant(false), interactionState: .constant(.idle))
