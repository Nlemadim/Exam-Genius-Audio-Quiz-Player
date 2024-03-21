//
//  QuizView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/9/24.
//

import SwiftUI
import SwiftData

struct QuizView: View {
    @EnvironmentObject var user: User
    @StateObject private var generator = ColorGenerator()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                if let selectedAudioQuiz = user.selectedQuizPackage {
                    HStack(alignment: .center, spacing: 15) {
                        /// Exam Icon Image
                        Image(selectedAudioQuiz.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            /// Long Name
                            Text(selectedAudioQuiz.name)
                                .font(.body)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .lineLimit(2, reservesSpace: true)
                            
                            /// Short Name
                            Text(selectedAudioQuiz.acronym)
                                .foregroundStyle(.primary)
                                .opacity(0.6)
                            
                            /// Question Number
                            Text("Questions: \(selectedAudioQuiz.questions.count)")
                                .foregroundStyle(.secondary)
                                .opacity(0.6)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
   
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .center) {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 500)
                    .padding(.top,10)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(generator.dominantDarkToneColor)
                            .padding(.horizontal)
                    
                    )
                    
                    Spacer()
                }
            }
            .onAppear {
                generator.updateAllColors(fromImageNamed: user.selectedQuizPackage?.name ?? "IconImage")
            }
        }
        .background(
            Image( user.selectedQuizPackage?.imageUrl ?? "IconImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 140)
        
        )
    }
}

struct TestQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generator = ColorGenerator()
    //@Binding var configuration: QuizViewConfiguration
    @State var optionA: String = ""
    @State var optionB: String = ""
    @State var optionC: String = ""
    @State var optionD: String = ""
    @State var question: String = ""
    @Binding var isNowPlaying: Bool
    @ObservedObject var quizSetter: QuizPlayerView.QuizSetter
    @Binding var currentQuestionIndex: Int
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 15) {
                    /// Exam Icon Image
                    Image(quizSetter.configuration?.imageUrl ?? "IconImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        /// Long Name
                        Text(quizSetter.configuration?.name ?? "Error! No Quiz Content")
                            .font(.body)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .lineLimit(2, reservesSpace: false)
                        
                        Spacer().frame(height: 40)
                        
                        //MARK: TODO - Place Quiz Progress Bar Here
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.horizontal)

                
                VStack(alignment: .center, spacing: 0) {
                    questionContent(question)
                    optionA(optionA)
                    optionB(optionB)
                    optionC(optionC)
                    optionD(optionD)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 500)
                .background(
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(generator.dominantLightToneColor)
                        .padding(.horizontal, 10)
                )
                
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .activeGlow(generator.dominantLightToneColor, radius: 0.7)
                    .hAlign(.trailing)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
                
                PlayerControlButtons(isNowPlaying: isNowPlaying,
                                     themeColor: generator.dominantLightToneColor,
                                     repeatAction: {},
                                     playAction: { isNowPlaying.toggle() },
                                     nextAction: { quizSetter.configuration?.config.nextQuestion()}
                )
            }
            .padding(.top, 16)
            .onAppear {
                generator.updateAllColors(fromImageNamed: quizSetter.configuration?.imageUrl ?? "")
                showContent()
                print("Test QuizView has Registered \(String(describing: quizSetter.configuration?.questions.count)) Questions ready for viewing")
            }
            .onChange(of: currentQuestionIndex) { _, _ in
                showContent()
                print("Current Question Index on QuizPlayer is \(currentQuestionIndex)")
            }
            .onChange(of: quizSetter.configuration) { _, _ in
                showContent()
            }
        }
        .preferredColorScheme(.dark)
        .background(generator.dominantBackgroundColor)
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


    
    @ViewBuilder
    func questionContent(_ content: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("New Question")
                .font(.headline)
                
            Text(question)
                .font(.body)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                
        }
        .padding(.all, 20)
        .padding(.horizontal)
        //.opacity(question.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    @ViewBuilder
    func optionA(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option A")
                .font(.headline)
                
            Text(optionA)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 10)
        .padding(.horizontal)
        //.opacity(optionA.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    @ViewBuilder
    func optionB(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option B")
                .font(.headline)
                
            Text(optionB)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 10)
        .padding(.horizontal)
        //.opacity($optionB.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    @ViewBuilder
    func optionC(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option C")
                .font(.headline)
                
            Text(optionC)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 10)
        .padding(.horizontal)
        //.opacity(optionC.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    @ViewBuilder
    func optionD(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option D")
                .font(.headline)
            
            Text(optionD)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 20)
        .padding(.horizontal)
        //.opacity(optionD.isEmptyOrWhiteSpace ? 0 : 1)
    }

}

#Preview {
    @State var curIndex = 0
    @State var config = QuizViewConfiguration(imageUrl: "CHFP-Exam-Pro", name: "CHFP Exam", shortTitle: "CHFP", config: ControlConfiguration(playPauseQuiz: {}, nextQuestion: {}, repeatQuestion: {}, endQuiz: {}))
    let quizSetter = QuizPlayerView.QuizSetter()
    quizSetter.configuration = config
    return TestQuizView(isNowPlaying: .constant(false), quizSetter: quizSetter, currentQuestionIndex: $curIndex)
//    do {
//        let user = User()
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
//        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "CHFP-Exam-Pro", category: [.legal])
//        let options = ["None whatsoever", "You get to find out what love has got to do with it", "Much More Love", "Much less love"]
//        let newQuestion = [Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""), Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""), Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: "")]
//        //package.questions.append(contentsOf: newQuestion)
//      
//   
//        return TestQuizView(selectedAudioQuiz: package, didTapPlay: .constant(false))
//            .modelContainer(container)
//            .environmentObject(user)
//    } catch {
//        return Text("Failed to create Preview: \(error.localizedDescription)")
//    }
}


//func updateSelectedQuiz() {
//    self.selectedAudioQuiz = AudioQuizPackage(id: UUID(),
//                                                 name: "California Bar (MBE)",
//                                                 acronym: "(MBE)",
//                                                 about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ",
//                                                 imageUrl: "DL-Exam-Basic",
//                                                 category: [.education],
//                                                 topics: [],
//                                                 questions: [Question(id: UUID(), questionContent: "What is the punishment for showing love?", questionNote: "", topic: "Legal Love", options: ["None whatsoever", "You get to find out what love has got to do with it", "Much More Love", "Much less love"], correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""),
//                                                             Question(id: UUID(), questionContent: "How does society benefit from love?", questionNote: "", topic: "Societal Love", options: ["None whatsoever", "You get to find out what love has got to do with it", "Much More Love", "Much less love"], correctOption: "B", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""),
//                                                             Question(id: UUID(), questionContent: "What role does love play in personal development?", questionNote: "", topic: "Personal Development", options: ["None whatsoever", "You get to find out what love has got to do with it", "Much More Love", "Much less love"], correctOption: "C", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: "")],
//                                                 performance: [])
//}
