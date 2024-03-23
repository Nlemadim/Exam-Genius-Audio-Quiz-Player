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

                    MicButtonWithProgressRing(showProgressRing: interactionState == .isListening ? true : false)
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

#Preview {
    @State var interactionState: InteractionState = .idle
    return MicModalView(interactionState: $interactionState, mainColor: .themePurpleLight, subColor: .themePurple)
        .preferredColorScheme(.dark)
}
