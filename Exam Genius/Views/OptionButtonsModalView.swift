//
//  OptionButtonsModalView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI
import UIKit

struct OptionButtonsModalView: View {
    @Binding var selectedOption: String?
    @State private var timerCountdown: Int = 5
    @State private var isTimerActive: Bool = true
    @State private var isSelectionMade: Bool = false
    @State private var progressText: String = "Tap and hold to select"
    var mainThemeColor: Color
    var selectionThemeColor: Color = .themePurple
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                MultiChoiceButton(label: "A", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
                MultiChoiceButton(label: "B", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
                MultiChoiceButton(label: "C", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
                MultiChoiceButton(label: "D", selectedOption: $selectedOption, isSelectionMade: $isSelectionMade, isTimerActive: $isTimerActive, timerCountdown: $timerCountdown)
            }
            .padding()
            .padding(.horizontal)
            .offset(y: -10)
            
            VStack(alignment: .center) {
                Text("Tap to select... \(timerCountdown)")
                     .font(.subheadline)
                     .fontWeight(.semibold)
                     .foregroundStyle(mainThemeColor.dynamicTextColor())
                     .padding(.bottom)
            }
            
            Spacer()
        }
        .onAppear {
            startCountdown()
            print(selectedOption as Any)
        }
        .onChange(of: selectedOption) { _, newSelectedOption in
            displaySelection(newSelectedOption)
        }
    }
    
    private func displaySelection(_ selectedOption: String?) {
        guard selectedOption != nil else { return }
        if let selectedOption, !selectedOption.isEmptyOrWhiteSpace {
            DispatchQueue.main.async {
                self.progressText = selectedOption
                print(selectedOption)
            }
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
                    if !self.isSelectionMade {
                        self.selectedOption = ""
                    }
                }
            }
        }
    }
}


#Preview {
    OptionButtonsModalView(selectedOption: .constant(nil), mainThemeColor: Color.themePurple, selectionThemeColor: Color.themePurple)
        .preferredColorScheme(.dark)
}



struct MultiChoiceButton: View {
    //@GestureState private var isLongPressing: Bool = false
    let label: String
    @Binding var selectedOption: String?
    @Binding var isSelectionMade: Bool
    @Binding var isTimerActive: Bool
    @Binding var timerCountdown: Int
    
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false
    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: {
            self.startFilling()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.selectOption()
            }
        }) {
            ZStack {
                Circle()
                    .fill(isTimerActive ? .themePurple : (isSelectionMade && selectedOption == label ? .teal : .gray))
                    .frame(width: 55, height: 55)
                
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
        }
        .buttonStyle(PlainButtonStyle())
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
            provideHapticFeedback()
            print(selectedOption as Any)
        }
        resetButton()
    }
    
    private func resetButton() {
        showProgressRing = false
        fillAmount = 0.0
    }
    
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
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
            .activeGlow(.teal, radius: 1.5)
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
    var progressText: String
    

    var body: some View {
        VStack {
            ProgressBarView(timerCountdown: $timerCountdown)
                .font(.subheadline)
                .foregroundStyle(.white)
                .padding([.leading, .trailing], 10)
                .padding()
            
            Text(progressText)
                .padding(.horizontal)
                .font(.subheadline)
                .fontWeight(.semibold)

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
