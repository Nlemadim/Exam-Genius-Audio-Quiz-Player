//
//  QuizModeToggle.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct QuizModeToggle: View {
    var label: String
    var imageName: String
    @Binding var selectedMode: String
    var mode: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(label)
            Spacer()
//            Toggle("", isOn: Binding<Bool>(
//                get: { self.selectedMode == self.mode },
//                set: { newValue in
//                    if newValue {
//                        self.selectedMode = self.mode
//                        //UserDefaultsManager.setQuizMode(self.mode)
//                    }
//                }
//            ))
//            .labelsHidden()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.selectedMode = self.mode
            //UserDefaultsManager.setQuizMode(self.mode)
        }
    }
}

#Preview {
    QuizModeToggle(label: "Timed Quiz", imageName: "clock.fill", selectedMode: .constant("Timed Quiz"), mode: "Timed Quiz")
}


import SwiftUI

struct SettingsMenuView: View {
    @State private var quizMode: String = UserDefaultsManager.quizMode()
    @State private var selectedVoice: String = UserDefaultsManager.selectedVoice()
    @State private var numberOfQuestions: Int = UserDefaultsManager.numberOfTestQuestions()
    @State private var enableHandsfree: Bool = UserDefaultsManager.isHandfreeEnabled()
    @State private var continousPlayOn: Bool = UserDefaultsManager.isContinousPlayEnabled()

    var body: some View {
        Menu {
            Picker("Quiz Settings", selection: $quizMode) {
                HStack {
                    Image(systemName: "clock.fill")
                    Text("Standard Quiz")
                }
                .tag("Standard")
                
                HStack {
                    Image(systemName: "book.fill")
                    Text("Q&A")
                }
                .tag("Q&A")
            }
            
            Picker("Question Response", selection: $enableHandsfree) {
                HStack {
                    Image(systemName: "mic.fill")
                    Text("Mic")
                }
                .tag(true)
                
                HStack {
                    Image(systemName: "rectangle.and.hand.point.up.left.fill")
                    Text("Option Buttons")
                }
                .tag(false)
            }
            
            Stepper(value: $numberOfQuestions, in: 10...50, step: 5) {
                Text("\(numberOfQuestions) Questions")
            }
            
//            Picker("Number of Questions", selection: $numberOfQuestions) {
//                Text("15")
//                    .tag("15")
//                Text("30")
//                    .tag("30")
//                Text("50")
//                    .tag("50")
//            }
            
            Picker("Continous Play", selection: $continousPlayOn) {
                HStack {
                    Image(systemName: "repeat")
                    Text("Continous Play")
                }
                .tag(true)
            }
            
        } label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundStyle(.white)
                .padding(.horizontal, 20.0)
        }
        .onChange(of: quizMode) {_, newValue in
            UserDefaultsManager.setQuizMode(mode: newValue)
        }
        .onChange(of: numberOfQuestions) {_, newValue in
            UserDefaultsManager.setDefaultNumberOfTestQuestions(newValue)
        }
        .onChange(of: continousPlayOn) {_, newValue in
            UserDefaultsManager.enableContinousPlay(newValue)
        }
        .onChange(of: enableHandsfree) {_, newValue in
            UserDefaultsManager.enableHandsfree(newValue)
        }
    }
}
