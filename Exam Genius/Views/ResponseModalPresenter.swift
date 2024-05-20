//
//  ResponseModalPresenter.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct ResponseModalPresenter: View {
    @Binding var interactionState: InteractionState
    var mainColor: Color
    var subColor: Color
    
    var body: some View {
        VStack {
            Spacer()
            
            switch interactionState {
            case .isListening:
                MicModalView(interactionState: $interactionState, mainColor: mainColor, subColor: subColor)
                
            case .awaitingResponse:
                OptionButtonsModalView(mainThemeColor: mainColor, selectionThemeColor: subColor)
                
            default:
                EmptyView()
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
    }
}

#Preview {
    ResponseModalPresenter(interactionState: .constant(.isListening), mainColor: .teal, subColor: .teal)
}


