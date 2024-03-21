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
    var imageUrl: Image
    var name: String
    var shortTitle: String
    var questions: [String] = []
}

struct TestQuizView: View {
    @Environment(\.dismiss) private var dismiss
    let quizPlayer = QuizPlayer.shared
    @StateObject private var generator = ColorGenerator()
    @State private var currentContentIndex = 0 // Track the index of the content array (question + options)
    @State private var charIndex = 0 // Track the current character index within the current string
    @State var selectedAudioQuiz: AudioQuizPackage
    @State var displayedText: String = ""
    @State private var messageIndex: Int = 0
    @State private var timer: Timer?
    @State var currentTypingIndex = 0
    @State var typingTexts: [String] = []

    @State var question: String = ""
    @State var optionA: String = ""
    @State var optionB: String = ""
    @State var optionC: String = ""
    @State var optionD: String = ""
    @Binding var didTapPlay: Bool
    
    
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
                
                PlayerControlButtons(isNowPlaying: true,
                                     themeColor: generator.dominantLightToneColor,
                                     repeatAction: {},
                                     playAction: { self.didTapPlay = true },
                                     nextAction: {}
                )
                
                
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
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
        .padding(.all, 10)
        .padding(.horizontal)
        .opacity(optionA.isEmptyOrWhiteSpace ? 0 : 1)
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
        .opacity(optionB.isEmptyOrWhiteSpace ? 0 : 1)
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
        .opacity(optionC.isEmptyOrWhiteSpace ? 0 : 1)
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
        .opacity(optionD.isEmptyOrWhiteSpace ? 0 : 1)
    }
    
    func startTypingAnimation() {
        guard !selectedAudioQuiz.questions.isEmpty else {
            print("Empty Collection")
            return }
        
        let questions = selectedAudioQuiz.questions
        // Ensure currentTypingIndex is within bounds
        guard currentTypingIndex < questions.count else {
            print("Current typing index is out of bounds.")
            return
        }
        
        // Prepare the content array
        let currentQuestion = questions[currentTypingIndex]
        let contentArray = [currentQuestion.questionContent] + currentQuestion.options

        // Reset indexes
        currentContentIndex = 0
        charIndex = 0

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {  timer in
            
            // Check if we've finished typing all contents
            if self.currentContentIndex >= contentArray.count {
                timer.invalidate()
                if self.currentTypingIndex + 1 < questions.count {
                    self.currentTypingIndex += 1
                    self.startTypingAnimation() // Move to the next question
                }
                return
            }

            // Current string to type
            let currentString = contentArray[self.currentContentIndex]

            // Check if we've finished typing the current string
            if self.charIndex < currentString.count {
                let index = currentString.index(currentString.startIndex, offsetBy: self.charIndex)
                let char = String(currentString[index])

                DispatchQueue.main.async {
                    // Update the appropriate @State variable safely on the main thread
                    switch self.currentContentIndex {
                    case 0:
                        self.question += char
                    case 1:
                        self.optionA += char
                    case 2:
                        self.optionB += char
                    case 3:
                        self.optionC += char
                    case 4:
                        self.optionD += char
                    default:
                        break
                    }
                }
                self.charIndex += 1
            } else {
                // Move to the next string
                DispatchQueue.main.async {
                    self.currentContentIndex += 1
                    self.charIndex = 0
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
    
    func simulateTyping() {
        // Example questions array, could be populated from anywhere
        let options = ["None whatsoever", "You get to find out what love has got to do with it", "Much More Love", "Much less love"]
        let questions = [Question(id: UUID(), questionContent: "What is the punishment for showing love?", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""),
                         Question(id: UUID(), questionContent: "How does society benefit from love?", questionNote: "", topic: "Societal Love", options: options, correctOption: "B", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""),
                         Question(id: UUID(), questionContent: "What role does love play in personal development?", questionNote: "", topic: "Personal Development", options: options, correctOption: "C", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: "")]

        // Iterate over each question and simulate typing its content and options
        for question in questions {
            self.question = question.questionContent
            self.optionA = question.options[0]
            self.optionB = question.options[1]
            self.optionC = question.options[2]
            self.optionD = question.options[3]
            
            prepareForTyping(question: question)
            // Assuming `prepareForTyping` automatically starts the typing animation
            // You might need to add a delay or completion handler here if you want to ensure each question is fully typed out before moving to the next one, depending on how your typing animation is implemented.
        }
    }

}

#Preview {
    do {
        let user = User()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "CHFP-Exam-Pro", category: [.legal])
        let options = ["None whatsoever", "You get to find out what love has got to do with it", "Much More Love", "Much less love"]
        let newQuestion = [Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""), Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: ""), Question(id: UUID(), questionContent: "What is the punishment for showing love", questionNote: "", topic: "Legal Love", options: options, correctOption: "A", selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: "", questionNoteAudio: "")]
        //package.questions.append(contentsOf: newQuestion)
      
   
        return TestQuizView(selectedAudioQuiz: package, didTapPlay: .constant(false))
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
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
