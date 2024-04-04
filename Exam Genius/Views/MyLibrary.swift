//
//  MyLibrary.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import SwiftUI
import SwiftData

struct MyLibrary: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = MyLibrary.MyLibraryVM()
    
    @State private var selectedQuizPackage: AudioQuizPackage?
    @State private var interactionState: InteractionState = .idle
    @State private var isDownloaded: Bool = false
    @State var audioPlaylist: [PlayerContent] = []
    
    
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
                            Divider().padding()
                        }
                    }
                }
                .onAppear {
                    if let quizPackage = user.audioQuizPackage {
                        viewModel.addAudioQuizToLibrary(from: quizPackage)
                        print(quizPackage.questions.count)
                    }
                    
                    //viewModel.loadMockData()
                }
                .onChange(of: user.hasSelectedAudioQuiz) {_, _ in
                    if let quizPackage = user.audioQuizPackage {
                        viewModel.addAudioQuizToLibrary(from: quizPackage)
                        
                    }
                }
                .onReceive(viewModel.$audioPlaylist, perform: { playlist in
                    DispatchQueue.main.async {
                        self.audioPlaylist.append(contentsOf: playlist)
                        print(audioPlaylist.count)
                    }
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

