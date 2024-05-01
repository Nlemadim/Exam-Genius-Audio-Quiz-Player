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


