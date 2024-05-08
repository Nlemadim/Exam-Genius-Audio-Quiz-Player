//
//  QuizDataManager+VoiceFeedback+Extension.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/8/24.
//

import Foundation

extension QuizDataManager {
    
    func downloadAllFeedbackAudio() async -> VoiceFeedbackContainer {
        let voiceFeedback = loadMainVoiceFeedBackMessages()
            var updatedFeedback = voiceFeedback
        let messagesAndPaths: [(message: String, keyPath: WritableKeyPath<VoiceFeedbackContainer, String>)] = [
            (voiceFeedback.quizStartMessage, \VoiceFeedbackContainer.quizStartMessageAudioUrl),
            (voiceFeedback.quizEndingMessage, \VoiceFeedbackContainer.quizEndingMessageAudioUrl),
            (voiceFeedback.nextQuestionCalloutAudioUrl, \VoiceFeedbackContainer.nextQuestionCalloutAudioUrl),
            (voiceFeedback.finalQuestionCallout, \VoiceFeedbackContainer.finalQuestionCalloutAudioUrl),
            (voiceFeedback.repeatQuestionCallout, \VoiceFeedbackContainer.repeatQuestionCalloutAudioUrl),
            (voiceFeedback.listeningCallout, \VoiceFeedbackContainer.listeningCalloutAudioUrl),
            (voiceFeedback.waitingForResponseCallout, \VoiceFeedbackContainer.waitingForResponseCalloutAudioUrl),
            (voiceFeedback.pausedCallout, \VoiceFeedbackContainer.pausedCalloutAudioUrl),
            (voiceFeedback.correctAnswerCallout, \VoiceFeedbackContainer.correctAnswerCalloutAudioUrl),
            (voiceFeedback.correctAnswerLowStreakCallOut, \VoiceFeedbackContainer.correctAnswerLowStreakCallOutAudioUrl),
            (voiceFeedback.correctAnswerMidStreakCallout, \VoiceFeedbackContainer.correctAnswerMidStreakCalloutAudioUrl),
            (voiceFeedback.correctAnswerHighStreakCallout, \VoiceFeedbackContainer.correctAnswerHighStreakCalloutAudioUrl),
            (voiceFeedback.inCorrectAnswerCallout, \VoiceFeedbackContainer.inCorrectAnswerCalloutAudioUrl),
            (voiceFeedback.zeroScoreComment, \VoiceFeedbackContainer.zeroScoreCommentAudioUrl),
            (voiceFeedback.tenPercentScoreComment, \VoiceFeedbackContainer.tenPercentScoreCommentAudioUrl),
            (voiceFeedback.twentyPercentScoreComment, \VoiceFeedbackContainer.twentyPercentScoreCommentAudioUrl),
            (voiceFeedback.thirtyPercentScoreComment, \VoiceFeedbackContainer.thirtyPercentScoreCommentAudioUrl),
            (voiceFeedback.fortyPercentScoreComment, \VoiceFeedbackContainer.fortyPercentScoreCommentAudioUrl),
            (voiceFeedback.fiftyPercentScoreComment, \VoiceFeedbackContainer.fiftyPercentScoreCommentAudioUrl),
            (voiceFeedback.sixtyPercentScoreComment, \VoiceFeedbackContainer.sixtyPercentScoreCommentAudioUrl),
            (voiceFeedback.seventyPercentScoreComment, \VoiceFeedbackContainer.seventyPercentScoreCommentAudioUrl),
            (voiceFeedback.eightyPercentScoreComment, \VoiceFeedbackContainer.eightyPercentScoreCommentAudioUrl),
            (voiceFeedback.ninetyPercentScoreComment, \VoiceFeedbackContainer.ninetyPercentScoreCommentAudioUrl),
            (voiceFeedback.perfectScoreComment, \VoiceFeedbackContainer.perfectScoreCommentAudioUrl),
            (voiceFeedback.errorTranscriptionCallout, \VoiceFeedbackContainer.errorTranscriptionCalloutAudioUrl),
            (voiceFeedback.invalidResponseCallout, \VoiceFeedbackContainer.invalidResponseCalloutAudioUrl),
            (voiceFeedback.invalidResponseUserAdvisory, \VoiceFeedbackContainer.invalidResponseUserAdvisoryAudioUrl)
        ]


            var failedDownloads: [(message: String, keyPath: WritableKeyPath<VoiceFeedbackContainer, String>)] = []

            // First, try to download all audio files concurrently
            await withTaskGroup(of: (WritableKeyPath<VoiceFeedbackContainer, String>, String?).self) { group in
                for (message, keyPath) in messagesAndPaths {
                    group.addTask {
                        let audioUrl = await self.downloadReadOut(readOut: message)
                        return (keyPath, audioUrl)
                    }
                }
                for await (keyPath, audioUrl) in group {
                    if let url = audioUrl {
                        updatedFeedback[keyPath: keyPath] = url
                    } else {
                        // Collect failed downloads for retry
                        if let index = messagesAndPaths.firstIndex(where: { $0.keyPath == keyPath }) {
                            failedDownloads.append(messagesAndPaths[index])
                        }
                    }
                }
            }

            // Retry failed downloads sequentially with a limit of 3 retries
            for (message, keyPath) in failedDownloads {
                let audioUrl = await retryDownload(readOut: message, retries: 3)
                if let url = audioUrl {
                    updatedFeedback[keyPath: keyPath] = url
                }
            }

            return updatedFeedback
        }

