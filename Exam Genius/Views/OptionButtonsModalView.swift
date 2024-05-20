//
//  OptionButtonsModalView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct OptionButtonsModalView: View {
    @State private var selectedOption: String? = nil
    @State private var timerCountdown: Int = 5
    @State private var isTimerActive: Bool = true
    @State private var isSelectionMade: Bool = false
    @State var mainThemeColor: Color = .purple
    @State var selectionThemeColor: Color = .purple
    
    var body: some View {
        VStack {
            
            HStack(spacing: 20) {
                MultiChoiceButton(label: "A", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown, dynamicForegroundColor: mainThemeColor, dynamicSelectedColor: selectionThemeColor)
                MultiChoiceButton(label: "B", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown, dynamicForegroundColor: mainThemeColor, dynamicSelectedColor: selectionThemeColor)
                MultiChoiceButton(label: "C", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown, dynamicForegroundColor: mainThemeColor, dynamicSelectedColor: selectionThemeColor)
                MultiChoiceButton(label: "D", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown, dynamicForegroundColor: mainThemeColor, dynamicSelectedColor: selectionThemeColor)
            }
            .padding()
            .padding(.horizontal)
            
            VStack(alignment: .center) {
                ZStack {
                    ProgressTextView(timerCountdown: $timerCountdown, themeColor: mainThemeColor)
                        .opacity(selectedOption == nil ? 1 : 0)
                    
                    if !(selectedOption?.isEmptyOrWhiteSpace ?? false) {
                        withAnimation {
                            Text("Selected Option: \(selectedOption ?? "")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(selectedOption == nil ? 0 : 1)
                        }
                        
                    }
                }
                    
            }
        }
        .onAppear {
            startCountdown()
        }
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

#Preview {
    OptionButtonsModalView()
        .preferredColorScheme(.dark)
}


struct MultiChoiceButton: View {
    let label: String
    @Binding var selectedOption: String?
    @Binding var isSelectionMade: Bool
    @Binding var isTimerActive: Bool
    @Binding var timerCountdown: Int
    
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false
    @State private var isPressed: Bool = false
    @State var dynamicForegroundColor = Color.themePurple
    @State var dynamicSelectedColor: Color = .green
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isTimerActive ? .themePurple :  (isSelectionMade && selectedOption == label ? .green : .gray))
                .frame(width: 60, height: 60)
            
            if showProgressRing {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 5)
                    .frame(width: 55, height: 55)
                
                Circle()
                    .trim(from: 0, to: fillAmount)
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 55, height: 55)
                    .rotationEffect(.degrees(-270))
                    .animation(.linear(duration: 1), value: fillAmount)
            }
            
            Text(label)
                .font(.title3)
                .fontWeight(.black)
                .foregroundColor(.white)
        }
        .padding(10)
        .gesture(
            LongPressGesture(minimumDuration: 1)
                .onChanged { _ in
                    self.startFilling()
                }
                .onEnded { _ in
                    self.selectOption()
                }
        )
        .disabled(!isTimerActive || isSelectionMade)
    }
    
    private func startFilling() {
        if !isTimerActive || isSelectionMade { return }
        
        fillAmount = 0.0
        showProgressRing = true
        
        withAnimation(.linear(duration: 1)) {
            fillAmount = 1.0
        }
    }
    
    private func selectOption() {
        if fillAmount >= 1.0 {
            selectedOption = label
            isSelectionMade = true
            isTimerActive = false
            timerCountdown = 0 // Invalidate the timer immediately
        }
        resetButton()
    }
    
    private func resetButton() {
        showProgressRing = false
        fillAmount = 0.0
    }
}



struct ProgressBarView: View {
    @Binding var timerCountdown: Int
    @State private var isTimerInvalidated: Bool = false
    @State private var dynamicColor: Color = .blue
    @State private var animationDuration: Double = 3

    var body: some View {
        ZStack {
            // Background Bar (Empty)
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(3.0)
                    .frame(height: 1)
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(3.0)
                    .frame(height: 1)
            }
            .frame(height: 10)
            
            // Foreground Bar (Fill)
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Rectangle()
                    .fill(.teal)
                    .frame(width: CGFloat(190 * timerCountdown / 5))
                    .cornerRadius(3.0)
                    .frame(height: 1)
                
                Rectangle()
                    .fill(.teal)
                    .frame(width: CGFloat(190 * timerCountdown / 5))
                    .cornerRadius(3.0)
                    .frame(height: 1)
                Spacer(minLength: 0)
            }
            .animation(.linear(duration: animationDuration), value: timerCountdown)
            .activeGlow(.teal, radius: 2.6)
            .frame(height: 10)
            
            
            // Countdown Circle
            Circle()
                .fill(timerCountdown > 0 ? Color.themePurple : Color.gray  )
                .frame(width: 25, height: 25)
                .overlay(
                    Text("\(timerCountdown)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                )
        }
        .frame(height: 10)
        
        .onAppear {
            // On appear, set the whole bar to the dynamic color
            withAnimation(.linear(duration: animationDuration)) {
                dynamicColor = .teal
            }
        }
        .onChange(of: timerCountdown) { _, newValue in
            if newValue == 0 {
                isTimerInvalidated = false
            }
        }
        .onChange(of: isTimerInvalidated) { _, newValue in
            if newValue {
                timerCountdown = 5
            }
        }
    }

    func invalidateTimer(at time: Int) {
        timerCountdown = time
        isTimerInvalidated = true
        dynamicColor = .green
        animationDuration = 0.5
    }
}

struct ProgressTextView: View {
    @Binding var timerCountdown: Int
    @State private var isTimerInvalidated: Bool = false
    @State private var dynamicColor: Color = .blue
    @State private var animationDuration: Double = 5
    @State var themeColor: Color = .white
    

    var body: some View {
        VStack {
            Text("Tap an hold to select")
                .padding(.horizontal)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            ProgressBarView(timerCountdown: $timerCountdown)
                .font(.subheadline)
                .foregroundStyle(.white)

        }
        .frame(height: 20)
        .foregroundColor(themeColor.dynamicTextColor())
        .onAppear {
            // On appear, set the whole bar to the dynamic color
            withAnimation(.linear(duration: animationDuration)) {
                dynamicColor = .blue
            }
        }
        .onChange(of: timerCountdown) { _, newValue in
            if newValue == 0 {
                isTimerInvalidated = false
            }
        }
        .onChange(of: isTimerInvalidated) { _, newValue in
            if newValue {
                timerCountdown = 5
            }
        }
    }

    func invalidateTimer(at time: Int) {
        timerCountdown = time
        isTimerInvalidated = true
        dynamicColor = .green
        animationDuration = 0.4
    }
}
