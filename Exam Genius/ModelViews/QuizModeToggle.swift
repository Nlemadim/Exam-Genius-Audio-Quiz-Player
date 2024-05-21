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
    @State private var isMicrophoneOn: Bool = UserDefaultsManager.isHandfreeEnabled()

    var body: some View {
        Menu {
            Picker("Quiz Settings", selection: $quizMode) {
                HStack {
                    Image(systemName: "clock.fill")
                    Text("Timed Quiz")
                    if quizMode == "Timed Quiz" {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag("Timed Quiz")
                
                HStack {
                    Image(systemName: "book.fill")
                    Text("Study Mode")
                    if quizMode == "Study Mode" {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag("Study Mode")
                
                HStack {
                    Image(systemName: "gamecontroller.fill")
                    Text("Casual Quiz")
                    if quizMode == "Casual Quiz" {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag("Casual Quiz")
                
                Stepper(value: $numberOfQuestions, in: 10...50, step: 5) {
                    Text("\(numberOfQuestions) Questions")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Image(systemName: "mic.fill")
                    Text("Microphone - On")
                    if isMicrophoneOn {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag(true)
                
                HStack {
                    Image(systemName: "mic.slash.fill")
                    Text("Off")
                    if !isMicrophoneOn {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag(false)
            }
            .pickerStyle(.menu)
            .onChange(of: quizMode) {_, newValue in
               // UserDefaultsManager.setQuizMode(newValue)
            }
            .onChange(of: selectedVoice) {_, newValue in
                //UserDefaultsManager.setSelectedVoice(newValue)
            }
            .onChange(of: numberOfQuestions) {_, newValue in
                //UserDefaultsManager.setNumberOfQuestions(newValue)
            }
//            Text("Quiz Settings")
//                .font(.title3)
//                .fontWeight(.semibold)
            
          
            
//            VStack {
//                // Quiz Settings Section
//                Text("Quiz Settings")
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                
//                HStack {
//                    Image(systemName: "clock.fill")
//                    Text("Timed Quiz")
//                    if quizMode == "Timed Quiz" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Timed Quiz")
//                
//                HStack {
//                    Image(systemName: "book.fill")
//                    Text("Study Mode")
//                    if quizMode == "Study Mode" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Study Mode")
//                
//                HStack {
//                    Image(systemName: "gamecontroller.fill")
//                    Text("Casual Quiz")
//                    if quizMode == "Casual Quiz" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Casual Quiz")
//            }
//            .onChange(of: quizMode) {_, newValue in
//               // UserDefaultsManager.setQuizMode(newValue)
//            }

//            Picker("Quiz Settings", selection: $quizMode) {
//                HStack {
//                    Image(systemName: "clock.fill")
//                    Text("Timed Quiz")
//                    if quizMode == "Timed Quiz" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Timed Quiz")
//                
//                HStack {
//                    Image(systemName: "book.fill")
//                    Text("Study Mode")
//                    if quizMode == "Study Mode" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Study Mode")
//                
//                HStack {
//                    Image(systemName: "gamecontroller.fill")
//                    Text("Casual Quiz")
//                    if quizMode == "Casual Quiz" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Casual Quiz")
//            }
//            .pickerStyle(.menu)
//            .onChange(of: quizMode) {_, newValue in
//               // UserDefaultsManager.setQuizMode(newValue)
//            }

//            VStack {
//                // Voice Selection Section
//                Text("Voice Selection")
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                
//                HStack {
//                    Image(systemName: "person.fill")
//                    Text("Holly")
//                    if selectedVoice == "Holly" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Holly")
//                
//                HStack {
//                    Image(systemName: "person.fill")
//                    Text("Shade")
//                    if selectedVoice == "Shade" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Shade")
//                
//                HStack {
//                    Image(systemName: "person.fill")
//                    Text("Finn")
//                    if selectedVoice == "Finn" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Finn")
//                
//                HStack {
//                    Image(systemName: "shuffle")
//                    Text("Randomize")
//                    if selectedVoice == "Randomize" {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag("Randomize")
//            }
//            .onChange(of: selectedVoice) {_, newValue in
//                //UserDefaultsManager.setSelectedVoice(newValue)
//            }

            
            Picker("Voice Selection", selection: $selectedVoice) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Holly")
                    if selectedVoice == "Holly" {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag("Holly")
                
                HStack {
                    Image(systemName: "person.fill")
                    Text("Shade")
                    if selectedVoice == "Shade" {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag("Shade")
                
                HStack {
                    Image(systemName: "person.fill")
                    Text("Finn")
                    if selectedVoice == "Finn" {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag("Finn")
                
                HStack {
                    Image(systemName: "shuffle")
                    Text("Randomize")
                    if selectedVoice == "Randomize" {
                        Spacer()
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .tag("Randomize")
            }
            .pickerStyle(.menu)
            .onChange(of: selectedVoice) {_, newValue in
                //UserDefaultsManager.setSelectedVoice(newValue)
            }

            // Number of Questions Section
//            VStack {
//                
//                Stepper(value: $numberOfQuestions, in: 10...50, step: 5) {
//                    Text("\(numberOfQuestions) Questions")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                }
//                .onChange(of: numberOfQuestions) {_, newValue in
//                    //UserDefaultsManager.setNumberOfQuestions(newValue)
//                }
//
//            }
//            Picker("Number of Questions", selection: $numberOfQuestions) {
//                HStack {
//                    Image(systemName: "number")
//                    Text("10")
//                    if numberOfQuestions == 10 {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(10)
//                
//                HStack {
//                    Image(systemName: "number")
//                    Text("15")
//                    if numberOfQuestions == 15 {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(15)
//                
//                HStack {
//                    Image(systemName: "number")
//                    Text("25")
//                    if numberOfQuestions == 25 {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(25)
//                
//                HStack {
//                    Image(systemName: "number")
//                    Text("25 - 50")
//                    if numberOfQuestions == 35 { // Assuming 35 as a placeholder for range
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(35)
//            }
//            .pickerStyle(.menu)
//            .onChange(of: numberOfQuestions) { newValue in
//                //UserDefaultsManager.setNumberOfQuestions(newValue)
//            }

            
//            VStack{
//                // Handsfree Section
//                Text("Handsfree")
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                
//                HStack {
//                    Image(systemName: "mic.fill")
//                    Text("Microphone - On")
//                    if isMicrophoneOn {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(true)
//                
//                HStack {
//                    Image(systemName: "mic.slash.fill")
//                    Text("Off")
//                    if !isMicrophoneOn {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(false)
//            }
//            .onChange(of: isMicrophoneOn) {_, newValue in
//                //UserDefaultsManager.setMicrophoneOn(newValue)
//            }
            
//            Picker("Handsfree", selection: $isMicrophoneOn) {
//                HStack {
//                    Image(systemName: "mic.fill")
//                    Text("Microphone - On")
//                    if isMicrophoneOn {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(true)
//                
//                HStack {
//                    Image(systemName: "mic.slash.fill")
//                    Text("Off")
//                    if !isMicrophoneOn {
//                        Spacer()
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .tag(false)
//            }
//            .pickerStyle(.menu)
//            .onChange(of: isMicrophoneOn) { newValue in
//                //UserDefaultsManager.setMicrophoneOn(newValue)
//            }
        } label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundStyle(.white)
                .padding(.horizontal, 20.0)
        }
    }
}
