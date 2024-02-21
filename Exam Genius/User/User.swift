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
    @Published var isUsingMic: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var isFirstLaunch: Bool = true
    @Published var hasSelectedAudioQuiz: Bool = false
  
}
