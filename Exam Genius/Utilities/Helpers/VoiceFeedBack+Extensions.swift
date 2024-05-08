//
//  VoiceFeedBack+Extensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/8/24.
//

import Foundation
import SwiftUI

extension VoiceFeedbackMessages {
    convenience init(from container: VoiceFeedbackContainer) {
        self.init(id: container.id)
        self.quizStartMessage = container.quizStartMessage
        self.quizEndingMessage = container.quizEndingMessage
        self.nextQuestionCallout = container.nextQuestionCallout
        self.finalQuestionCallout = container.finalQuestionCallout
        self.repeatQuestionCallout = container.repeatQuestionCallout
        self.listeningCallout = container.listeningCallout
        self.waitingForResponseCallout = container.waitingForResponseCallout
        self.pausedCallout = container.pausedCallout
        self.correctAnswerCallout = container.correctAnswerCallout
        self.correctAnswerLowStreakCallOut = container.correctAnswerLowStreakCallOut
        self.correctAnswerMidStreakCallout = container.correctAnswerMidStreakCallout
        self.correctAnswerHighStreakCallout = container.correctAnswerHighStreakCallout
        self.inCorrectAnswerCallout = container.inCorrectAnswerCallout
        self.zeroScoreComment = container.zeroScoreComment
        self.tenPercentScoreComment = container.tenPercentScoreComment
        self.twentyPercentScoreComment = container.twentyPercentScoreComment
        self.thirtyPercentScoreComment = container.thirtyPercentScoreComment
        self.fortyPercentScoreComment = container.fortyPercentScoreComment
        self.fiftyPercentScoreComment = container.fiftyPercentScoreComment
        self.sixtyPercentScoreComment = container.sixtyPercentScoreComment
        self.seventyPercentScoreComment = container.seventyPercentScoreComment
        self.eightyPercentScoreComment = container.eightyPercentScoreComment
        self.ninetyPercentScoreComment = container.ninetyPercentScoreComment
        self.perfectScoreComment = container.perfectScoreComment
        self.errorTranscriptionMessage = container.errorTranscriptionCallout
        self.invalidResponseCallout = container.invalidResponseCallout
        self.invalidResponseUserAdvisory = container.invalidResponseUserAdvisory
        self.quizStartAudioUrl =  container.quizStartMessageAudioUrl
        self.quizEndingAudioUrl =  container.quizEndingMessageAudioUrl
        self.nextQuestionCalloutAudioUrl =  container.nextQuestionCalloutAudioUrl
        self.finalQuestionCalloutAudioUrl =  container.finalQuestionCalloutAudioUrl
        self.repeatQuestionCalloutAudioUrl =  container.repeatQuestionCalloutAudioUrl
        self.listeningCalloutAudioUrl =  container.listeningCalloutAudioUrl
        self.waitingForResponseCalloutAudioUrl =  container.waitingForResponseCalloutAudioUrl
        self.pausedCalloutAudioUrl =  container.pausedCalloutAudioUrl
        self.correctAnswerCalloutUrl =  container.correctAnswerCalloutAudioUrl
        self.correctAnswerLowStreakCallOutAudioUrl =  container.correctAnswerLowStreakCallOutAudioUrl
        self.correctAnswerMidStreakCalloutAudioUrl =  container.correctAnswerMidStreakCalloutAudioUrl
        self.correctAnswerHighStreakCalloutAudioUrl  = container.correctAnswerHighStreakCalloutAudioUrl
        self.inCorrectAnswerCalloutAudioUrl =  container.inCorrectAnswerCalloutAudioUrl
        self.zeroScoreCommentAudioUrl =  container.zeroScoreCommentAudioUrl
        self.tenPercentScoreCommentAudioUrl =  container.tenPercentScoreCommentAudioUrl
        self.twentyPercentScoreCommentAudioUrl =  container.twentyPercentScoreCommentAudioUrl
        self.thirtyPercentScoreCommentAudioUrl =  container.thirtyPercentScoreCommentAudioUrl
        self.fortyPercentScoreCommentAudioUrl =  container.fortyPercentScoreCommentAudioUrl
        self.fiftyPercentScoreCommentAudioUrl =  container.fiftyPercentScoreCommentAudioUrl
        self.sixtyPercentScoreCommentAudioUrl =  container.sixtyPercentScoreCommentAudioUrl
        self.seventyPercentScoreCommentAudioUrl =  container.seventyPercentScoreCommentAudioUrl
        self.eightyPercentScoreCommentAudioUrl =  container.eightyPercentScoreCommentAudioUrl
        self.ninetyPercentScoreCommentAudioUrl =  container.ninetyPercentScoreCommentAudioUrl
        self.perfectScoreCommentAudioUrl =  container.perfectScoreCommentAudioUrl
        self.errorTranscriptionAudioUrl =  container.errorTranscriptionCalloutAudioUrl
        self.invalidResponseCalloutAudioUrl =  container.invalidResponseCalloutAudioUrl
        self.invalidResponseUserAdvisoryAudioUrl =  container.invalidResponseUserAdvisoryAudioUrl
        
    }
}


struct VoiceFeedbackContainer {
    let id: UUID
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
    var errorTranscriptionCallout: String
    var invalidResponseCallout: String
    var invalidResponseUserAdvisory: String

    // Audio URLs
    var quizStartMessageAudioUrl: String
    var quizEndingMessageAudioUrl: String
    var nextQuestionCalloutAudioUrl: String
    var finalQuestionCalloutAudioUrl: String
    var repeatQuestionCalloutAudioUrl: String
    var listeningCalloutAudioUrl: String
    var waitingForResponseCalloutAudioUrl: String
    var pausedCalloutAudioUrl: String
    var correctAnswerCalloutAudioUrl: String
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
    var errorTranscriptionCalloutAudioUrl: String
    var invalidResponseCalloutAudioUrl: String
    var invalidResponseUserAdvisoryAudioUrl: String
    
}


struct FeedBackMessageUrls {
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
    var errorTranscriptionCallout: String
    var invalidResponseCallout: String
    var invalidResponseUserAdvisory: String
}
