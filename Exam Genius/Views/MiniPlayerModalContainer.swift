//
//  MiniPlayerModalContainer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct MiniPlayerModalContainer: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generator = ColorGenerator()
    @ObservedObject var quizSetter: MiniPlayerV2.MiniPlayerV2Configuration
    
    @State var questionsComplete: Bool = false
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
    @Binding var expandSheet: Bool
    
    var onViewDismiss: () -> Void?
    var playAction: () -> Void
    var nextAction: () -> Void
    var recordAction: () -> Void
    var body: some View {
        VStack {
            if expandSheet {
                FullScreenQuizPlayer2(
                    quizSetter: quizSetter,
                    currentQuestionIndex: $currentQuestionIndex,
                    isCorrectAnswer: $isCorrectAnswer,
                    presentMicModal: $presentMicModal,
                    interactionState: $interactionState,
                    questionTranscript: $questionTranscript,
                    expandSheet: $expandSheet,
                    onViewDismiss: { },
                    playAction: { playAction() },
                    nextAction: { nextAction() },
                    recordAction: {  }
                )
            }
            
            if showMiniPlayerResponseModal() {
                
            }
        }
        ZStack {
            if expandSheet {
                VStack {
                    
                }
                .fullScreenCover(isPresented: $expandSheet/*.constant(expandSheet == true)*/) {
                    FullScreenQuizPlayer2(
                        quizSetter: quizSetter,
                        currentQuestionIndex: $currentQuestionIndex,
                        isCorrectAnswer: $isCorrectAnswer,
                        presentMicModal: $presentMicModal,
                        interactionState: $interactionState,
                        questionTranscript: $questionTranscript,
                        expandSheet: $expandSheet,
                        onViewDismiss: { },
                        playAction: { playAction() },
                        nextAction: { nextAction() },
                        recordAction: {  }
                    )
                }
            }
            
            if showMiniPlayerResponseModal() {
                VStack {
                   
                }
                .sheet(isPresented: .constant(showMiniPlayerResponseModal()), content: {
                    ResponseModalPresenter(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor)
                        .presentationDetents([.height(150)])
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                self.interactionState = .idle
                            }
                        }
                })
            }
        }
        .onAppear {
            generator.updateAllColors(fromImageNamed: quizSetter.configuration?.imageUrl ?? "IconImage")
        }
    }
    
    func showMiniPlayerResponseModal() -> Bool {
        return expandSheet == false && interactionState == .isListening || interactionState == .awaitingResponse
    }
}

#Preview {
    @State var curIndex = 0.9
    @State var config = QuizViewConfiguration(imageUrl: "ELA-Exam", name: "English, Language, Arts", shortTitle: "ELA", question: "")
    let sharedState = SharedQuizState()
    let quizSetter = MiniPlayerV2.MiniPlayerV2Configuration(sharedState: sharedState)
    quizSetter.configuration = config
    
    return MiniPlayerModalContainer(quizSetter: quizSetter, currentQuestionIndex: .constant(Int(curIndex)), isCorrectAnswer: .constant(false), presentMicModal: .constant(false), interactionState: .constant(.idle), questionTranscript: .constant("Hello Transcript"), expandSheet: .constant(true), onViewDismiss: {}, playAction: {}, nextAction: {}, recordAction: {})
        .preferredColorScheme(.dark)
       
    
}
