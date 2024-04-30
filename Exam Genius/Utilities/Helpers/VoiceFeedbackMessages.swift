//
//  VoiceFeedbackMessages.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/24/24.
//

import Foundation
import SwiftData

@Model
class VoiceFeedbackMessages {
    var id: UUID
    var quizStartMessage: String
    var quizEndingMessage: String
    var correctAnswerCallout: String
    var skipQuestionMessage: String
    var errorTranscriptionMessage: String
    var finalScoreMessage: String
    var quizStartAudioUrl: String
    var quizEndingAudioUrl: String
    var correctAnswerCalloutUrl: String
    var skipQuestionAudioUrl: String
    var errorTranscriptionAudioUrl: String
    var finalScoreAudioUrl: String
    
    init(id: UUID) {
        self.id = id
        self.quizStartMessage = ""
        self.quizEndingMessage = ""
        self.correctAnswerCallout = ""
        self.skipQuestionMessage = ""
        self.errorTranscriptionMessage = ""
        self.finalScoreMessage = ""
        self.quizStartAudioUrl = ""
        self.quizEndingAudioUrl = ""
        self.correctAnswerCalloutUrl = ""
        self.skipQuestionAudioUrl = ""
        self.errorTranscriptionAudioUrl = ""
        self.finalScoreAudioUrl = ""
    }
    
    init(id: UUID, quizStartMessage: String, quizEndingMessage: String, correctAnswerCallout: String, skipQuestionMessage: String, errorTranscriptionMessage: String, finalScoreMessage: String, quizStartAudioUrl: String, quizEndingAudioUrl: String, correctAnswerCalloutUrl: String, skipQuestionAudioUrl: String, errorTranscriptionAudioUrl: String, finalScoreAudioUrl: String) {
        self.id = id
        self.quizStartMessage = quizStartMessage
        self.quizEndingMessage = quizEndingMessage
        self.correctAnswerCallout = correctAnswerCallout
        self.skipQuestionMessage = skipQuestionMessage
        self.errorTranscriptionMessage = errorTranscriptionMessage
        self.finalScoreMessage = finalScoreMessage
        self.quizStartAudioUrl = quizStartAudioUrl
        self.quizEndingAudioUrl = quizEndingAudioUrl
        self.correctAnswerCalloutUrl = correctAnswerCalloutUrl
        self.skipQuestionAudioUrl = skipQuestionAudioUrl
        self.errorTranscriptionAudioUrl = errorTranscriptionAudioUrl
        self.finalScoreAudioUrl = finalScoreAudioUrl
    }
}


struct VoiceFeedbackContainer {
    let id: UUID
    var quizStartMessage: String
    var quizEndingMessage: String
    var correctAnswerCallout: String
    var skipQuestionMessage: String
    var errorTranscriptionMessage: String
    var finalScoreMessage: String

    var quizStartAudioUrl: String
    var quizEndingAudioUrl: String
    var correctAnswerCalloutUrl: String
    var skipQuestionAudioUrl: String
    var errorTranscriptionAudioUrl: String
    var finalScoreAudioUrl: String
}


// Extension for VoiceFeedbackMessages
extension VoiceFeedbackMessages {
    convenience init(from container: VoiceFeedbackContainer) {
        self.init(
            id: container.id,
            quizStartMessage: container.quizStartMessage,
            quizEndingMessage: container.quizEndingMessage,
            correctAnswerCallout: container.correctAnswerCallout,
            skipQuestionMessage: container.skipQuestionMessage,
            errorTranscriptionMessage: container.errorTranscriptionMessage,
            finalScoreMessage: container.finalScoreMessage,
            quizStartAudioUrl: container.quizStartAudioUrl,
            quizEndingAudioUrl: container.quizEndingAudioUrl,
            correctAnswerCalloutUrl: container.correctAnswerCalloutUrl,
            skipQuestionAudioUrl: container.skipQuestionAudioUrl,
            errorTranscriptionAudioUrl: container.errorTranscriptionAudioUrl,
            finalScoreAudioUrl: container.finalScoreAudioUrl
        )
    }
}
