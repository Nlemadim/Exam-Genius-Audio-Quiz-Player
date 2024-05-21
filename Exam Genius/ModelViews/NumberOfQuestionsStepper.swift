//
//  NumberOfQuestionsStepper.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct NumberOfQuestionsStepper: View {
    @Binding var numberOfQuestions: Int

    var body: some View {
        VStack {
            Text("Number of Questions")
                .font(.headline)
            Stepper(value: $numberOfQuestions, in: 10...50, step: 5) {
                Text("\(numberOfQuestions) Questions")
            }
            .onChange(of: numberOfQuestions) {_, newValue in
                //UserDefaultsManager.setNumberOfQuestions(newValue)
            }
        }
    }
}


#Preview {
    NumberOfQuestionsStepper(numberOfQuestions: .constant(10))
}
