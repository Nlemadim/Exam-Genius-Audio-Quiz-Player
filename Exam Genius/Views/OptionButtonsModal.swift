//
//  OptionButtonsModal.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/16/24.
//

import SwiftUI

struct OptionButtonsModal: View {
    var mainColor: Color
    var subColor: Color
    var backgroundColor: Color
    var body: some View {
        VStack {
            HStack {
                ButtonView(buttonText: "A", mainColor: mainColor, backgroundColor: backgroundColor)
                ButtonView(buttonText: "B", mainColor: mainColor, backgroundColor: backgroundColor)
                ButtonView(buttonText: "C", mainColor: mainColor, backgroundColor: backgroundColor)
                ButtonView(buttonText: "D", mainColor: mainColor, backgroundColor: backgroundColor)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    OptionButtonsModal(mainColor: .pink, subColor: .black, backgroundColor: .pink)
}

struct ButtonView: View {
    var buttonText: String
    var mainColor: Color
    var backgroundColor: Color

    var body: some View {
        Button(action: {}) {
            Text(buttonText)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(mainColor.dynamicTextColor())
                .frame(width: 60, height: 60)
                .background(
                    ZStack {
                        Color.white.opacity(0.2)
                       backgroundColor.opacity(0.3)
                        
                        Circle()
                            .foregroundStyle(mainColor.opacity(0.5))
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        Circle()
                            .foregroundStyle( .white.opacity(0.3))
                            .padding(2)
                            .blur(radius: 2)
                    }
                )
                .clipShape(Circle())
                .shadow(color:  backgroundColor.opacity(0.3), radius: 20)
                .shadow(color: mainColor.opacity(0.3), radius: 20)
        }
        .padding(.horizontal, 12)
    }
}
