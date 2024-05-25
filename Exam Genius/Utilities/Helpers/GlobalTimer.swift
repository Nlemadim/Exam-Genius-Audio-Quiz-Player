//
//  GlobalTimer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/24/24.
//

import SwiftUI
import Combine

class GlobalTimer: ObservableObject {
    // Published properties for countdowns
    @Published var startUpCountDown: Int = 0
    @Published var responseCountDown: Int = 0
    
    // Timer cancellable properties
    private var startUpTimer: AnyCancellable?
    private var responseTimer: AnyCancellable?
    
    @Published var interactionState: InteractionState = .idle {
        didSet {
            handleStateChange()
        }
    }
    
    // Initializer
    init() {
        // Set initial countdown values from UserDefaults
        let responseTime = UserDefaultsManager.responseTime()
        self.startUpCountDown = responseTime
        self.responseCountDown = responseTime
        
    }
    
    // Handle state changes
    private func handleStateChange() {
        switch interactionState {
            
        case .idle:
            cancelTimers()
            
        case .quizStartCountDown:
            startStartUpCountDown()
            
        case .countingDownResponseTimer:
            startResponseCountDown()
            
        default:
            break
        }
    }
    
    // Start the start up countdown timer
    private func startStartUpCountDown() {
        cancelTimers()
        startUpCountDown = getResponseTime()
        startUpTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateStartUpCountDown()
            }
    }
    
    // Update start up countdown
    private func updateStartUpCountDown() {
        if startUpCountDown > 0 {
            startUpCountDown -= 1
        } else {
            interactionState = .idle
        }
    }
    
    // Start the response countdown timer
    private func startResponseCountDown() {
        cancelTimers()
        responseCountDown = getResponseTime()
        responseTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateResponseCountDown()
            }
    }
    
    // Update response countdown
    private func updateResponseCountDown() {
        if responseCountDown > 0 {
            responseCountDown -= 1
        } else {
            interactionState = .idle
        }
    }
    
    // Cancel any active timers
    private func cancelTimers() {
        startUpTimer?.cancel()
        responseTimer?.cancel()
    }
    
    // Get response time from UserDefaults
    private func getResponseTime() -> Int {
        return UserDefaults.standard.integer(forKey: "responseTimeKey")
    }
}

