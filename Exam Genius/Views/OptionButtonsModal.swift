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
        VStack(alignment: .center) {
            
            HStack {
                CircularOptionButton(imageLabel: "sun.horizon", confirmationImageLabel: "moon.fill", buttonColor: backgroundColor.opacity(0.3), buttonAccentColor: mainColor.opacity(0.3))
                //ButtonView(buttonText: "A", mainColor: mainColor, backgroundColor: backgroundColor)
                ButtonView(buttonText: "B", mainColor: mainColor, backgroundColor: backgroundColor)
                ButtonView(buttonText: "C", mainColor: mainColor, backgroundColor: backgroundColor)
                ButtonView(buttonText: "D", mainColor: mainColor, backgroundColor: backgroundColor)
            }
            .offset(y: -250)
            
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
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [backgroundColor.opacity(0.3), Color.white.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundStyle(.white.opacity(0.3))
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

struct CircularOptionButton: View {
    @GestureState var tap = false
    @State var press: Bool = false
    var imageLabel: String
    var confirmationImageLabel: String
    var buttonColor: Color
    var buttonAccentColor: Color
    
    var body: some View {
        ZStack {
            Image(systemName: imageLabel)
                .font(.system(size: 44, weight: .light))
                .offset(x: press ? -90 : 0, y: press ? -90 : 0)
                .rotation3DEffect(Angle(degrees: press ? 0 : 20), axis: (x: 10, y: -10, z: 0))
                .foregroundStyle(buttonColor.dynamicTextColor())
            
            
            Image(systemName: confirmationImageLabel)
                .font(.system(size: 44, weight: .light))
                .offset(x: press ? -90 : 0, y: press ? -90 : 0)
                .rotation3DEffect(Angle(degrees: press ? 0 : 20), axis: (x: 10, y: -10, z: 0))
        }
        .frame(width: 100, height: 100)
        .background(
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(press ? buttonColor : buttonAccentColor), Color(press ? buttonColor : buttonAccentColor)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                Circle()
                    .stroke(Color.clear, lineWidth: 10)
                    .shadow(color: Color(press ? buttonColor : buttonAccentColor), radius: 3, x: -5, y: -5)
                
                Circle()
                    .stroke(Color.clear, lineWidth: 10)
                    .shadow(color: Color(press ? buttonColor : buttonAccentColor), radius: 3, x: 3, y: 3)
            }
                .clipShape(Circle())
                .shadow(color: Color(press ? buttonAccentColor : buttonColor), radius: 20, x: -20, y: -20)
                .shadow(color: Color(press ? buttonColor : buttonAccentColor), radius: 20, x: 20, y: 20)
                .scaleEffect(tap ? 1.2 : 1)
                .gesture(
                    LongPressGesture().updating($tap) { currentState, gestureState, transcation in
                        gestureState = currentState
                        
                    }.onEnded { value in
                        self.press.toggle()
                    }
                )
        )
    }
}
