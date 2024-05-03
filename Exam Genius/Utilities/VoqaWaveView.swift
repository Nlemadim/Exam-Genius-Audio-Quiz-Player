//
//  VoqaWaveView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/1/24.
//

import Foundation
import SwiftUI

struct VoqaWaveView: View {
    
    var voqaWave: VoqaWave!
    
    var _colors: [Color]!
    var _supportLineColor: Color!
    var _power: Double!
    
    public init() {
        
        self._power = 0.0
    
        // Initialize default Siri waveform
        
        self._colors = [
           // Red
           Color(red: (173 / 255), green: (57 / 255), blue: (76 / 255)),
           // Green
           Color(red: (48 / 255), green: (220 / 255), blue: (155 / 255)),
           // Blue
           Color(red: (25 / 255), green: (122 / 255), blue: (255 / 255))
        ]
        
        self._supportLineColor = Color(.white)
        
        // Initialize model
        self.voqaWave = VoqaWave(numWaves: self._colors.count, power: self._power)
        
    }
    
    func colors(colors: [Color]) -> Self {
        
        var this = self;
        
        if (colors.count != this._colors.count) {
            this.voqaWave = VoqaWave(numWaves: colors.count, power: this._power)
        }
        
        this._colors = colors
        
        return this
        
    }
    
    public func power(power: Double) -> Self {
        
        var this = self;
        
        this.voqaWave = VoqaWave(numWaves: self._colors.count, power: power)
        
        return this
        
    }
    
    func supportLineColor(color: Color) -> Self {
        
        var this = self;
        
        this._supportLineColor = color
        
        return this
        
    }
    
    public var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                SupportLine(color: self._supportLineColor)
                ForEach(0..<self._colors.count, id: \.self) { i in
                    WaveView(wave: self.voqaWave.waves[i], color: self._colors[i])
//                        .animation(.spring())
                        .animation(.linear(duration: 0.3), value: _power)
//                        .shadow(color: self.colors[i], radius: 2, x: 0, y: 0)
                }
                
            }
            .blendMode(.lighten)
            .drawingGroup()
            
        }
        
    }
    
}

#Preview {
    VoqaWaveView()
        .power(power: 1)
}



#Preview {
    @State var interactionState: InteractionState = .idle
    return VoqaWaveViewV2(colors: [.orange, .purple], supportLineColor: .teal, interactionState: $interactionState)
        .preferredColorScheme(.dark)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                interactionState = .isNowPlaying
            }
        }
}

