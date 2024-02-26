//
//  Misc.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/23/24.
//

import Foundation
import SwiftUI
import Speech

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

enum WordProcessor: String {
    case A, B, C, D

    static func processWords(from transcript: String) -> String {
        let lowercasedTranscript = transcript.lowercased()

        switch lowercasedTranscript {
        case "a", "eh", "ay", "hey", "ea", "hay", "aye":
            return WordProcessor.A.rawValue
        case "b", "be", "bee", "beat", "bei", "bead", "bay", "bye", "buh":
            return WordProcessor.B.rawValue
        case "c", "see", "sea", "si", "cee", "seed":
            return WordProcessor.C.rawValue
        case "d", "dee", "the", "di", "dey", "they":
            return WordProcessor.D.rawValue
        default:
            return "" // or return a default value or handle the error
        }
    }
}

enum InteractionState {
    case isNowPlaying
    case isListening
    case isProcessing
    case errorResponse
    case awaitingResponse
    case hasResponded
    case idle
    
    var status: String {
        switch self {
        case .isNowPlaying:
            return "Now playing"
        case .isListening:
            return "Listening"
        case .errorResponse:
            return "Sorry, didn't catch that"
        case .hasResponded:
            return "Recieved answer"
        case .idle:
            return "Start"
        case .isProcessing:
            return "Processing"
        case .awaitingResponse:
            return "Waiting for answer"
        }
    }
}
