//
//  FullScreenQuizPlayer.swift
//  Exam Genius Audio Quiz Player
//
//  Created by Tony Nlemadim on 1/15/24.
//


import SwiftUI
import SwiftData


struct FullScreenQuizPlayer2: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generator = ColorGenerator()
    @ObservedObject var quizSetter: MiniPlayerV2.MiniPlayerV2Configuration
    
   
    @State var showText: Bool = false
    @State var isMuted: Bool = false
    @State private var offsetY: CGFloat = 0
    @State private var quizProgress: CGFloat = 0
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
    @Binding var powerSimulator: Float
    
    var onViewDismiss: () -> Void?
    var playAction: () -> Void
    var nextAction: () -> Void
    var recordAction: () -> Void
    let randomPower = [0, 1.2, 1.7, 3, 2, 1.6, 1.8, 2.7, 2.0, 3.5, 1.4]
    
    //var animation: Namespace.ID
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 10) {
                    VStack {
                        VStack(spacing: 10){
                            
                            HStack {
                                Image(quizSetter.configuration?.imageUrl ??  "IconImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .frame(height: 100)
                              
                                VStack {
                                    Text(quizSetter.configuration?.name ?? "")
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                        .padding(.top, 2)
                                        .hAlign(.leading)
                                    
                                    Text("Audio Quiz")
                                        .font(.subheadline)
                                        .padding(.top, 2)
                                        .foregroundStyle(.primary)
                                        .hAlign(.leading)
                                    
                                    Text("Question \(currentQuestionIndex + 1) of \(quizSetter.quizQuestionCount)")
                                        .font(.subheadline)
                                        .padding(.top, 2)
                                        .foregroundStyle(.primary)
                                        .hAlign(.leading)
                                    
                                }
                                .frame(height: 100)
                                Spacer()
                            }
                            
                            VoqaWaveViewWithSwitch(colors: [generator.dominantBackgroundColor, generator.dominantLightToneColor], supportLineColor: .mint, switchOn: .constant(isActivePlay()))
                                .frame(height: 25)
                                .padding(.top, 2)
                                
                        }
                        .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                        .padding()
                        .frame(width: 380, height: 180)
                        .frame(maxWidth: 380)
                        .padding(.horizontal, 3)
                        .padding(.bottom, 15)
                        
                        Divider()
                            .activeGlow(generator.dominantLightToneColor, radius: 0.5)
                        
                        VStack(alignment: .center) {
                            ZStack{
                                Text(quizSetter.questionTranscript)
                                    .fontWeight(.black)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .kerning(0.3)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                    //.opacity(quizSetter.currentScore.isEmptyOrWhiteSpace ? 1 : 0)
                                
//                                Text(quizSetter.currentScore)
//                                    .fontWeight(.black)
//                                    .multilineTextAlignment(.center)
//                                    .kerning(0.3)
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .padding()
//                                    .opacity(quizSetter.currentScore.isEmptyOrWhiteSpace ? 0 : 1)
                            }

                        }
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                        
                        Divider()
                            .activeGlow(generator.dominantLightToneColor, radius: 0.5)
                       
                        PlayerControlButtons(interactionState: $interactionState,
                                             themeColor: generator.dominantLightToneColor,
                                             recordAction: { recordAction() },
                                             playAction: { playAction()},
                                             nextAction: { goToNextQuestion() }
                        )
                    }
                    .hAlign(.center)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { dismiss() }, label: {
                            Image(systemName: "chevron.down.circle")
                                .foregroundStyle(generator.dominantBackgroundColor.dynamicTextColor())
                        })
                    }
                }
                .background(generator.dominantBackgroundColor.gradient)
                .onAppear {
                    generator.updateAllColors(fromImageNamed: quizSetter.configuration?.imageUrl ?? "IconImage")

                }
                .onChange(of: quizSetter.questionTranscript, { _, newValue in
                    startTypingAnimation(for: newValue)
                })
              
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
        return 0
    }

    func playButtonIconSetter() -> Bool {
        return interactionState == .isNowPlaying || interactionState == .resumingPlayback
    }
    
    private func outputLevel() -> Double {
        return Double(self.powerSimulator)
    }
    
    
    func goToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func isActivePlay() -> Bool {
        let activeStates: [InteractionState] = [.isNowPlaying, .nowPlayingCorrection, .playingErrorMessage, .playingFeedbackMessage]
        return activeStates.contains(self.interactionState)
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
    @State var curIndex = 0.9
    @State var config = QuizViewConfiguration(imageUrl: "ELA-Exam", name: "English, Language, Arts", shortTitle: "ELA", question: "")
    let sharedState = SharedQuizState()
    let quizSetter = MiniPlayerV2.MiniPlayerV2Configuration(sharedState: sharedState)
    quizSetter.configuration = config
    
    return FullScreenQuizPlayer2(quizSetter: quizSetter, currentQuestionIndex: .constant(Int(curIndex)), isCorrectAnswer: .constant(false), presentMicModal: .constant(false), interactionState: .constant(.isNowPlaying), questionTranscript: .constant("Hello Transcript"), powerSimulator: .constant(0.6), onViewDismiss: {}, playAction: {}, nextAction: {}, recordAction: {})
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
