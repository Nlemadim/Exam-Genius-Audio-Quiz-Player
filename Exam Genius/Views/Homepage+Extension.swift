//
//  Homepage+Extension.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import Foundation

extension HomePage {
    
    func goToUserLibrary(_ didTap: Bool) {
        if didTap {
            selectedTab = 1
            
            if let package = self.selectedQuizPackage {
                user.selectedQuizPackage = package
                
            }
        }
    }
    
    func packetStatusPrintOut() {
        print("Status Check...")
        let userHasPackage = audioQuizCollection.contains(where: {$0.name == self.quizName})
        let userHasAudioQuiz = downloadedAudioQuizCollection.contains(where: {$0.quizname == self.quizName})
        let userPackage = audioQuizCollection.first(where: { $0.name == self.quizName })
        let userQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == self.quizName })
        
        print(quizName)
        print("Has Package in Database: \(userHasPackage)")
        print("Package name: \(userPackage?.name ?? "None")")
        print("Package questions: \(userPackage?.questions.count ?? 0)")
        print("Has audioQuiz in Database: \(userHasAudioQuiz)")
        print("Quiz name: \(userQuiz?.quizname ?? "None")")
        print("Has selected package: \(user.selectedQuizPackage?.name ?? "None")")
        print("Has selected package: \(user.downloadedQuiz?.quizname ?? "None")")
  
    }
    
    func updateCollections() {
        let topCollection = audioQuizCollection.filter { $0.category.contains(.topCollection) }
        let topPro = audioQuizCollection.filter { $0.category.contains(.topProfessionalCertification) }
        let topColledge = audioQuizCollection.filter { $0.category.contains(.topColledgePicks) }
        let cultureAndSociety = audioQuizCollection.filter { $0.category.contains(.cultureAndSociety) }
        DispatchQueue.main.async {
            self.topCollectionQuizzes.append(contentsOf: topCollection)
            self.topColledgeCollection.append(contentsOf: topColledge)
            self.topProCollection.append(contentsOf: topPro)
            self.cultureAndSociety.append(contentsOf: cultureAndSociety)
        }
    }
    
    func loadUserDetails() {
        guard !self.quizName.isEmptyOrWhiteSpace else {
            print("Quiz name is unavailable")
            return }
        
        if downloadedAudioQuizCollection.isEmpty {
            return
        } else {
            let userPacket = downloadedAudioQuizCollection.first(where: {$0.quizname == self.quizName})
            let hasFullVersion =  UserDefaultsManager.hasFullVersion(for: userPacket?.quizname ?? "UnKnown") ?? false
            if hasFullVersion {
                DispatchQueue.main.async {
                    user.downloadedQuiz = userPacket
                }
            }
        } 
    }
    
    func getFeedBackMessages() -> FeedBackMessageUrls {
        let userFeedbackMessages = voiceFeedbackMessages.first
        let feedbackMessages = FeedBackMessageUrls(
            quizStartMessage: userFeedbackMessages?.quizStartAudioUrl ?? "",
            quizEndingMessage: userFeedbackMessages?.quizEndingAudioUrl ?? "",
            nextQuestionCallout: userFeedbackMessages?.nextQuestionCalloutAudioUrl ?? "",
            finalQuestionCallout: userFeedbackMessages?.finalQuestionCalloutAudioUrl ?? "",
            repeatQuestionCallout: userFeedbackMessages?.repeatQuestionCalloutAudioUrl ?? "",
            listeningCallout: userFeedbackMessages?.listeningCalloutAudioUrl ?? "",
            waitingForResponseCallout: userFeedbackMessages?.waitingForResponseCalloutAudioUrl ?? "",
            pausedCallout: userFeedbackMessages?.pausedCalloutAudioUrl ?? "",
            correctAnswerCallout: userFeedbackMessages?.correctAnswerCalloutUrl ?? "",
            correctAnswerLowStreakCallOut: userFeedbackMessages?.correctAnswerLowStreakCallOutAudioUrl ?? "",
            correctAnswerMidStreakCallout: userFeedbackMessages?.correctAnswerMidStreakCalloutAudioUrl ?? "",
            correctAnswerHighStreakCallout: userFeedbackMessages?.correctAnswerHighStreakCalloutAudioUrl ?? "",
            inCorrectAnswerCallout: userFeedbackMessages?.inCorrectAnswerCalloutAudioUrl ?? "",
            zeroScoreComment: userFeedbackMessages?.zeroScoreCommentAudioUrl ?? "",
            tenPercentScoreComment: userFeedbackMessages?.tenPercentScoreCommentAudioUrl ?? "",
            twentyPercentScoreComment: userFeedbackMessages?.twentyPercentScoreCommentAudioUrl ?? "",
            thirtyPercentScoreComment: userFeedbackMessages?.thirtyPercentScoreCommentAudioUrl ?? "",
            fortyPercentScoreComment: userFeedbackMessages?.fortyPercentScoreCommentAudioUrl ?? "",
            fiftyPercentScoreComment: userFeedbackMessages?.fiftyPercentScoreCommentAudioUrl ?? "",
            sixtyPercentScoreComment: userFeedbackMessages?.sixtyPercentScoreCommentAudioUrl ?? "",
            seventyPercentScoreComment: userFeedbackMessages?.seventyPercentScoreCommentAudioUrl ?? "",
            eightyPercentScoreComment: userFeedbackMessages?.eightyPercentScoreCommentAudioUrl ?? "",
            ninetyPercentScoreComment: userFeedbackMessages?.ninetyPercentScoreCommentAudioUrl ?? "",
            perfectScoreComment: userFeedbackMessages?.perfectScoreCommentAudioUrl ?? "",
            errorTranscriptionCallout: userFeedbackMessages?.errorTranscriptionAudioUrl ?? "",
            invalidResponseCallout: userFeedbackMessages?.invalidResponseCalloutAudioUrl ?? "",
            invalidResponseUserAdvisory: userFeedbackMessages?.invalidResponseUserAdvisoryAudioUrl ?? "")
        
        return feedbackMessages
    }
    
}





