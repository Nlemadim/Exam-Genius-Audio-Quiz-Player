//
//  User.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/16/24.
//

import Foundation
import SwiftUI

final class User: ObservableObject {
    @Published var userName: String = ""
    @Published var currentUserQuiz: String = UserDefaultsManager.quizName()
    @Published var email: String = ""
    @Published var isUsingMic: Bool = UserDefaultsManager.isHandfreeEnabled()
    @Published var isSignedIn: Bool = false
    @Published var isFirstLaunch: Bool = true
    @Published var hasSelectedAudioQuiz: Bool = false
    @Published var audioQuizPackage: AudioQuizPackage?
    @Published var audioQuizPlaylist: [DownloadedAudioQuiz]
    @Published var downloadedAudioQuiz: DownloadedAudioQuiz?
    @Published var hasStartedQuiz: Bool = false
    
    var currentPlayPosition: Int = 0
    
    init(audioQuizPackage: AudioQuizPackage? = nil, downloadedAudioQuiz: DownloadedAudioQuiz? = nil) {
        self.audioQuizPackage = audioQuizPackage
        self.downloadedAudioQuiz = downloadedAudioQuiz
        self.audioQuizPlaylist = []
    }
    
    
    var selectedQuizPackage: AudioQuizPackage? {
        didSet {
            hasSelectedAudioQuiz = selectedQuizPackage != nil
            audioQuizPackage = selectedQuizPackage
            
            // Save the name of the selected quiz package to UserDefaults only if it's not nil
            if let packageName = selectedQuizPackage?.name {
                UserDefaultsManager.setQuizName(quizName: packageName)
                UserDefaults.standard.set(packageName, forKey: "userSelectedPackageName")
            }
        }
    }
    
    var downloadedQuiz: DownloadedAudioQuiz? {
        
        didSet {
            downloadedAudioQuiz = downloadedQuiz
            
            if let quizName = downloadedQuiz?.quizname {
               
                UserDefaults.standard.set(quizName, forKey: "userDownloadedAudioQuizName")
            }
        }
    }
    
}
