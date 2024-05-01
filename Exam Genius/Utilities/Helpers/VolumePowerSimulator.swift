//
//  VolumePowerSimulator.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/1/24.
//

import Foundation
import SwiftUI

@Observable final class VolumePowerSimulator {
    
    private var timer: Timer?
    private let randomPower = [0, 1.2, 1.7, 3, 2, 1.6, 1.8, 2.7, 2.0, 3.5, 1.4]
    
    var currentPower: Double = 0.0  // Published property to observe changes in the view
    
    func startPlayingPowerSimulator(interactionState: InteractionState) {
        stopPlayingPowerSimulator()  // Ensure to stop any existing timer before starting a new one
        
        guard interactionState == .isNowPlaying || interactionState == .playingFeedbackMessage else {
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let randomValue = self.randomPower.randomElement() {
                DispatchQueue.main.async {
                    self.currentPower = randomValue  // Update the observed property
                }
            }
        }
    }
    
    func stopPlayingPowerSimulator() {
        timer?.invalidate()
        timer = nil
    }
}
