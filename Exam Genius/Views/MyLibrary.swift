//
//  MyLibrary.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import SwiftUI
import SwiftData
import Combine
import AVKit

struct MyLibrary: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @StateObject var viewModel = MyLibrary.MyLibraryVM()
    @StateObject private var generator = ColorGenerator()
    @StateObject var questionPlayer = QuestionPlayer()
    @StateObject var responseListener = ResponseListener()
    @StateObject var quizSetter = QuizPlayerView.QuizSetter()
    
    @State private var currentQuestion: Question?
    @State var selectedQuizPackage: AudioQuizPackage?
    @State var configuration: QuizViewConfiguration?
    @State var audioPlaylist: [PlayerContent] = []
    @State var interactionState: InteractionState = .idle
    
    
    @State private var playTapped: Bool = false
    @State private var nextTapped: Bool = false
    @State private var repeatTapped: Bool = false
    @State private var presentMicModal: Bool = false
    @State private var isDownloaded: Bool = false
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var isPlaying: Bool = false
    @State var presentConfirmationModal: Bool = false
    
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    
    
    var body: some View {
        ZStack {
            PlayerBackgroundView()
            
            VStack(alignment: .leading, spacing: 12) {
                
                AudioQuizHeaderView(selectedQuizPackage: user.audioQuizPackage)
                
                AudioQuizProgressView(selectedQuizPackage: user.audioQuizPackage)
                
                Divider()
                
                PlaylistHeaderView()
                
                Divider()
                
                // Playlist
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(audioPlaylist, id: \.self) { content in
                            PlayerContentItemView(content: content, interactionState: $interactionState, isDownloaded: $isDownloaded)
                                .onTapGesture {
                                    self.expandSheet.toggle()
                                }
                            
                            Divider().padding()
                        }
                    }
                }
                .onAppear {
                    updatePlaylist()
                }
                .onAppear {
                    if let audioQuiz = selectedQuizPackage {
                        quizSetter.loadQuizConfiguration(quizPackage: audioQuiz)
                    }
                }
                .onChange(of: selectedQuizPackage) { _, newValue in
                    if let newPackage = newValue {
                        quizSetter.loadQuizConfiguration(quizPackage: newPackage)
                    }
                }
                .onChange(of: playTapped, { _, _ in
                    playQuestion()
                })
                .onChange(of: nextTapped) { _, _ in
                    goToNextQuestion()
                }
                .onChange(of: questionPlayer.interactionState) { _, newState in
                    checkPlayerState(newState)
                }
                .onChange(of: responseListener.interactionState) { _, interaction in
                    checkForResponse(interaction)
                }
                .onChange(of: user.hasSelectedAudioQuiz) {_, _ in
                    updatePlaylist()
                }
                .fullScreenCover(isPresented: $expandSheet) {
                    QuizView(quizSetter: quizSetter, currentQuestionIndex: $currentQuestionIndex, isNowPlaying: $playTapped, isCorrectAnswer: $presentConfirmationModal, presentMicModal: $presentMicModal, nextTapped: $nextTapped, interactionState: $interactionState)
                }
               
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    
    private func checkForResponse(_ interaction: InteractionState) {
        self.interactionState = interaction
        DispatchQueue.main.async {
            //self.interactionState = newValue
            print("QuizPlayer interaction State is: \(self.interactionState)")
            if interaction == .idle {
                self.selectedOption = responseListener.userTranscript
                print("Quiz view has registered new selectedOption as: \(self.selectedOption)")
                analyseResponse()
            }
        }
        
    }
    
    private func checkPlayerState(_ interaction: InteractionState) {
        self.interactionState = interaction
        if interaction == .isDonePlaying {
            print("QuizPlayer interaction State is: \(self.interactionState)")
            responseListener.recordAnswer()
        }
        
    }
    
}

#Preview {
    let user = User()
    let appState = AppState()
    return MyLibrary()
        .environmentObject(user)
        .environmentObject(appState)
       
}

