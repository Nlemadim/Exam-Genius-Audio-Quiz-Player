//
//  ExplorePage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/3/24.
//

import SwiftUI
import SwiftData

struct ExplorePage: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var user: User
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    
    @StateObject var audioContentPlayer = AudioContentPlayer()
    
    @State var interactionState: InteractionState = .idle
    @State var selectedQuizPackage: AudioQuizPackage?
    @State private var searchText = ""
    @Binding var selectedTab: Int
    @State var didTapSample: Bool = false
    @State var didTapDownload: Bool = false
    @State var goToLibrary: Bool = false
    @State var isPlaying: Bool = false
    
    private let networkService: NetworkService = NetworkService.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(filteredQuizzes, id: \.self) { quiz in
                                let quizItem = MyPlaylistItem(from: quiz)
                                AudQuizCardViewMid(quiz: quizItem)
                                    .onTapGesture {
                                        self.selectedQuizPackage = quiz
                                    }
                            }
                        }
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
                QuizDetailPage(audioQuiz: selectedQuiz, didTapSample: $didTapSample, didTapDownload: $didTapDownload, goToLibrary: $goToLibrary, interactionState: $interactionState)
            }
            .onChange(of: didTapDownload, { _, newValue in
                fetchFullPackage(newValue)
                
            })
            .onChange(of: didTapSample, { _, newValue in
                playSampleQuiz(newValue)
            })
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by Name, Acronym or Category")
        }
    }
    
    private var filteredQuizzes: [AudioQuizPackage] {
        if searchText.isEmpty {
            return audioQuizCollection
        } else {
            return audioQuizCollection.filter { quiz in
                quiz.name.localizedCaseInsensitiveContains(searchText) ||
                quiz.acronym.localizedCaseInsensitiveContains(searchText) ||
                quiz.category.contains { $0.descr.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    return ExplorePage(selectedTab: .constant(2))
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
        .preferredColorScheme(.dark)
}


//#Preview {
//    ExplorePage()
//}
