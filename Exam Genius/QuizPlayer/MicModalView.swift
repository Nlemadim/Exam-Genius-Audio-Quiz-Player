//
//  MicModalView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/23/24.
//

import SwiftUI

struct MicModalView: View {
    @Binding var interactionState: InteractionState
    var mainColor: Color
    var subColor: Color
    
    var body: some View {
        VStack(alignment: .center) {
    
                HStack {

                    MicButtonWithProgressRing(showProgressRing: self.interactionState == .isListening ? true : false)
                    .padding()
                }
                .padding(20)
                .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
    }
}

struct ConfirmationModalView: View {
    @Binding var interactionState: InteractionState
    var mainColor: Color
    var subColor: Color
    var isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .center) {
    
            Image(systemName:isCorrect ?  "hand.thumbsup.fill" : "hand.thumbsdown.fill" )
                .resizable()
                .foregroundStyle(subColor)
                .frame(width: 80, height: 80)
                .padding()
            
            Text(isCorrect ? "Thats Correct!" : "Nope!")
                .font(.largeTitle)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
    }
}

#Preview {
    @State var interactionState: InteractionState = .idle
    return ConfirmationModalView(interactionState: $interactionState, mainColor: .clear, subColor: .themePurple, isCorrect: true)
        .preferredColorScheme(.dark)
}

#Preview {
    @State var interactionState: InteractionState = .idle
    return MicModalView(interactionState: $interactionState, mainColor: .themePurpleLight, subColor: .themePurple)
        .preferredColorScheme(.dark)
}
