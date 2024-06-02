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
    @State private var quizName = UserDefaultsManager.quizName()
    @State var interactionState: InteractionState = .idle
    @State var selectedQuizPackage: AudioQuizPackage?
    @State var downloadedAudioQuiz: DownloadedAudioQuiz?
    @State var downloadFullPackage: Bool = false
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
                QuizDetailPage(audioQuiz: selectedQuiz)
            }
            .onChange(of: user.selectedQuizPackage, { _, audioQuiz in
                if let audioQuiz = audioQuiz {
                    Task {
                        print("Loading audio Questions")
                        await laodNewAudioQuiz(quiz: audioQuiz)
                    }
                }
            })
            .onChange(of: didTapDownload, { _, download in
                print(download)
                if download {
                    guard let selectePackage = self.selectedQuizPackage, selectePackage.questions.isEmpty else {
                        navigateToPlayer(true)
                        return
                    }
                    Task {
                        await fetchFullPackage()
                    }
                }
            })
            .onChange(of: didTapSample, { _, newValue in
                playSampleQuiz(newValue)
            })
            .onChange(of: didTapSample, { _, newValue in
                playSampleQuiz(newValue)
            })
            .onChange(of: goToLibrary, { _, newValue in
                print(newValue)
                navigateToPlayer(newValue)
            })
            .onChange(of: downloadFullPackage, { _, download in
                if download {
                    Task {
                       try await downloadBasicPackage()
                    }
                }
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
    
    private func navigateToPlayer(_ navigate: Bool) {
        if navigate {
            if let newQuiz = downloadedAudioQuizCollection.first(where: {$0.quizname == self.quizName}) {
                DispatchQueue.main.async {
                    user.downloadedQuiz = newQuiz
                    user.selectedQuizPackage = self.selectedQuizPackage
                    UserDefaultsManager.setQuizName(quizName: newQuiz.quizname)
                    self.selectedTab = 1
                }
            }
        }
    }
    
    func laodNewAudioQuiz(quiz package: AudioQuizPackage) async  {
        
        // Check if the package name already exists in the downloaded collection
        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) else { return }
        
        DispatchQueue.main.async {
            print("Creating New Audio Quiz")
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: package.name, shortTitle: package.acronym, quizImage: package.imageUrl)
        let audioQuestions = package.questions
        
        await contentBuilder.downloadAudioQuestions(for: audioQuestions)
        newDownloadedQuiz.questions = audioQuestions
        
        modelContext.insert(newDownloadedQuiz)
        try! modelContext.save()
        
        DispatchQueue.main.async {
            user.downloadedQuiz = newDownloadedQuiz
            UserDefaultsManager.setQuizName(quizName: newDownloadedQuiz.quizname)
            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
            self.interactionState = .idle
            
        }
    }
    
    private func downloadBasicPackage() async throws {
        print("Downloading Complete Package")
        guard let audioQuiz = audioQuizCollection.first(where: { $0.name == self.quizName }) else {
            print("Package Not Found")
            return // Exit if audioQuiz is not found
        }
        
        guard audioQuiz.questions.count <= 300 else {
            return // Exit if there are too many questions in audioQuiz
        }
        
        DispatchQueue.main.async {
            self.interactionState = .isDownloading
            print("Starting complete download process")
        }
       
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        let content = try await contentBuilder.buildCompletePackage(examName: audioQuiz.name, topics: audioQuiz.topics)
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            self.downloadFullPackage = false
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
