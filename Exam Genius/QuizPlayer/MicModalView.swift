//
//  MicModalView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/23/24.
//

import SwiftUI

struct MicModalView: View {
    @Binding var interactionState: InteractionState
    @State private var timerCountdown: Int = 5
    @State private var isTimerActive: Bool = true
    var mainColor: Color
    var subColor: Color
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                MicButtonWithProgressRing(showProgressRing: interactionState == .isListening)
                .padding()
            }
            .padding(20)
            .padding(.horizontal)
            
           Text("Listening... \(timerCountdown)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(mainColor.dynamicTextColor())
        
            Spacer()
        }
        .onAppear {
            startCountdown()
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.linear(duration: 1)) {
                if self.timerCountdown > 0 {
                    self.timerCountdown -= 1
                } else {
                    timer.invalidate()
                    self.isTimerActive = false
                }
            }
        }
    }
}


struct ConfirmationModalView: View {
    @Binding var interactionState: InteractionState
    var mainColor: Color
    var subColor: Color
    @State var isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .center) {
    
            Image(systemName: isCorrect ?  "hand.thumbsup.fill" : "hand.thumbsdown.fill" )
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
