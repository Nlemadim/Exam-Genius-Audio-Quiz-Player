//
//  LandingPage.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/16/24.
//

import SwiftUI
import SwiftData
import Combine

struct LandingPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @ObservedObject var quizPlayer = QuizPlayer.shared
    
    @StateObject private var generator = ColorGenerator()
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State private var didTapDownload = false
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var didTapPlaySample: Bool = false
    @State var isDownloadingSample: Bool = false
    @State private var isPlaying: Bool = false
    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
    @State private var selectedTab = 0
    @State private var selectedQuizPackage: AudioQuizPackage?
    @State private var path = [AudioQuizPackage]()
    @State var selectedCategory: ExamCategory?
    private var cancellables = Set<AnyCancellable>()
    
    @Namespace private var animation
    
    let categories = ExamCategory.allCases
    
    var filteredAudioQuizCollection: [AudioQuizPackage] {
        audioQuizCollection.filter { quiz in

            guard let selectedCat = selectedCategory else {
                return true
            }
            return quiz.category.contains { $0.rawValue == selectedCat.rawValue }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                ZStack {
                    VStack(spacing: 5) {
                        CustomNavigationBar(categories: categories, selectedCategory: $selectedCategory)
                        /// Content main view
                        ScrollView(.vertical, showsIndicators: false) {
                        
                            VStack(spacing: 10) {
                                ForEach(filteredAudioQuizCollection, id: \.self) { quiz in
                                    AudioQuizPackageView(quiz: quiz)
                                        .onTapGesture {
                                            selectedQuizPackage = quiz
                                        }
                                }
                                
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .containerRelativeFrame(.vertical)
                        .scrollTargetLayout()
                        .scrollTargetBehavior(.viewAligned)
                    }
                }
                .onReceive(quizPlayer.$isNowPlaying, perform: { isNowPlayng in
                    self.isPlaying = isNowPlayng
                    print("Landing screen has registered isPlaying as: \(isPlaying)")
                })
                .task {
                    await loadDefaultCollection()
                }
                /// Hiding tabBar when Sheet is expended
                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
                .background(
                    Image("Logo")
                        .offset(y: 40)
                )
            }
            
            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
                AudioQuizDetailView(audioQuiz: selectedQuiz, isDownloading: $isDownloading, didTapDownload: $didTapDownload, isNowPlaying: $isPlaying, isDownloadingSample: $isDownloadingSample, didTapPlaySample: $didTapPlaySample)
            }
            .onChange(of: didTapDownload, { _, newValue in
                if newValue {
                    
                    if let selectedQuizPackage = self.selectedQuizPackage {
                        
                        Task {
                            try await downloadAudioQuiz(selectedQuizPackage)
                        }
                    }
                }
            })
            .onChange(of: didTapPlaySample, { _, newValue in
                if newValue {
                    
                    if let selectedQuizPackage = self.selectedQuizPackage {
                        
                        Task {
                            try await downloadSample(selectedQuizPackage)
                        }
                    }
                }
            })
            
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)

            QuizPlayerView()
                .tabItem {
                    TabIcons(title: "Explore", icon: "globe")
                }
                .tag(1)
            
            SettingsPage()
                .tabItem {
                    TabIcons(title: "Settings", icon: "slider.horizontal.3")
                }
                .tag(2)
        }
        .tint(.teal)

    }
    
    
    private func buildContentFromVm(audioQuiz: AudioQuizPackage) {
        let viewModel = AudioQuizDetailView.AudioQuizDetailVM(audioQuiz: audioQuiz)
        viewModel.buildAudioQuizContent(name: audioQuiz)
    }
    
    func audioQuizContainer(quizName: String, quizImage: String) -> DownloadedAudioQuizContainer {
        let container = DownloadedAudioQuizContainer(name: quizName, quizImage: quizImage)
        return container
    }
    
    func groupQuizzesByCombinedCategories(quizzes: [AudioQuizPackage], combinedCategories: [CombinedCategory]) -> [CombinedCategory: [AudioQuizPackage]] {
        var groupedQuizzes = [CombinedCategory: [AudioQuizPackage]]()
        
        combinedCategories.forEach { combinedCategory in
            let filteredQuizzes = quizzes.filter { quiz in
                // Check if the quiz's categories intersect with the combined category's included categories
                !quiz.category.filter { combinedCategory.includedCategories.contains($0) }.isEmpty
            }
            groupedQuizzes[combinedCategory] = filteredQuizzes
        }
        
        return groupedQuizzes
    }
    
    func loadDefaultCollection() async {
        guard audioQuizCollection.isEmpty else { return }
        
        let collection = DefaultDatabase().getAllExamDetails()
        collection.forEach { examDetail in
            
            let newPackage = AudioQuizPackage(from: examDetail)

            modelContext.insert(newPackage)
            try! modelContext.save()
        }
    }
    
    func playSampleContent() {
        if let package = selectedQuizPackage, selectedQuizPackage?.questions == nil {
            Task {
                try await downloadSample(package)
            }
        } else {
            let list = selectedQuizPackage?.questions
            let playList = list?.compactMap{$0.questionAudio}
            playSample(playlist: playList ?? [])
        }
    }
    
    func downloadSample(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.questions.isEmpty else { return }
        DispatchQueue.main.async {
            isDownloadingSample.toggle()
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process
        let content = try await contentBuilder.alternateBuildTestContent(for: audioQuiz.name)
        print("Downloaded Detail Page Content: \(content)")
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            isDownloadingSample = false
            let list = audioQuiz.questions
            let playList = list.compactMap{$0.questionAudio}
            playSample(playlist: playList)
            
        }
    }
    
    func playSample(playlist: [String]) {
        isPlaying.toggle()
        quizPlayer.playSampleQuiz(audioFileNames: playlist)
    }
    
    func downloadAudioQuiz(_ audioQuiz: AudioQuizPackage) async throws {
        DispatchQueue.main.async {
            isDownloading.toggle()
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process
        let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
        print("Downloaded Detail Page Content: \(content)")
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            selectedTab = 1
            isDownloading = false
            selectedQuizPackage = nil
        }
    }
    
    func updatePacketStatus() {
        if let selectedQuizPackage {
            let questionCount = selectedQuizPackage.questions.count
            let topicsCount = selectedQuizPackage.questions.count
            print("\(questionCount) questions saved")
            print("\(topicsCount) topics saved")
        }
        print("Selected Quiz Package is Nil")
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    return  LandingPage()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
    
}


struct View2: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            VStack {
                Image(systemName: "globe")
                Text("Work in Progress")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(alignment: .topLeading)
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .background(
            Image("Logo")
                .offset(x:  220, y: +230)
                .blur(radius: 30)
        )
    }
}


