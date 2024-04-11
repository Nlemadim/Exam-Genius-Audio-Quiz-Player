//
//  QuizView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/9/24.
//

import SwiftUI

//struct QuizView: View {
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var generator = ColorGenerator()
//    //@Binding var configuration: QuizViewConfiguration
//    @State var optionA: String = ""
//    @State var optionB: String = ""
//    @State var optionC: String = ""
//    @State var optionD: String = ""
//    @State var question: String = ""
//    @ObservedObject var quizSetter: QuizPlayerView.QuizSetter
//    @Binding var currentQuestionIndex: Int
//    @Binding var isNowPlaying: Bool
//    @Binding var isCorrectAnswer: Bool
//    @Binding var presentMicModal: Bool
//    @Binding var nextTapped: Bool
//    @Binding var interactionState: InteractionState
//    @State var testInteractionState: InteractionState = .idle
//    
//    var body: some View {
//        ZStack {
//            VStack(alignment: .leading, spacing: 10) {
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
//                
//                VStack(alignment: .center, spacing: 0) {
//                    questionContent(question)
//                    optionA(optionA)
//                    optionB(optionB)
//                    optionC(optionC)
//                    optionD(optionD)
//                }
//                .frame(maxWidth: .infinity)
//                .frame(maxHeight: 500)
//                .background(
//                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
//                        .fill(generator.dominantLightToneColor)
//                        .padding(.horizontal, 10)
//                )
//                
//                Spacer()
//                
//                PlayerControlButtons(isNowPlaying: .constant(interactionState == .isNowPlaying),
//                                     themeColor: generator.dominantLightToneColor,
//                                     repeatAction: { dismiss() },
//                                     playAction: { playAudio()},
//                                     nextAction: { goToNextQuestion() }
//                )
//            }
//            .padding(.top, 16)
//            .onAppear {
//                generator.updateAllColors(fromImageNamed: quizSetter.configuration?.imageUrl ?? "")
//                showContent()
//            }
//            .onChange(of: currentQuestionIndex) { _, _ in
//                showContent()
//            }
//            .onChange(of: quizSetter.configuration) { _, _ in
//                showContent()
//            }
//        }
//        .sheet(isPresented: .constant(interactionState == .isListening), content: {
//            MicModalView(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor)
//                .presentationDetents([.height(100)])
//        })
//        .sheet(isPresented: .constant(interactionState == .hasResponded), content: {
//            ConfirmationModalView(interactionState: $interactionState, mainColor: generator.dominantBackgroundColor, subColor: generator.dominantLightToneColor, isCorrect: isCorrectAnswer)
//                .presentationDetents([.height(200)])
//                .onAppear {
//                    //print(isCorrectAnswer)
//                    //MARK: Simulating Overview readout
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        self.interactionState = .idle
//                        print(isCorrectAnswer)
//                    }
//                }
//        })
//        .preferredColorScheme(.dark)
//        .background(generator.dominantBackgroundColor)
//    }
//    
//    func playAudio() {
//        isNowPlaying.toggle()
//    }
//    
//    func goToNextQuestion() {
//        guard let nextQuestions = quizSetter.configuration?.questions else { return }
//        guard nextQuestions.indices.contains(currentQuestionIndex), currentQuestionIndex < nextQuestions.count - 1 else { return }
//        nextTapped.toggle()
//        currentQuestionIndex += 1
//    }
//    
//    func showContent() {
//        // Safely unwrap configuration and ensure currentIndex is within the range of questions.
//        guard let questions = quizSetter.configuration?.questions, questions.indices.contains(currentQuestionIndex) else { return }
//        
//        let currentQuestion = questions[currentQuestionIndex]
//        
//        // Update state with the current question and options
//        question = currentQuestion.questionContent
//        optionA = currentQuestion.optionA
//        optionB = currentQuestion.optionB
//        optionC = currentQuestion.optionC
//        optionD = currentQuestion.optionD
//    }
//
//    @ViewBuilder
//    func questionContent(_ content: String) -> some View {
//        VStack(alignment: .center, spacing: 4) {
//            Text("New Question")
//                .font(.headline)
//                
//            Text(question)
//                .font(.body)
//                .multilineTextAlignment(.center)
//                .minimumScaleFactor(0.5)
//                
//        }
//        .padding(.all, 20)
//        .padding(.horizontal)
//        //.opacity(question.isEmptyOrWhiteSpace ? 0 : 1)
//    }
//    
//    @ViewBuilder
//    func optionA(_ option: String) -> some View {
//        VStack(alignment: .center, spacing: 4) {
//            Text("Option A")
//                .font(.headline)
//                
//            Text(optionA)
//                .font(.subheadline)
//                .multilineTextAlignment(.center)
//                .minimumScaleFactor(0.5)
//        }
//        .padding(.all, 10)
//        .padding(.horizontal)
//        //.opacity(optionA.isEmptyOrWhiteSpace ? 0 : 1)
//    }
//    
//    @ViewBuilder
//    func optionB(_ option: String) -> some View {
//        VStack(alignment: .center, spacing: 4) {
//            Text("Option B")
//                .font(.headline)
//                
//            Text(optionB)
//                .font(.subheadline)
//                .multilineTextAlignment(.center)
//                .minimumScaleFactor(0.5)
//        }
//        .padding(.all, 10)
//        .padding(.horizontal)
//        //.opacity($optionB.isEmptyOrWhiteSpace ? 0 : 1)
//    }
//    
//    @ViewBuilder
//    func optionC(_ option: String) -> some View {
//        VStack(alignment: .center, spacing: 4) {
//            Text("Option C")
//                .font(.headline)
//                
//            Text(optionC)
//                .font(.subheadline)
//                .multilineTextAlignment(.center)
//                .minimumScaleFactor(0.5)
//        }
//        .padding(.all, 10)
//        .padding(.horizontal)
//        //.opacity(optionC.isEmptyOrWhiteSpace ? 0 : 1)
//    }
//    
//    @ViewBuilder
//    func optionD(_ option: String) -> some View {
//        VStack(alignment: .center, spacing: 4) {
//            Text("Option D")
//                .font(.headline)
//            
//            Text(optionD)
//                .font(.subheadline)
//                .multilineTextAlignment(.center)
//                .minimumScaleFactor(0.5)
//        }
//        .padding(.all, 20)
//        .padding(.horizontal)
//        //.opacity(optionD.isEmptyOrWhiteSpace ? 0 : 1)
//    }
//}
//
//#Preview {
//    @State var curIndex = 0
//    @State var config = QuizViewConfiguration(imageUrl: "CHFP-Exam-Pro", name: "CHFP Exam", shortTitle: "CHFP")
//    let quizSetter = QuizPlayerView.QuizSetter()
//    quizSetter.configuration = config
//    return QuizView(quizSetter: quizSetter, currentQuestionIndex: .constant(0), isNowPlaying: .constant(false), isCorrectAnswer: .constant(false), presentMicModal: .constant(false), nextTapped: .constant(false), interactionState: .constant(.idle))
//}


//struct PlayerContent {
//    var titleImage: Image
//    var title: String
//    var shortTitle: String
//    var questions: [String] = []
//}
