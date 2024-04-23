//
//  QuestionVisualizerMaker.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/21/24.
//

import Foundation
import SwiftUI
import Combine

class QuestionVisualizerMaker {
    static func createVisualizers(from questions: [Question]) -> [QuestionVisualizer] {
        return questions.map { question in
            // Ensure there are exactly 4 options, otherwise, fill missing options with empty strings
            let options = question.options + Array(repeating: "", count: max(0, 4 - question.options.count))
            
            return QuestionVisualizer(
                questionContent: question.questionContent,
                optionA: options[0],
                optionB: options[1],
                optionC: options[2],
                optionD: options[3]
            )
        }
    }
}


//struct QuestionTranscriptionView: View {
//    @Binding var startTyping: Bool
//    let question: Question
//    @State var displayedText: String = ""
//
//    var body: some View {
//        Text(displayedText)
//            .font(.title2)
//            .frame(maxWidth: .infinity, alignment: .center)
//            .kerning(0.5)
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.typeOutText(text: question.questionContent)
//                }
//            }
//    }
//
//    private func typeOutText(text: String, currentIndex: Int = 0) {
//        guard currentIndex < text.count, startTyping else { return }
//        let index = text.index(text.startIndex, offsetBy: currentIndex)
//        let nextIndex = text.index(after: index)
//        displayedText = String(text[..<nextIndex])
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//            self.typeOutText(text: text, currentIndex: currentIndex + 1)
//        }
//    }
//}

//class QuestionTranscriptionViewModel: ObservableObject {
//    @Published var displayedQuestionText: String = ""
//    var startTyping: Bool = false
//    var question: Question
//
//    init(question: Question) {
//        self.question = question
//    }
//
//    func typeOutText(text: String, currentIndex: Int = 0) {
//        guard currentIndex < text.count, startTyping else { return }
//        let index = text.index(text.startIndex, offsetBy: currentIndex)
//        let nextIndex = text.index(after: index)
//        DispatchQueue.main.async {
//            self.displayedQuestionText = String(text[..<nextIndex])
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//            self.typeOutText(text: text, currentIndex: currentIndex + 1)
//        }
//    }
//
//    func startTypingText() {
//        startTyping = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.typeOutText(text: self.question.questionContent)
//        }
//    }
//}


class QuestionTranscriber: ObservableObject {
    @Published var displayedText: String = ""
    var question: String
    
    // A Combine publisher to provide updates for displayedText
    var displayedTextPublisher: Published<String>.Publisher { $displayedText }

    init(question: String) {
        self.question = question
    }

    func startTypingText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.typeOutText(text: self.question)
        }
    }

    private func typeOutText(text: String, currentIndex: Int = 0) {
        guard currentIndex < text.count else { return }
        let index = text.index(text.startIndex, offsetBy: currentIndex)
        _ = text.index(after: index)
        DispatchQueue.main.async {
            withAnimation {
                self.displayedText += String(text[index])
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.typeOutText(text: text, currentIndex: currentIndex + 1)
        }
    }
}



//struct QuestionScriptView: View {
//    var question: Question
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(question.questionContent)
//            ForEach(question.options.indices, id: \.self) { index in
//                // Convert index to a corresponding letter
//                let letter = indexToLetter(index)
//                Text("\(letter): \(question.options[index])")
//            }
//        }
//    }
//    
//    /// Converts an integer index to a corresponding letter (A, B, C, etc.)
//    private func indexToLetter(_ index: Int) -> String {
//        // ASCII value for 'A' is 65
//        let asciiValue = 65 + index
//        if let scalar = UnicodeScalar(asciiValue) {
//            return String(Character(scalar))
//        }
//        return "?"
//    }
//}
//
//
//class QuestionVisualizerMakerV2 {
//    static func createVisualizer(for question: Question, startTyping: Binding<Bool>) -> QuestionScriptViewer {
//        // Create the views for the current question
//        let transcriptionView = QuestionTranscriptionView(startTyping: startTyping, question: question)
//        let scriptView = QuestionScriptView(question: question)
//
//        return QuestionScriptViewer(
//            imageUrl: "yourImageUrl",  // Adjust as necessary to pull from an actual data source
//            name: "yourQuizName",      // Adjust as necessary
//            shortTitle: "yourShortTitle",  // Adjust as necessary
//            transcriptionView: transcriptionView,
//            scriptView: scriptView
//        )
//    }
//}


