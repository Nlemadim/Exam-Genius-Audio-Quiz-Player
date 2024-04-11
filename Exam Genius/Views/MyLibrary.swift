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
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @ObservedObject var miniPlayerConfig = MiniPlayer.MiniPlayerConfiguration()
    @StateObject var viewModel = MyLibrary.MyLibraryVM()
    @StateObject private var generator = ColorGenerator()
    @StateObject private var playlistConfig = MyLibrary.LibraryPlaylist()
    
    @State var selectedQuizPackage: AudioQuizPackage?
    @State var downloadedAudioQuizCollection: [AudioQuizPackage] = []
    @State var configuration: QuizViewConfiguration?
    @State var audioPlaylist: [PlayerContent] = []
    @State var interactionState: InteractionState = .idle
    
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
                            
                            PlayerContentItemView(content: content, playContent: { playlistConfig.startedPlaying = true }, interactionState: $interactionState, isDownloaded: $isDownloaded)
                                
                            Divider().padding()
                        }
                    }
                }
                .onAppear {
                    updatePlaylist()
                }
                .onChange(of: user.hasSelectedAudioQuiz) {_, _ in
                    updatePlaylist()
                }
                .onReceive(miniPlayerConfig.$stoppedPlaying, perform: { stop in
                    
                })
               
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}


#Preview {
    let user = User()
    let appState = AppState()
    return MyLibrary()
        .environmentObject(user)
        .environmentObject(appState)
       
}

extension MyLibrary {
    class LibraryPlaylist: ObservableObject {
       @Published var startedPlaying: Bool = false
       @Published var selectedQuiz: AudioQuizPackage?
    }
}