        // Retry download with a specific number of attempts
        private func retryDownload(readOut: String, retries: Int) async -> String? {
            var currentAttempt = 0
            while currentAttempt < retries {
                if let url = await downloadReadOut(readOut: readOut) {
                    return url
                }
                currentAttempt += 1
                print("Retry \(currentAttempt) for: \(readOut)")
            }
            print("Failed to download after \(retries) attempts: \(readOut)")
            return nil
        }
    
    private func loadMainVoiceFeedBackMessages() -> VoiceFeedbackContainer{
        let container = VoiceFeedbackContainer(
            id: UUID(),
            quizStartMessage: "Starting a new quiz now.",
            quizEndingMessage: "Great job! This quiz is now complete.",
            nextQuestionCallout: "Next question coming up.",
            finalQuestionCallout: "This is the final question.",
            repeatQuestionCallout: "Repeating the last question.",
            listeningCallout: "I'm listening...",
            waitingForResponseCallout: "Please provide your response.",
            pausedCallout: "Quiz is now paused.",
            correctAnswerCallout: "That's the correct Answer!",
            correctAnswerLowStreakCallOut: "You're doing well, keep going!",
            correctAnswerMidStreakCallout: "Great, you're on a streak!",
            correctAnswerHighStreakCallout: "Amazing, you're on fire!",
            inCorrectAnswerCallout: "That's not quite right.",
            zeroScoreComment: "You've completed the quiz, try harder next time.",
            tenPercentScoreComment: "You scored ten percent, practice makes perfect.",
            twentyPercentScoreComment: "Twenty percent, keep learning.",
            thirtyPercentScoreComment: "Thirty percent scored, you're getting there.",
            fortyPercentScoreComment: "Forty percent, good effort.",
            fiftyPercentScoreComment: "Halfway there with fifty percent!",
            sixtyPercentScoreComment: "Sixty percent, well done.",
            seventyPercentScoreComment: "Seventy percent, great job.",
            eightyPercentScoreComment: "Eighty percent, excellent work.",
            ninetyPercentScoreComment: "Ninety percent, almost perfect!",
            perfectScoreComment: "Perfect score! Congratulations!",
            errorTranscriptionCallout: "Error transcribing your response. Skipping this question for now.",
            invalidResponseCallout: "That's an invalid response. Skipping this question for now.",
            invalidResponseUserAdvisory: "Please try to respond with valid options only. Invalid responses are skipped.",
            quizStartMessageAudioUrl: "",
            quizEndingMessageAudioUrl: "",
            nextQuestionCalloutAudioUrl: "",
            finalQuestionCalloutAudioUrl: "",
            repeatQuestionCalloutAudioUrl: "",
            listeningCalloutAudioUrl: "",
            waitingForResponseCalloutAudioUrl: "",
            pausedCalloutAudioUrl: "",
            correctAnswerCalloutAudioUrl: "",
            correctAnswerLowStreakCallOutAudioUrl: "",
            correctAnswerMidStreakCalloutAudioUrl: "",
            correctAnswerHighStreakCalloutAudioUrl: "",
            inCorrectAnswerCalloutAudioUrl: "",
            zeroScoreCommentAudioUrl: "",
            tenPercentScoreCommentAudioUrl: "",
            twentyPercentScoreCommentAudioUrl: "",
            thirtyPercentScoreCommentAudioUrl: "",
            fortyPercentScoreCommentAudioUrl: "",
            fiftyPercentScoreCommentAudioUrl: "",
            sixtyPercentScoreCommentAudioUrl: "",
            seventyPercentScoreCommentAudioUrl: "",
            eightyPercentScoreCommentAudioUrl: "",
            ninetyPercentScoreCommentAudioUrl: "",
            perfectScoreCommentAudioUrl: "",
            errorTranscriptionCalloutAudioUrl: "",
            invalidResponseCalloutAudioUrl: "",
            invalidResponseUserAdvisoryAudioUrl: ""
        )
        
        return container
    }

}
