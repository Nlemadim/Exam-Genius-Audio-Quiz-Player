//
//  QuizPlayerPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/14/24.
//

//import SwiftUI
//import SwiftData
//import Combine
//import AVKit
//
//
//struct QuizPlayerPage: View {
//    @Environment(\.modelContext) var modelContext
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var user: User
//    @EnvironmentObject var appState: AppState
//    
//    @StateObject var generator = ColorGenerator()
//    @StateObject var questionPlayer = QuestionPlayer()
//    
//    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
//    
//    @State var interactionState: InteractionState = .idle
//    @State var didTapDownload = false
//    @State var expandSheet: Bool = false
//    @State var isDownloading: Bool = false
//    @State var didTapPlaySample: Bool = false
//    @State var isDownloadingSample: Bool = false
//    @State var goToLibrary: Bool = false
//    @State var isPlaying: Bool = false
//    @State var bottomSheetOffset = -UIScreen.main.bounds.width
//    @State var selectedTab = 0
//    @State var currentItem: Int = 0
//    @State var backgroundImage: String = ""
//    @State var selectedQuizPackage: AudioQuizPackage?
//    @State var topCollectionQuizzes: [AudioQuizPackage] = []
//    @State var topFreeCollection: [AudioQuizPackage] = []
//    @State var topProCollection: [AudioQuizPackage] = []
//    @State var topColledgeCollection: [AudioQuizPackage] = []
//    @State var cultureAndSociety: [AudioQuizPackage] = []
//    @State var path = [AudioQuizPackage]()
//    @State var selectedCategory: ExamCategory?
//    @Namespace var animation
//    
//    let categories = ExamCategory.allCases
//    let categoryOrder: [ExamCategory] = [.topProfessionalCertification, .topColledgePicks, .history, .free]
//    var cancellables = Set<AnyCancellable>()
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            NavigationStack(path: $path) {
//                ZStack(alignment: .topLeading) {
//                    BackgroundView(backgroundImage: backgroundImage, color: generator.dominantBackgroundColor)
//                    
//                    ScrollView(showsIndicators: false) {
//                        VStack(alignment: .leading, spacing: 0) {
//                            QuizCarouselView(quizzes: topCollectionQuizzes, currentItem: $currentItem, generator: generator, backgroundImage: $backgroundImage, tapAction: {
//                                selectedQuizPackage = topCollectionQuizzes[currentItem]
//                            })
//                            
//                            HorizontalQuizListView(quizzes: topColledgeCollection, title: "Most popular in the U.S", tapAction: { quiz in
//                                selectedQuizPackage = quiz
//                            })
//                            
//                            HorizontalQuizListView(quizzes: topProCollection, title: "Top Professional Certifications", tapAction: { quiz in
//                                selectedQuizPackage = quiz
//                            })
//                            
//                            HorizontalQuizListView(quizzes: cultureAndSociety, title: "Culture And Society", subtitle: "Discover the History, Literature, Innovation of Cultures and Societies Worldwide", tapAction: { quiz in
//                                selectedQuizPackage = quiz
//                            })
//                        }
//                    }
//                    .zIndex(1)
//                }
//                .task {
//                    await loadDefaultCollection()
//            
//                    generator.updateDominantColor(fromImageNamed: backgroundImage)
//                }
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarLeading) {
//                        Button(action: {}) {
//                            Image(systemName: "person.circle")
//                                .foregroundStyle(.white)
//                        }
//                    }
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        Button(action: {}) {
//                            Image(systemName: "slider.horizontal.3")
//                                .foregroundStyle(.white)
//                        }
//                    }
//                }
//            }
//            /// Hiding tabBar when Sheet is expended
//            .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
//            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
//                QuizDetailPage(audioQuiz: selectedQuiz, didTapSample: $didTapPlaySample, didTapDownload: $didTapDownload, goToLibrary: $goToLibrary, interactionState: $interactionState)
//            }
//            .onChange(of: goToLibrary, { _, newValue in
//                goToUserLibrary(newValue)
//            })
//            .onChange(of: didTapDownload, { _, newValue in
//                fetchFullPackage(newValue)
//            })
//            .onChange(of: questionPlayer.interactionState, { _, newValue in
//                updatePlayState(interactionState: newValue)
//            })
//            .onChange(of: didTapPlaySample, { _, newValue in
//                playSampleQuiz(newValue)
//            })
//            .tabItem {
//                TabIcons(title: "Home", icon: "house.fill")
//            }
//            .tag(0)
//            
//            MyLibrary()
//                .tabItem {
//                    TabIcons(title: "Quiz player", icon: "play.circle")
//                }
//                .tag(1)
//            
//            ExploreAudioQuizView()
//                .tabItem {
//                    TabIcons(title: "Browse", icon: "square.grid.2x2")
//                }
//                .tag(2)
//        }
//        .onAppear {
//            UITabBar.appearance().barTintColor = UIColor.black
//            generator.updateDominantColor(fromImageNamed: backgroundImage)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                updateCollections()
//            }
//        }
//        .tint(.white).activeGlow(.white, radius: 2)
//        .preferredColorScheme(.dark)
//    }
//    
//    private func goToUserLibrary(_ didTap: Bool) {
//        if didTap {
//            selectedTab = 1
//        }
//    }
//    
//    private func downloadFullPackage(_ audioQuiz: AudioQuizPackage) async throws {
//        guard audioQuiz.questions.isEmpty else { return }
//        DispatchQueue.main.async {
//            self.interactionState = .isDownloading
//        }
//    
//        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
//        // Begin content building process
//        let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
//        
//        DispatchQueue.main.async {
//            audioQuiz.topics.append(contentsOf: content.topics)
//            audioQuiz.questions.append(contentsOf: content.questions)
//            user.selectedQuizPackage = audioQuiz
//            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
//            self.interactionState = .idle
//        }
//    }
//    
//    private func downloadSample(_ audioQuiz: AudioQuizPackage) async throws {
//        guard audioQuiz.questions.isEmpty else { return }
//        DispatchQueue.main.async {
//            isDownloadingSample.toggle()
//        }
//        
//        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
//        // Begin content building process
//        let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
//        print("Downloaded Sample Content: \(content)")
//        
//        DispatchQueue.main.async {
//            audioQuiz.topics.append(contentsOf: content.topics)
//            audioQuiz.questions.append(contentsOf: content.questions)
//            isDownloadingSample = false
//            let list = audioQuiz.questions
//            let playList = list.compactMap{$0.questionAudio}
//            playSample(playlist: playList)
//        }
//    }
//    
//    private func playSample(playlist: [String]) {
//        isPlaying.toggle()
//        let audioFile = playlist[0]
//        questionPlayer.playSingleAudioQuestion(audioFile: audioFile)
//    }
//    
//    private func playNow(_ audioQuiz: AudioQuizPackage) {
//        let playlist = audioQuiz.questions.compactMap{$0.questionAudio}
//        isPlaying.toggle()
//        let audioFile = playlist[0]
//        questionPlayer.playSingleAudioQuestion(audioFile: audioFile)
//    }
//    
//    private func updatePlayState(interactionState: InteractionState) {
//        if interactionState == .isNowPlaying || interactionState == .isDonePlaying {
//            DispatchQueue.main.async {
//                self.interactionState = interactionState
//            }
//        }
//    }
//    
//    func playSampleQuiz(_ didTapPlay: Bool) {
//        if didTapPlay {
//            if let selectedQuizPackage = self.selectedQuizPackage {
//                if selectedQuizPackage.questions.isEmpty {
//                    Task {
//                        try await downloadSample(selectedQuizPackage)
//                    }
//                } else {
//                    playNow(selectedQuizPackage)
//                }
//            }
//        }
//    }
//    
//    private func fetchFullPackage(_ didTapDownload: Bool) {
//        if didTapDownload {
//            if let selectedQuizPackage = self.selectedQuizPackage {
//                Task {
//                    try await downloadFullPackage(selectedQuizPackage)
//                }
//            }
//        }
//    }
//    
//    func updateCollections() {
//        let topCollection = audioQuizCollection.filter { $0.category.contains(.topCollection) }
//        let topPro = audioQuizCollection.filter { $0.category.contains(.topProfessionalCertification) }
//        let topColledge = audioQuizCollection.filter { $0.category.contains(.topColledgePicks) }
//        let cultureAndSociety = audioQuizCollection.filter { $0.category.contains(.cultureAndSociety) }
//        DispatchQueue.main.async {
//            self.topCollectionQuizzes.append(contentsOf: topCollection)
//            self.topColledgeCollection.append(contentsOf: topColledge)
//            self.topProCollection.append(contentsOf: topPro)
//            self.cultureAndSociety.append(contentsOf: cultureAndSociety)
//        }
//    }
//    
//    
//    func loadDefaultCollection() async {
//        guard audioQuizCollection.isEmpty else { return }
//        
//        let collection = DefaultDatabase().getAllExamDetails()
//        collection.forEach { examDetail in
//            
//            let newPackage = AudioQuizPackage(from: examDetail)
//            
//            modelContext.insert(newPackage)
//            
//            try! modelContext.save()
//        }
//    }
//}
//
//
//#Preview {
//    let container = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "BPTC-Exam")
//    let user = User()
//    let appState = AppState()
//    let playListItemFromContainer = MyPlaylistItem(from: container)
//    return QuizPlayerPage()
//        .environmentObject(user)
//        .environmentObject(appState)
//        .preferredColorScheme(.dark)
//        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
//}

