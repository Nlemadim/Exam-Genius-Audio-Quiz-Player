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
            quizStartMessage: "Get ready for a new quiz.",
            quizEndingMessage: "Well done! This quiz is now complete.",
            nextQuestionCallout: "Next question coming up.",
            finalQuestionCallout: "This is the final question.",
            repeatQuestionCallout: "Repeating the last question.",
            listeningCallout: "I'm listening...",
            waitingForResponseCallout: "I didn't register a response so i'll skip this question.",
            pausedCallout: "Quiz is now paused.",
            correctAnswerCallout: "That's the correct Answer!",
            correctAnswerLowStreakCallOut: "Correct! You're on a streak",
            correctAnswerMidStreakCallout: "Correct yet again! You're on fire! let's keep going.",
            correctAnswerHighStreakCallout: "Amazing! that's a perfect streak!",
            inCorrectAnswerCallout: "That's not quite right.",
            zeroScoreComment: "No points earned scored. Try harder next time.",
            tenPercentScoreComment: "You scored ten percent. Practice makes perfect.",
            twentyPercentScoreComment: "You scored twenty percent. let's keep learning.",
            thirtyPercentScoreComment: "Thirty percent scored, you're getting there.",
            fortyPercentScoreComment: "Forty percent scored, good effort.",
            fiftyPercentScoreComment: "Halfway there! You scored fifty percent!",
            sixtyPercentScoreComment: "Sixty percent scored, well done!",
            seventyPercentScoreComment: "You scored Seventy percent, Great job!",
            eightyPercentScoreComment: "You scored an impressive Eighty percent, excellent work.",
            ninetyPercentScoreComment: "Wow! You scored Ninety percent, almost a perfect score! Great job!",
            perfectScoreComment: "Perfect score! You got all questions correct! Congratulations!",
            errorTranscriptionCallout: "Error transcribing your response. Skipping this question for now.",
            invalidResponseCallout: "I did not register your response so this question will be marked as unanswered and will not count towards your final score. Unanswered questions will be randonmly presented at different quizzes",
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
