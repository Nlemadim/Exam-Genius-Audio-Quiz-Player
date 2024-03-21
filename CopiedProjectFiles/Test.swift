//
//  Test.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/24/24.
//

import SwiftUI
import SwiftData

struct QuizViewPresenter: View {
    @State private var currentQuestionIndex = 0
    @State private var showingQuizCover = false
    @State private var questions: [QuizQuestion] = [
        QuizQuestion(question: "Question 1", answer: ""),
        QuizQuestion(question: "Question 2", answer: "")]
    
    var body: some View {
        Button("Start Quiz") {
            showingQuizCover = true
        }
        .fullScreenCover(isPresented: $showingQuizCover) {
            QuizFullScreenCoverView(question: $questions[currentQuestionIndex].question, userAnswer: $questions[currentQuestionIndex].answer) {
                // This closure is called when the user taps "Next"
                if currentQuestionIndex < questions.count - 1 {
                    currentQuestionIndex += 1
                } else {
                    // Quiz is finished, do something here, like showing results
                    showingQuizCover = false
                }
            }
        }
    }
}

struct QuizFullScreenCoverView: View {
    @Binding var question: String
    @Binding var userAnswer: String
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Text(question)
            TextField("Your answer", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Next", action: onNext)
        }
        .padding()
    }
}


struct QuizQuestion {
    var question: String
    var answer: String // Simplified for demonstration; in real cases, might be more complex
}




#Preview {
    QuizViewPresenter()
        .preferredColorScheme(.dark)
}












/** message.badge.waveform
 message.badge.waveform.fill
 bubble.right.fill
 bubble.fill
 waveform
 play.desktopcomputer
 desktopcomputer.trianglebadge.exclamationmark
 desktopcomputer
 
 
 
 **/
