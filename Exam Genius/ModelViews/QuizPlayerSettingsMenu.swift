//
//  QuizPlayerSettingsMenu.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct QuizPlayerSettingsMenu: View {
    @State private var quizMode: String = UserDefaultsManager.quizMode()
    @State private var selectedVoice: String = UserDefaultsManager.selectedVoice()
    @State private var numberOfQuestions: Int = UserDefaultsManager.numberOfTestQuestions()
    @State private var isMicrophoneOn: Bool = UserDefaultsManager.isHandfreeEnabled()
    
    var body: some View {
        Menu {
            VStack {
                Text("Quiz Settings")
                    .font(.headline)
                QuizModeToggle(label: "Timed Quiz", imageName: "clock", selectedMode: $quizMode, mode: "Timed Quiz")
                QuizModeToggle(label: "Study Mode", imageName: "book", selectedMode: $quizMode, mode: "Study Mode")
                QuizModeToggle(label: "Casual Quiz", imageName: "gamecontroller", selectedMode: $quizMode, mode: "Casual Quiz")
            }
            
            VStack {
                Text("Voice Selection")
                    .font(.headline)
                VoiceSelectionToggle(label: "Holly", imageName: "person.fill", selectedVoice: $selectedVoice, voice: "Holly")
                VoiceSelectionToggle(label: "Shade", imageName: "person.fill", selectedVoice: $selectedVoice, voice: "Shade")
                VoiceSelectionToggle(label: "Finn", imageName: "person.fill", selectedVoice: $selectedVoice, voice: "Finn")
                VoiceSelectionToggle(label: "Randomize", imageName: "shuffle", selectedVoice: $selectedVoice, voice: "Randomize")
            }
            
            NumberOfQuestionsStepper(numberOfQuestions: $numberOfQuestions)
            
            HandsfreeToggle(isMicrophoneOn: $isMicrophoneOn)
            
        } label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundStyle(.white)
                .padding(.horizontal, 20.0)
        }
    }
}


#Preview {
    QuizPlayerSettingsMenu()
}
