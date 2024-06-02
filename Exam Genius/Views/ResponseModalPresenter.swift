//
//  ResponseModalPresenter.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct ResponseModalPresenter: View {
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @EnvironmentObject var user: User
    @StateObject private var generator = ColorGenerator()
    @Binding var interactionState: InteractionState
    @Binding var selectedOption: String?
    
    @State var mainColor: Color
    @State var subColor: Color
    
    var body: some View {
        VStack {
            Spacer()
            if interactionState == .isListening {
                MicModalView(interactionState: $interactionState, mainColor: mainColor, subColor: subColor)
            }
            
            if interactionState == .awaitingResponse {
                OptionButtonsModalView(selectedOption: $selectedOption, mainThemeColor: mainColor, selectionThemeColor: subColor)
                //OptionButtonsModalViewV2(selectedOption: $selectedOption, interactionState: $interactionState, mainThemeColor: mainColor, selectionThemeColor: subColor)
            }
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
        .onAppear {
            updateViewColors()
        }
    }
    
    func updateViewColors() {
        generator.updateAllColors(fromImageNamed: user.downloadedQuiz?.quizImage ?? "Logo")
        self.mainColor = generator.dominantBackgroundColor
        self.subColor = generator.dominantLightToneColor 
    }
}


#Preview {
    ResponseModalPresenter(interactionState: .constant(.awaitingResponse), selectedOption: .constant(""), mainColor: .teal, subColor: .themePurple)
}


