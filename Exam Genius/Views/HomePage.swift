//
//  HomePage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/5/24.
//

import SwiftUI
import SwiftData

struct HomePage: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @EnvironmentObject var presentationManager: QuizViewPresentationManager
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    @Query(sort: \VoiceFeedbackMessages.id) var voiceFeedbackMessages: [VoiceFeedbackMessages]
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    
    @StateObject var generator = ColorGenerator()

    @StateObject var keyboardObserver = KeyboardObserver()
    @ObservedObject var libraryPlaylist = MyLibrary.LibraryPlaylist()
    
    @State var interactionState: InteractionState = .idle
    @State var myLibInteractionState: InteractionState = .idle
    
    @State var selectedQuizPackage: AudioQuizPackage?
    @State var topCollectionQuizzes: [AudioQuizPackage] = []
    @State var topFreeCollection: [AudioQuizPackage] = []
    @State var topProCollection: [AudioQuizPackage] = []
    @State var topColledgeCollection: [AudioQuizPackage] = []
    @State var cultureAndSociety: [AudioQuizPackage] = []
    @State var path = [AudioQuizPackage]()
    @State var selectedCategory: ExamCategory?
    
    @State var didTapDownload = false
    @State var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var didTapPlaySample: Bool = false
    @State var isDownloadingSample: Bool = false
    @State var goToLibrary: Bool = false
    @State var isPlaying: Bool = false
    
    @State var bottomSheetOffset = -UIScreen.main.bounds.width
    @State var selectedTab = 0
    @State var currentItem: Int = 0
    @State var backgroundImage: String = ""
    
    @Namespace var animation
    
    let categories = ExamCategory.allCases
    let categoryOrder: [ExamCategory] = [.topProfessionalCertification, .topColledgePicks, .history, .free]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                ZStack(alignment: .topLeading) {
                    BackgroundView(backgroundImage: backgroundImage, color: generator.dominantBackgroundColor)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            QuizCarouselView(quizzes: topCollectionQuizzes, currentItem: $currentItem, generator: generator, backgroundImage: $backgroundImage, tapAction: {
                                selectedQuizPackage = topCollectionQuizzes[currentItem]
                            })
                            
                            HorizontalQuizListView(quizzes: topColledgeCollection, title: "Most popular in the U.S", tapAction: { quiz in
                                selectedQuizPackage = quiz
                            })
                            
                            HorizontalQuizListView(quizzes: topProCollection, title: "Top Professional Certifications", tapAction: { quiz in
                                selectedQuizPackage = quiz
                            })
                            
                            HorizontalQuizListView(quizzes: cultureAndSociety, title: "Culture And Society", subtitle: "Discover the History, Literature, Innovation of Cultures and Societies Worldwide", tapAction: { quiz in
                                selectedQuizPackage = quiz
                            })
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 100)
                        }
                    }
                    .zIndex(1)
                }
                .task {
                    await loadDefaultCollection()
//                    await loadVoiceFeedBackMessages()
                    generator.updateDominantColor(fromImageNamed: backgroundImage)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "person.circle")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            /// Hiding tabBar when Sheet is expended
            .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
                QuizDetailPage(audioQuiz: selectedQuiz, didTapSample: $didTapPlaySample, didTapDownload: $didTapDownload, goToLibrary: $goToLibrary, interactionState: $interactionState)
            }
            
            .onChange(of: goToLibrary, { _, newValue in
                goToUserLibrary(newValue)
            })
            .onChange(of: didTapDownload, { _, newValue in
                fetchFullPackage(newValue)
                
            })
            .onChange(of: downloadedAudioQuizCollection, { _, _ in
                //loadUserQuiz()
            })
            .onChange(of: didTapPlaySample, { _, newValue in
                playSampleQuiz(newValue)
            })
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)

            QuizPlayerView()
                .tabItem {
                    TabIcons(title: "Quiz player", icon: "play.circle")
                }
                .tag(1)
            
            ExplorePage(selectedTab: $selectedTab)
                .tabItem {
                    TabIcons(title: "Browse", icon: "square.grid.2x2")
                }
                .tag(2)
            
            LibraryPage()
                .tabItem {
                    TabIcons(title: "My Library", icon: "books.vertical.fill")
                }
                .tag(3)
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor.black
            generator.updateDominantColor(fromImageNamed: backgroundImage)
            updateCollections()
            navigateToPlayer()
        }
        .tint(.white).activeGlow(.white, radius: 2)
        .safeAreaInset(edge: .bottom) {
            BottomMiniPlayer()
                .opacity(keyboardObserver.isKeyboardVisible ? 0 : 1)
        }
        .preferredColorScheme(.dark)
    }
    
    private func navigateToPlayer() {
        if downloadedAudioQuizCollection.isEmpty {
            return
        } else {
            selectedTab = 1
        }
    }
    
//    private func laodNewAudioQuiz(quiz package: AudioQuizPackage) async  {
//        
//        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) else { return }
//        
//        DispatchQueue.main.async {
//            self.interactionState = .isDownloading
//        }
//        
//        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
//       
//        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: package.name, shortTitle: package.acronym, quizImage: package.imageUrl)
//        
//        let audioQuestions = package.questions
//        
//        await contentBuilder.downloadAudioQuestions(for: audioQuestions)
//        
//        newDownloadedQuiz.questions = audioQuestions
//        self.downloadedAudioQuiz = newDownloadedQuiz
//        
//        modelContext.insert(newDownloadedQuiz)
//        try! modelContext.save()
//        
//        DispatchQueue.main.async {
//            user.downloadedQuiz = self.downloadedAudioQuiz
//            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
//            self.interactionState = .idle
//        }
//    }
    
    @ViewBuilder
    private func BottomMiniPlayer() -> some View {
        
        ZStack {
            Rectangle()
                .fill(.clear)
                .cornerRadius(10)
                .background(LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black, .black]), startPoint: .top, endPoint: .bottom))
                .overlay {
                    MiniPlayerV2(selectedQuizPackage: $user.downloadedQuiz, feedbackMessageUrls: .constant(getFeedBackMessages()), interactionState: $interactionState, startPlaying: $isPlaying)
                        .padding(.bottom)
                }
        }
        .onAppear {
            generator.updateAllColors(fromImageNamed: user.downloadedQuiz?.quizImage ?? "Logo")
        }
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.teal.opacity(0.3))
                .frame(height: 1)
                .offset(y: -3)
        })
        .frame(height: 70)
        .offset(y: -49)
    }
}


#Preview {
    let container = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "BPTC-Exam")
    let user = User()
    let appState = AppState()
    let observer = QuizPlayerObserver()
    let presentMgr = QuizViewPresentationManager()
    return HomePage()
        .environmentObject(user)
        .environmentObject(appState)
        .environmentObject(observer)
        .environmentObject(presentMgr)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self, VoiceFeedbackMessages.self, DownloadedAudioQuiz.self], inMemory: true)
}
    
