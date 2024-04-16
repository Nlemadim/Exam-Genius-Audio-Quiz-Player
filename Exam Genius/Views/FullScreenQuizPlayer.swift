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
    @State private var animateContent: Bool = false
    @State private var timer: Timer?
    @State var optionA: String = ""
    @State var optionB: String = ""
    @State var optionC: String = ""
    @State var optionD: String = ""
    @State var question: String = ""
    @Binding var currentQuestionIndex: Int
    //@Binding var isNowPlaying: Bool
    @Binding var isCorrectAnswer: Bool
    @Binding var presentMicModal: Bool
    //@Binding var nextTapped: Bool
    @Binding var interactionState: InteractionState
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
                        VStack(spacing: 0){
                            Image(quizSetter.configuration?.imageUrl ??  "IconImage")
                                .resizable()
                                .frame(width: 280, height: 280)
                                .cornerRadius(20)
                                .padding()
                            
                            Text((quizSetter.configuration?.shortTitle ?? "") + " Audio Quiz")
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .hAlign(.center)
                                .padding()
                        }
                        
                        Spacer()
                        
                        PlayerControlButtons(isNowPlaying: .constant(interactionState == .isNowPlaying),
                                             themeColor: generator.dominantLightToneColor,
                                             repeatAction: { presentMicModal.toggle() },
                                             playAction: { playAudio()},
                                             nextAction: { goToNextQuestion() }
                        )
                    }
                    .padding()
                    .hAlign(.center)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {dismiss()}, label: {
                            Image(systemName: "chevron.down.circle")
                                .foregroundStyle(.white)
                        })
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { /*  shareAction() */}, label: {
                            Image(systemName: "text.quote")
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20.0)
                            
                        })
                    }
                }
                .background(generator.dominantBackgroundColor)
                .onAppear {
                    generator.updateAllColors(fromImageNamed: quizSetter.configuration?.imageUrl ?? "IconImage")
                    withAnimation(.easeInOut(duration: 0.35)) {
                        animateContent = true
                    }
                    showContent()
                }
                .onChange(of: currentQuestionIndex) { _, _ in
                    showContent()
                }
                .onChange(of: quizSetter.configuration) { _, _ in
                    showContent()
                }
            }
            .sheet(isPresented: .constant(interactionState == .isListening), content: {
                MicModalView(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor)
                    .presentationDetents([.height(100)])
            })
            .sheet(isPresented: .constant(interactionState == .hasResponded), content: {
                ConfirmationModalView(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor, isCorrect: isCorrectAnswer)
                    .presentationDetents([.height(200)])
                    .onAppear {
                        //print(isCorrectAnswer)
                        //MARK: Simulating Overview readout
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.interactionState = .idle
//                            print(isCorrectAnswer)
                        }
                    }
                    
            })
            .onDisappear(perform: {
                onViewDismiss()
            })
            
        }
    }
    
    func playAudio() {
        //isNowPlaying.toggle()
    }
    
    func goToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func showContent() {
        // Safely unwrap configuration and ensure currentIndex is within the range of questions.
        guard let questions = quizSetter.configuration?.questions, questions.indices.contains(currentQuestionIndex) else { return }
        
        let currentQuestion = questions[currentQuestionIndex]
        
        // Update state with the current question and options
        question = currentQuestion.questionContent
        optionA = currentQuestion.optionA
        optionB = currentQuestion.optionB
        optionC = currentQuestion.optionC
        optionD = currentQuestion.optionD
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

//#Preview {
//    let user = User()
//    @Namespace var animation
//    @State var curIndex = 0
//    @State var config = QuizViewConfiguration(imageUrl: "CHFP-Exam-Pro", name: "CHFP Exam", shortTitle: "CHFP")
//    let quizSetter = MiniPlayer.MiniPlayerConfiguration()
//    quizSetter.configuration = config
//    return FullScreenQuizPlayer2(quizSetter: quizSetter, expandSheet: .constant(false), currentQuestionIndex: .constant(0),  isNowPlaying: .constant(false), isCorrectAnswer: .constant(false), presentMicModal: .constant(false), nextTapped: .constant(false), interactionState: .constant(.idle), onViewDismiss: {}, animation: animation)
//        .environmentObject(user)
//        .preferredColorScheme(.dark)
//}


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
