//
//  ResponseModalPresenter.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct ResponseModalPresenter: View {
    @Binding var interactionState: InteractionState
    @Binding var selectedOption: String?
    var mainColor: Color
    var subColor: Color
    
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
    }
}


#Preview {
    ResponseModalPresenter(interactionState: .constant(.awaitingResponse), selectedOption: .constant(""), mainColor: .teal, subColor: .themePurple)
}


