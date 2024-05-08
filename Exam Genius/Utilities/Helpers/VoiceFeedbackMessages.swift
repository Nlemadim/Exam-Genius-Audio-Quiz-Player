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
    var nextQuestionCallout: String
    var finalQuestionCallout: String
    var repeatQuestionCallout: String
    var listeningCallout: String
    var waitingForResponseCallout: String
    var pausedCallout: String
    var correctAnswerCallout: String
    var correctAnswerLowStreakCallOut: String
    var correctAnswerMidStreakCallout: String
    var correctAnswerHighStreakCallout: String
    var inCorrectAnswerCallout: String
    var zeroScoreComment: String
    var tenPercentScoreComment: String
    var twentyPercentScoreComment: String
    var thirtyPercentScoreComment: String
    var fortyPercentScoreComment: String
    var fiftyPercentScoreComment: String
    var sixtyPercentScoreComment: String
    var seventyPercentScoreComment: String
    var eightyPercentScoreComment: String
    var ninetyPercentScoreComment: String
    var perfectScoreComment: String
    var errorTranscriptionMessage: String
    var invalidResponseCallout: String
    var invalidResponseUserAdvisory: String
    
    var quizStartAudioUrl: String
    var quizEndingAudioUrl: String
    var nextQuestionCalloutAudioUrl: String
    var finalQuestionCalloutAudioUrl: String
    var repeatQuestionCalloutAudioUrl: String
    var listeningCalloutAudioUrl: String
    var waitingForResponseCalloutAudioUrl: String
    var pausedCalloutAudioUrl: String
    var correctAnswerCalloutUrl: String
    var correctAnswerLowStreakCallOutAudioUrl: String
    var correctAnswerMidStreakCalloutAudioUrl: String
    var correctAnswerHighStreakCalloutAudioUrl: String
    var inCorrectAnswerCalloutAudioUrl: String
    var zeroScoreCommentAudioUrl: String
    var tenPercentScoreCommentAudioUrl: String
    var twentyPercentScoreCommentAudioUrl: String
    var thirtyPercentScoreCommentAudioUrl: String
    var fortyPercentScoreCommentAudioUrl: String
    var fiftyPercentScoreCommentAudioUrl: String
    var sixtyPercentScoreCommentAudioUrl: String
    var seventyPercentScoreCommentAudioUrl: String
    var eightyPercentScoreCommentAudioUrl: String
    var ninetyPercentScoreCommentAudioUrl: String
    var perfectScoreCommentAudioUrl: String
    var errorTranscriptionAudioUrl: String
    var invalidResponseCalloutAudioUrl: String
    var invalidResponseUserAdvisoryAudioUrl: String
    
    init(id: UUID) {
        self.id = id
        self.quizStartMessage = ""
        self.quizEndingMessage = ""
        self.nextQuestionCallout = ""
        self.finalQuestionCallout = ""
        self.repeatQuestionCallout = ""
        self.listeningCallout = ""
        self.waitingForResponseCallout = ""
        self.pausedCallout = ""
        self.correctAnswerCallout = ""
        self.correctAnswerLowStreakCallOut = ""
        self.correctAnswerMidStreakCallout = ""
        self.correctAnswerHighStreakCallout = ""
        self.inCorrectAnswerCallout = ""
        self.zeroScoreComment = ""
        self.tenPercentScoreComment = ""
        self.twentyPercentScoreComment = ""
        self.thirtyPercentScoreComment = ""
        self.fortyPercentScoreComment = ""
        self.fiftyPercentScoreComment = ""
        self.sixtyPercentScoreComment = ""
        self.seventyPercentScoreComment = ""
        self.eightyPercentScoreComment = ""
        self.ninetyPercentScoreComment = ""
        self.perfectScoreComment = ""
        self.errorTranscriptionMessage = ""
        self.invalidResponseCallout = ""
        self.invalidResponseUserAdvisory = ""
        self.quizStartAudioUrl = ""
        self.quizEndingAudioUrl = ""
        self.nextQuestionCalloutAudioUrl = ""
        self.finalQuestionCalloutAudioUrl = ""
        self.repeatQuestionCalloutAudioUrl = ""
        self.listeningCalloutAudioUrl = ""
        self.waitingForResponseCalloutAudioUrl = ""
        self.pausedCalloutAudioUrl = ""
        self.correctAnswerCalloutUrl = ""
        self.correctAnswerLowStreakCallOutAudioUrl = ""
        self.correctAnswerMidStreakCalloutAudioUrl = ""
        self.correctAnswerHighStreakCalloutAudioUrl = ""
        self.inCorrectAnswerCalloutAudioUrl = ""
        self.zeroScoreCommentAudioUrl = ""
        self.tenPercentScoreCommentAudioUrl = ""
        self.twentyPercentScoreCommentAudioUrl = ""
        self.thirtyPercentScoreCommentAudioUrl = ""
        self.fortyPercentScoreCommentAudioUrl = ""
        self.fiftyPercentScoreCommentAudioUrl = ""
        self.sixtyPercentScoreCommentAudioUrl = ""
        self.seventyPercentScoreCommentAudioUrl = ""
        self.eightyPercentScoreCommentAudioUrl = ""
        self.ninetyPercentScoreCommentAudioUrl = ""
        self.perfectScoreCommentAudioUrl = ""
        self.errorTranscriptionAudioUrl = ""
        self.invalidResponseCalloutAudioUrl = ""
        self.invalidResponseUserAdvisoryAudioUrl = ""
    }
}
