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
    var nextQuestion: String
    var skipQuestionMessage: String
    var errorTranscriptionMessage: String
    var finalScoreMessage: String
    var quizStartAudioUrl: String
    var quizEndingAudioUrl: String
    var nextQuestionAudioUrl: String
    var skipQuestionAudioUrl: String
    var errorTranscriptionAudioUrl: String
    var finalScoreAudioUrl: String
    
    init(id: UUID) {
        self.id = id
        self.quizStartMessage = ""
        self.quizEndingMessage = ""
        self.nextQuestion = ""
        self.skipQuestionMessage = ""
        self.errorTranscriptionMessage = ""
        self.finalScoreMessage = ""
        self.quizStartAudioUrl = ""
        self.quizEndingAudioUrl = ""
        self.nextQuestionAudioUrl = ""
        self.skipQuestionAudioUrl = ""
        self.errorTranscriptionAudioUrl = ""
        self.finalScoreAudioUrl = ""
    }
    
    init(id: UUID, quizStartMessage: String, quizEndingMessage: String, nextQuestion: String, skipQuestionMessage: String, errorTranscriptionMessage: String, finalScoreMessage: String, quizStartAudioUrl: String, quizEndingAudioUrl: String, nextQuestionAudioUrl: String, skipQuestionAudioUrl: String, errorTranscriptionAudioUrl: String, finalScoreAudioUrl: String) {
        self.id = id
        self.quizStartMessage = quizStartMessage
        self.quizEndingMessage = quizEndingMessage
        self.nextQuestion = nextQuestion
        self.skipQuestionMessage = skipQuestionMessage
        self.errorTranscriptionMessage = errorTranscriptionMessage
        self.finalScoreMessage = finalScoreMessage
        self.quizStartAudioUrl = quizStartAudioUrl
        self.quizEndingAudioUrl = quizEndingAudioUrl
        self.nextQuestionAudioUrl = nextQuestionAudioUrl
        self.skipQuestionAudioUrl = skipQuestionAudioUrl
        self.errorTranscriptionAudioUrl = errorTranscriptionAudioUrl
        self.finalScoreAudioUrl = finalScoreAudioUrl
    }
}



struct VoiceFeedbackContainer {
    let id: UUID
    var quizStartMessage: String
    var quizEndingMessage: String
    var nextQuestion: String
    var skipQuestionMessage: String
    var errorTranscriptionMessage: String
    var finalScoreMessage: String

    var quizStartAudioUrl: String
    var quizEndingAudioUrl: String
    var nextQuestionAudioUrl: String
    var skipQuestionAudioUrl: String
    var errorTranscriptionAudioUrl: String
    var finalScoreAudioUrl: String
}



//struct VoiceFeedbackContainer {
//    var id: UUID
//    var quizStartMessage: String = "Starting a new quiz now."
//    var quizEndingMessage: String = "Great Job!, this quiz is now complete. Checking your scores are  processed"
//    var nextQuestion: String = "Next Question"
//    var skipQuestionMessage: String = "Skipping this question for the moment"
//    var ErrorTranscriptionMessage: String = "Error transcribing, skipping this question for now"
//    var finalScoreMessage: String = ""
//    var quizStartAudioUrl: String = ""
//    var quizEndingAudioUrl: String = ""
//    var nextQuestionAudioUrl: String = ""
//    var skipQuestionAudioUrl: String = ""
//    var errorTranscriptionAudioUrl: String = ""
//    var finalScoreAudioUrl: String = ""
//}


// Extension for VoiceFeedbackMessages
extension VoiceFeedbackMessages {
    convenience init(from container: VoiceFeedbackContainer) {
        self.init(
            id: container.id,
            quizStartMessage: container.quizStartMessage,
            quizEndingMessage: container.quizEndingMessage,
            nextQuestion: container.nextQuestion,
            skipQuestionMessage: container.skipQuestionMessage,
            errorTranscriptionMessage: container.errorTranscriptionMessage,
            finalScoreMessage: container.finalScoreMessage,
            quizStartAudioUrl: container.quizStartAudioUrl,
            quizEndingAudioUrl: container.quizEndingAudioUrl,
            nextQuestionAudioUrl: container.nextQuestionAudioUrl,
            skipQuestionAudioUrl: container.skipQuestionAudioUrl,
            errorTranscriptionAudioUrl: container.errorTranscriptionAudioUrl,
            finalScoreAudioUrl: container.finalScoreAudioUrl
        )
    }
}