//struct VoqaWaveViewV2: View {
//    @Binding var interactionState: InteractionState
//    @State private var voqaWave: VoqaWave
//    @State private var timer: Timer?
//    @State private var power: Double = 0.7
//    
//    var colors: [Color]
//    var supportLineColor: Color
//    
//    init(colors: [Color], supportLineColor: Color = .white, interactionState: Binding<InteractionState>) {
//        self._interactionState = interactionState
//        self._voqaWave = State(initialValue: VoqaWave(numWaves: colors.count, power: 0.0))
//        self.colors = colors
//        self.supportLineColor = supportLineColor
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                // Support line at the back
//                SupportLine(color: supportLineColor)
//                
//                // Dynamic wave views for each color
//                ForEach(Array(zip(voqaWave.waves.indices, voqaWave.waves)), id: \.0) { index, wave in
//                    WaveView(wave: wave, color: colors[index % colors.count])
//                        .animation(.linear(duration: 0.3), value: voqaWave.waves[index].power)
//                }
//            }
//            .blendMode(.lighten)
//            .drawingGroup()
//        }
//        .onChange(of: interactionState) {_, newState in
//            updatePowerBasedOnState(newState)
//        }
//        .onAppear {
//            startPowerSimulation()
//        }
//    }
//    
//    private func updatePowerBasedOnState(_ state: InteractionState) {
//        guard state == .isNowPlaying || state == .playingFeedbackMessage || state == .nowPlayingCorrection else { return }
//        
//        // Randomize power between 0.0 and 1.0
//        withAnimation {
//            voqaWave = VoqaWave(numWaves: colors.count, power: Double.random(in: 0.0...1.0))
//        }
//        
//        // Keep updating at random intervals to simulate continuous changes
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.5...2.0), repeats: false) { _ in
//            self.interactionState = [.isNowPlaying, .playingFeedbackMessage, .nowPlayingCorrection].randomElement() ?? .idle
//        }
//    }
//    
//    private func startPowerSimulation() {
//        // Initiate simulation
//        interactionState = .isNowPlaying
//    }
//    
//    // Clean up the timer when the view disappears
//    func stopPowerSimulation() {
//        timer?.invalidate()
//        timer = nil
//    }
//    
//    // Modifiers for external adjustments
//    func colors(_ newColors: [Color]) -> VoqaWaveViewV2 {
//        var newView = self
//        newView.colors = newColors
//        return newView
//    }
//    
//    func supportLineColor(_ newColor: Color) -> VoqaWaveViewV2 {
//        var newView = self
//        newView.supportLineColor = newColor
//        return newView
//    }
//}



import SwiftUI
import Combine

struct VoqaWaveViewV2: View {
    @Binding var interactionState: InteractionState
    @State private var voqaWave: VoqaWave
    @State private var power: Double = 0.0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.3, on: .main, in: .common)
    @State private var timerCancellable: Cancellable?

    var colors: [Color]
    var supportLineColor: Color
    
    init(colors: [Color], supportLineColor: Color = .white, interactionState: Binding<InteractionState>) {
        self._interactionState = interactionState
        self._voqaWave = State(initialValue: VoqaWave(numWaves: colors.count, power: 0.0))
        self.colors = colors
        self.supportLineColor = supportLineColor
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Support line at the back
                SupportLine(color: supportLineColor)
                
                // Dynamic wave views for each color
                ForEach(Array(zip(voqaWave.waves.indices, voqaWave.waves)), id: \.0) { index, wave in
                    WaveView(wave: wave, color: colors[index % colors.count])
                        .animation(.linear(duration: 0.2), value: power)
                }
            }
            .blendMode(.lighten)
            .drawingGroup()
        }
        .onChange(of: interactionState) {_, newState in
            updatePowerBasedOnState(newState)
            voqaWave = VoqaWave(numWaves: colors.count, power: power)
        }
        .onAppear {
            voqaWave = VoqaWave(numWaves: colors.count, power: power)
            updatePowerBasedOnState(interactionState)
        }
        .onReceive(timer) { _ in
            updatePowerRandomly()
            //voqaWave = VoqaWave(numWaves: colors.count, power: power)
        }
    }
    
    private func updatePowerBasedOnState(_ state: InteractionState) {
        switch state {
        case .isNowPlaying, .playingFeedbackMessage, .nowPlayingCorrection:
            // Start or continue the timer
            timerCancellable = timer.connect()
        default:
            // Stop the timer when not in active states
            timerCancellable?.cancel()
        }
    }
    
    private func updatePowerRandomly() {
        withAnimation {
            power = Double.random(in: 0.0...2.0)
            voqaWave = VoqaWave(numWaves: colors.count, power: power)
        }
    }
}

struct VoqaWaveViewV3: View {
    @Binding var power: Double  // Bind to external power source
    var colors: [Color]
    var supportLineColor: Color
    
    init(power: Binding<Double>, colors: [Color], supportLineColor: Color = .white) {
        self._power = power
        self.colors = colors
        self.supportLineColor = supportLineColor
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Support line at the back
                SupportLine(color: supportLineColor)
                
                // Dynamic wave views for each color
                ForEach(0..<colors.count, id: \.self) { index in
                    WaveView(wave: VoqaWave.Wave(power: power, curves: [], useCurves: 0), color: colors[index % colors.count])
                        .animation(.linear(duration: 0.2), value: power)
                }
            }
            .blendMode(.lighten)
            .drawingGroup()
        }
    }
}
