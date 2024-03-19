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



struct PlayerContent {
    var titleImage: Image
    var title: String
    var shortTitle: String
    var questions: [String] = []
}

struct TestQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var generator = ColorGenerator()
    @State var selectedAudioQuiz: AudioQuizPackage
    @State var displayedText: String = ""
    @State private var messageIndex: Int = 0
    @State private var timer: Timer?
    @State var currentTypingIndex = 0
    @State var typingTexts: [String] = []

    @State var question: String = "Which principle asserts that the law should govern a nation, as opposed to being governed by decisions of individual government officials?"
    @State var optionA: String = "Rule of Law"
    @State var optionB: String = "Separation of Powers"
    @State var optionC: String = "Judicial Review"
    @State var optionD: String = "Parliamentary Sovereignty"
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 15) {
                    /// Exam Icon Image
                    Image(selectedAudioQuiz.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        /// Long Name
                        Text(selectedAudioQuiz.name)
                            .font(.body)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .lineLimit(2, reservesSpace: false)
                        
                        Spacer().frame(height: 40)
                        
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .activeGlow(generator.dominantLightToneColor, radius: 0.7)
                            .hAlign(.trailing)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                dismiss()
                            }
                        
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
                
//                Image(systemName: "text.quote")
//                    .font(.title2)
//                    .foregroundStyle(.white)
//                    .activeGlow(generator.dominantLightToneColor, radius: 0.7)
//                    .hAlign(.trailing)
//                    .padding(.horizontal, 20)
                
                Spacer()
                
                PlayerControlButtons(isNowPlaying: true, themeColor: generator.dominantLightToneColor, repeatAction: {}, playAction: {}, nextAction: {})
                
                
            }
            .padding(.top, 16)
            .onAppear {
                generator.updateAllColors(fromImageNamed: selectedAudioQuiz.imageUrl)
            }
        }
        .preferredColorScheme(.dark)
        .background(generator.dominantBackgroundColor)
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
        .opacity(question.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    @ViewBuilder
    func optionA(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option A")
                .font(.headline)
                
            Text(optionA)
                .font(.body)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 20)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func optionB(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option B")
                .font(.headline)
                
            Text(optionB)
                .font(.body)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 20)
        .padding(.horizontal)
        .opacity(optionB.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    @ViewBuilder
    func optionC(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option C")
                .font(.headline)
                
            Text(optionC)
                .font(.body)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 20)
        .padding(.horizontal)
        .opacity(optionC.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    @ViewBuilder
    func optionD(_ option: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Option D")
                .font(.headline)
            
            Text(optionD)
                .font(.body)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 20)
        .padding(.horizontal)
        .opacity(optionD.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    private func startTypingAnimation() {
        displayedText = ""
        messageIndex = 0
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if self.messageIndex < self.typingTexts[self.currentTypingIndex].count {
                let index = self.typingTexts[self.currentTypingIndex].index(self.typingTexts[self.currentTypingIndex].startIndex, offsetBy: self.messageIndex)
                self.displayedText += String(self.typingTexts[self.currentTypingIndex][index])
                self.messageIndex += 1
            } else {
                timer.invalidate()
                self.currentTypingIndex += 1
                if self.currentTypingIndex < self.typingTexts.count {
                    self.startTypingAnimation()
                }
            }
        }
    }
    
    func prepareForTyping(question: Question) {
        // Reset the typing texts and index
        typingTexts = []
        currentTypingIndex = 0

        // Add the question content and options to the typing texts
        typingTexts.append(question.questionContent)
        typingTexts.append(contentsOf: question.options)

        // Start the typing animation
        startTypingAnimation()
    }

}

#Preview {
    do {
        let user = User()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "DL-Exam-Basic", category: [.legal])
        let options = ["None whatsoever", "You get to find out what love has got to do with it", "Much More Love", "Much less love"]
        let newQuestion = [Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""), Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""), Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: "")]
        //package.questions.append(contentsOf: newQuestion)
      
   
        return TestQuizView(selectedAudioQuiz: package)
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
}

