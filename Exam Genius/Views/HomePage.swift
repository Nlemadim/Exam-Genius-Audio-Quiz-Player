//
//  HomePage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/5/24.
//

import SwiftUI
import SwiftData

struct HomePage:View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @StateObject var generator = ColorGenerator()
    @StateObject var questionPlayer = QuestionPlayer()
    @StateObject var keyboardObserver = KeyboardObserver()
    
    @State var interactionState: InteractionState = .idle
    
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
            .onChange(of: questionPlayer.interactionState, { _, newValue in
                updatePlayState(interactionState: newValue)
            })
            .onChange(of: didTapPlaySample, { _, newValue in
                playSampleQuiz(newValue)
            })
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)
            
            MyLibrary()
                .tabItem {
                    TabIcons(title: "Quiz player", icon: "play.circle")
                }
                .tag(1)
            
            ExploreAudioQuizView()
                .tabItem {
                    TabIcons(title: "Browse", icon: "square.grid.2x2")
                }
                .tag(2)
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor.black
            generator.updateDominantColor(fromImageNamed: backgroundImage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                updateCollections()
            }
        }
        .tint(.white).activeGlow(.white, radius: 2)
        .safeAreaInset(edge: .bottom) {
            BottomMiniPlayer()
                .opacity(keyboardObserver.isKeyboardVisible ? 0 : 1)
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private func BottomMiniPlayer() -> some View {
        // Implement the minimized version of the bottom sheet here
        ZStack {
            Rectangle()
                .fill(.clear)
                .cornerRadius(10)
                .background(.black)
                .overlay {
                    MiniPlayer(expandSheet: $expandSheet, animation: animation)
                        .offset(y: 3)
                }
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
    let playListItemFromContainer = MyPlaylistItem(from: container)
    return HomePage()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
}
    
