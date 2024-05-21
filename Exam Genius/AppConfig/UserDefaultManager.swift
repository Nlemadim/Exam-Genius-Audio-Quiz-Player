//
//  UserDefaultManager.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/18/24.
//

import Foundation

class UserDefaultsManager {
    static func activateHandsfree(activate: Bool) {
        UserDefaults.standard.set(activate, forKey: "isHandfreeEnabled")
    }
    
    static func setQuizVoice(voice: String) {
        UserDefaults.standard.set(voice, forKey: "selectedVoice")
    }
    
    static func setQuizMode(mode: String) {
        UserDefaults.standard.set(mode, forKey: "quizMode")
    }
    
    //TODO: Set at app launch
    static func setDefaultNumberOfTestQuestions() {
        let defaultQuestions = 10
        if UserDefaults.standard.object(forKey: "numberOfTestQuestions") == nil {
            UserDefaults.standard.set(defaultQuestions, forKey: "numberOfTestQuestions")
        }
    }
    
    static func updateNumberOfGlobalGlobalTopics() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfGlobalTopics")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfGlobalTopics")
    }
    
    static func setDefaultPointsPerQuestion() {
        let defaultPoints = 5
        if UserDefaults.standard.object(forKey: "pointsPerQuestion") == nil {
            UserDefaults.standard.set(defaultPoints, forKey: "pointsPerQuestion")
        }
    }
    
    static func incrementNumberOfTestsTaken() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfTestsTaken")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfTestsTaken")
    }
    
    static func incrementNumberOfQuizSessions() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfQuizSessions")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfQuizSessions")
    }
    
    static func updateNumberOfGlobalQuestions() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfGlobalQuestions")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfGlobalQuestions")
    }
    
    static func updateNumberOfTopicsCovered() {
        let currentCount = UserDefaults.standard.integer(forKey: "numberOfTopicsCovered")
        UserDefaults.standard.set(currentCount + 1, forKey: "numberOfTopicsCovered")
    }
    
    static func incrementTotalQuestionsAnswered() {
        let currentCount = UserDefaults.standard.integer(forKey: "totalQuestionsAnswered")
        UserDefaults.standard.set(currentCount + 1, forKey: "totalQuestionsAnswered")
    }
    
    static func updateHighScore(_ score: Int) {
        let currentScore = UserDefaults.standard.integer(forKey: "userHighScore")
        if currentScore <= score {
            UserDefaults.standard.set(score, forKey: "userHighScore")
        }
    }
    
    static func updateCurrentPosition(_ position: Int) {
        UserDefaults.standard.set(position, forKey: "quizCurrentPosition")
    }
    
    static func updateCurrentScoreStreak(correctAnswerCount: Int) {
        UserDefaults.standard.set(correctAnswerCount, forKey: "currentScoreStreak")
    }
    
    static func updateCurrentQuizStatus(inProgress: Bool) {
        UserDefaults.standard.set(inProgress, forKey: "quizInProgress")
    }
    
    static func enableContinousFlow() {
        UserDefaults.standard.setValue(true, forKey: "isOnContinuousFlow")
    }
    
    static func updateRecievedInvalidResponseAdvisory() {
        UserDefaults.standard.setValue(true, forKey: "hasRecievedInvalidResponseAdvisory")
    }
    
    static func userName() -> String {
        return UserDefaults.standard.string(forKey: "userName") ?? ""
    }
    
    static func selectedVoice() -> String {
        return UserDefaults.standard.string(forKey: "selectedVoice") ?? ""
    }
    
    static func quizMode() -> String {
        return UserDefaults.standard.string(forKey: "quizMode") ?? ""
    }
    
    static func isStudyModeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isStudyMode")
    }
    
    static func isHandfreeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isHandfreeEnabled")
    }
    
    static func hasRecievedInvalidResponseAdvisory() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasRecievedInvalidResponseAdvisory")
    }
    
    static func isOnContinuousFlow() -> Bool {
        return UserDefaults.standard.bool(forKey: "isOnContinuousFlow")
    }
    
    static func isTimerEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isTimerEnabled")
    }
    
    static func isFocusEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isFocusEnabled")
    }
    
    static func userHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: "userHighScore")
    }
    
    static func currentPlayPosition() -> Int {
        return UserDefaults.standard.integer(forKey: "quizCurrentPosition")
    }
    
    static func currentScoreStreak() -> Int {
        return UserDefaults.standard.integer(forKey: "currentScoreStreak")
    }
    
    static func quizInProgress() -> Bool {
        return UserDefaults.standard.bool(forKey: "quizInProgress")
    }
    
    static func globalTopics() -> String {
        return UserDefaults.standard.string(forKey: "globalTopics") ?? ""
    }
    
    static func numberOfGlobalTopics() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfGlobalTopics")
    }
    
    static func numberOfTopicsCovered() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfTopicsCovered")
    }
    
    static func topicsInFocus() -> String {
        return UserDefaults.standard.string(forKey: "topicsInFocus") ?? ""
    }
    
    static func numberOfTestsTaken() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfTestsTaken")
    }
    
    static func numberOfQuizSessions() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfQuizSessions")
    }
    
    static func totalQuestionsAnswered() -> Int {
        return UserDefaults.standard.integer(forKey: "totalQuestionsAnswered")
    }
    
    static func numberOfGlobalQuestions() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfGlobalQuestions")
    }
    
    static func numberOfTestQuestions() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfTestQuestions")
    }
    
    static func nameOfTest() -> String {
        return UserDefaults.standard.string(forKey: "nameOfTest") ?? ""
    }
    
    static func pointsPerQuestion() -> Int {
        return UserDefaults.standard.integer(forKey: "pointsPerQuestion")
    }
    
    static func resetAllValues() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            print("All data has been Reset!")
        }
    }
    
}

