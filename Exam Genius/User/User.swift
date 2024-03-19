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
    @Published var email: String = ""
    @Published var accessKey: String = ""
    @Published var isUsingMic: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var isFirstLaunch: Bool = true
    @Published var hasSelectedAudioQuiz: Bool = false
    @Published var audioQuizPackage: AudioQuizPackage?
    @Published var audioQuizPlaylist: [DownloadedAudioQuiz]
    @Published var hasStartedQuiz: Bool = false
    
    var currentPlayPosition: Int = 0
    
    init(audioQuizPackage: AudioQuizPackage? = nil) {
        self.audioQuizPackage = audioQuizPackage
        self.audioQuizPlaylist = []
    }
    
    var currentQuiz: DownloadedAudioQuiz? {
        !audioQuizPlaylist.isEmpty ? audioQuizPlaylist[currentPlayPosition] : nil
    }
    
    var selectedQuizPackage: AudioQuizPackage? {
        didSet {
            hasSelectedAudioQuiz = selectedQuizPackage != nil
            audioQuizPackage = selectedQuizPackage
        }
    }
}
