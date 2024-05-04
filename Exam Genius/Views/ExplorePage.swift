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
    @State var downloadedAudioQuiz: DownloadedAudioQuiz?
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
            .onChange(of: user.selectedQuizPackage, { _, audioQuiz in
                if let audioQuiz = audioQuiz {
                    Task {
                        print("Loading audio Questions")
                        await laodNewAudioQuiz(quiz: audioQuiz)
                    }
                }
            })
            .onChange(of: didTapDownload, { _, _ in
                if let selectePackage = self.selectedQuizPackage, !selectePackage.questions.isEmpty {
                    user.selectedQuizPackage = self.selectedQuizPackage
                    selectedTab = 1
                } else {
                    Task {
                        await fetchFullPackage()
                    }
                }
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
    
    func laodNewAudioQuiz(quiz package: AudioQuizPackage) async  {
        
        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) else { return }
        
        DispatchQueue.main.async {
            self.interactionState = .isDownloading
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
       
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: package.name, shortTitle: package.acronym, quizImage: package.imageUrl)
        
        let audioQuestions = package.questions
        
        await contentBuilder.downloadAudioQuestions(for: audioQuestions)
        
        newDownloadedQuiz.questions = audioQuestions
        self.downloadedAudioQuiz = newDownloadedQuiz
        
        modelContext.insert(newDownloadedQuiz)
        try! modelContext.save()
        
        DispatchQueue.main.async {
            user.downloadedQuiz = self.downloadedAudioQuiz
            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
            self.interactionState = .idle
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
