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
            }
            
//            switch interactionState {
//            case .isListening:
//                MicModalView(interactionState: $interactionState, mainColor: mainColor, subColor: subColor)
//                
//            case .awaitingResponse:
//                OptionButtonsModalView(selectedOption: $selectedOption, mainThemeColor: mainColor, selectionThemeColor: subColor)
//                
//            default:
//                EmptyView()
//                
//            }
        }
        .frame(maxWidth: .infinity)
        .background(mainColor)
    }
}

//struct ResponseModalPresenter: View {
//    @Binding var interactionState: InteractionState
//    var mainColor: Color
//    var subColor: Color
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            switch interactionState {
//            case .isListening:
//                MicModalView(interactionState: $interactionState, mainColor: mainColor, subColor: subColor)
//                
//            case .awaitingResponse:
//                OptionButtonsModalView(mainThemeColor: mainColor, selectionThemeColor: subColor)
//                
//            default:
//                EmptyView()
//                
//            }
//            
//        }
//        .frame(maxWidth: .infinity)
//        .background(mainColor)
//    }
//}

#Preview {
    ResponseModalPresenter(interactionState: .constant(.awaitingResponse), selectedOption: .constant(""), mainColor: .teal, subColor: .themePurple)
}


