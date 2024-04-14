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
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @StateObject var viewModel = MyLibrary.MyLibraryVM()
    @StateObject private var generator = ColorGenerator()
    @StateObject private var playlistConfig = MyLibrary.LibraryPlaylist()
    
    @State var selectedQuizPackage: AudioQuizPackage?
    @State var downloadedAudioQuizCollection: [AudioQuizPackage] = []
    @State var configuration: QuizViewConfiguration?
    @State var audioPlaylist: [PlayerContent] = []
    @Binding var interactionState: InteractionState
    
//    @State private var playTapped: Bool = false
    @State private var nextTapped: Bool = false
    @State private var repeatTapped: Bool = false
    @State private var presentMicModal: Bool = false
    @State private var isDownloaded: Bool = false
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var isPlaying: Bool = false
    @State var presentConfirmationModal: Bool = false
    @State var currentPlaylistItemIndex: Int = 0
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    
    init(interactionState: Binding<InteractionState>) {
        _interactionState = interactionState
    }
    
    var body: some View {
        ZStack {
            PlayerBackgroundView()
            
            VStack(alignment: .leading, spacing: 12) {
                
                AudioQuizHeaderView(selectedQuizPackage: downloadedAudioQuizCollection.isEmpty ? user.audioQuizPackage : self.downloadedAudioQuizCollection[self.currentPlaylistItemIndex])
                
                AudioQuizProgressView(selectedQuizPackage: downloadedAudioQuizCollection.isEmpty ? user.audioQuizPackage : self.downloadedAudioQuizCollection[self.currentPlaylistItemIndex])
                
                Divider()
                
                PlaylistHeaderView()
                
                Divider()
                
                // Playlist
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(audioPlaylist.enumerated()), id: \.element) { index, content in
                            
                            PlayerContentItemView(content: content, playContent: { startPlayer()}, interactionState: $interactionState, isDownloaded: $isDownloaded)
                                
                            Divider().padding()
                        }
                    }
                }
                .onAppear {
                    updatePlaylist()
                    //loadMockData()
                }
                .onChange(of: user.hasSelectedAudioQuiz) {_, _ in
                    updatePlaylist()
                }
               
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func startPlayer() {
        if self.interactionState != .isNowPlaying {
            self.quizPlayerObserver.playerState = .startedPlayingQuiz
            self.interactionState = .isNowPlaying
        } else {
            self.interactionState = .isDonePlaying
            self.quizPlayerObserver.playerState = .idle
        }
        
        print("Player Started")
    }
}


#Preview {
    let user = User()
    let appState = AppState()
    let observer = QuizPlayerObserver()
    return MyLibrary(interactionState: .constant(.idle))
        .environmentObject(user)
        .environmentObject(appState)
        .environmentObject(observer)
       
}

extension MyLibrary {
    class LibraryPlaylist: ObservableObject {
       @Published var startedPlaying: Bool = false
       @Published var selectedQuiz: AudioQuizPackage?
    }
}
