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
    @EnvironmentObject var errorManager: ErrorManager
    @ObservedObject var connectionMonitor = ConnectionMonitor()
    
    let quizPlayerObserverV2 = QuizPlayerObserverV2()
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @Query(sort: \VoiceFeedbackMessages.id) var voiceFeedbackMessages: [VoiceFeedbackMessages]
    
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    
    @StateObject var generator = ColorGenerator()

    @StateObject var keyboardObserver = KeyboardObserver()
    @ObservedObject var libraryPlaylist = MyLibrary.LibraryPlaylist()
    
    @State var interactionState: InteractionState = .idle
    @State var myLibInteractionState: InteractionState = .idle
    @State var defaultQuestionCount = UserDefaultsManager.numberOfTestQuestions()
    @State var quizName = UserDefaultsManager.quizName()
    
    
    @State var selectedQuizPackage: AudioQuizPackage?
    @State var topCollectionQuizzes: [AudioQuizPackage] = []
    @State var topFreeCollection: [AudioQuizPackage] = []
    @State var topProCollection: [AudioQuizPackage] = []
    @State var topColledgeCollection: [AudioQuizPackage] = []
    @State var cultureAndSociety: [AudioQuizPackage] = []
    @State var path = [AudioQuizPackage]()
    @State var selectedCategory: ExamCategory?
    @State var downloadedAudioQuiz: DownloadedAudioQuiz?
    
    @State var didTapDownload = false
    @State var didTapEdit = false
    @State var refreshAudioQuiz = false
    @State var expandSheet: Bool = false
    @State var showSettings: Bool = false
    @State var isDownloading: Bool = false
    @State var didTapPlaySample: Bool = false
    @State var isDownloadingSample: Bool = false
    @State var goToLibrary: Bool = false
    @State var downloadFullPackage: Bool = false
    @State var isPlaying: Bool = false
    @State var presentFullVersionModal: Bool = false
    
    @State var bottomSheetOffset = -UIScreen.main.bounds.width
    @State var selectedTab = 0
    @State var currentItem: Int = 0
    @State var backgroundImage: String = ""
    @State var themeColor: Color = .themePurple
    @State var themeSubColor: Color = .teal
    
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
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "person.circle")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Text("VOQA")
                            .font(.title)
                            .fontWeight(.black)
                            .kerning(-0.5)
                            .primaryTextStyleForeground()
                            
                    }
                    
                    ToolbarItemGroup(placement: .topBarLeading) {
                        ConnectionErrorText(errorMessage: "No internet connection")
                            .opacity(!connectionMonitor.isConnected ? 1 : 0)
                    }
                }
            }
            /// Hiding tabBar when Sheet is expended
            .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            .onAppear {
                UITabBar.appearance().barTintColor = UIColor.black
                self.selectedTab = 0
                generator.updateDominantColor(fromImageNamed: user.selectedQuizPackage?.imageUrl ?? "Logo")
                self.quizPlayerObserver.themeColor = generator.dominantBackgroundColor
                updateThemeColor()
                self.themeSubColor = generator.dominantLightToneColor
                checkUserPacketAvailability()
                updateCollections()
                packetStatusPrintOut()
                loadUserDetails()
            }
            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
                QuizDetailPage(audioQuiz: selectedQuiz, selectedTab: $selectedTab)
            }
            .onChange(of: user.downloadedQuiz, { _, newValue in
                if let value = newValue {
                    DispatchQueue.main.async {
                        generator.updateAllColors(fromImageNamed: value.quizImage)
                        quizPlayerObserver.themeColor = generator.dominantBackgroundColor
                        updateThemeColor()
                    }
                }
            })
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)

            QuizPlayerView(selectedTab: $selectedTab)
                .tabItem {
                    TabIcons(title: "Quiz player", icon: "play.circle")
                }
                .tag(1)
            
            ExplorePage(selectedTab: $selectedTab)
                .tabItem {
                    TabIcons(title: "Browse", icon: "square.grid.2x2")
                }
                .tag(2)
            
            LibraryPage(selectedQuizPackage: $user.selectedQuizPackage, didTapEdit: $didTapEdit)
                .tabItem {
                    TabIcons(title: "My Library", icon: "books.vertical.fill")
                }
                .tag(3)
        }
        
        .tint(.white).activeGlow(.white, radius: 2)
        .safeAreaInset(edge: .bottom) {
            BottomMiniPlayer(color: generator.dominantBackgroundColor)
                .opacity(keyboardObserver.isKeyboardVisible || didTapEdit ? 0 : 1)
                .onAppear {
                    generator.updateAllColors(fromImageNamed: user.downloadedQuiz?.quizImage ?? "Logo")
                }
        }
        .preferredColorScheme(.dark)
    }
    
    
    private func checkUserPacketAvailability() {
        if let userQuiz = user.selectedQuizPackage {
            print("HomePage has assigned userPacket: \(userQuiz.name)")
            
            if let currentQuiz = audioQuizCollection.first(where: {$0.name == userQuiz.name}), currentQuiz.questions.count >= 50  {
                presentFullVersionModal = false
                UserDefaultsManager.updateHasDownloadedFullVersion(true, for: userQuiz.name)
            } else {
                DispatchQueue.main.async {
                    self.selectedQuizPackage = userQuiz
                    presentFullVersionModal = true
                }
            }
        }
    }
    
    private func navigateToPlayer() {
        if downloadedAudioQuizCollection.isEmpty {
            return
        } else {
            let userPacket = downloadedAudioQuizCollection.first(where: {$0.quizname == self.quizName})
            let hasFullVersion =  UserDefaultsManager.hasFullVersion(for: userPacket?.quizname ?? "UnKnown") ?? false
            if hasFullVersion {
                user.downloadedQuiz = userPacket
            }
        }
    }
    
    private func updateThemeColor() {
        DispatchQueue.main.async {
            self.themeColor = quizPlayerObserver.themeColor
        }
    }

    @ViewBuilder
    private func BottomMiniPlayer(color: Color) -> some View {
        
        ZStack {
            Rectangle()
                .fill(.clear)
                .cornerRadius(10)
                .background(LinearGradient(gradient: Gradient(colors: [color, .black, .black]), startPoint: .top, endPoint: .bottom))
                .overlay {
                    MiniPlayerV2(selectedQuizPackage: $user.downloadedQuiz, feedbackMessageUrls: .constant(getFeedBackMessages()), interactionState: $interactionState, refreshQuiz: $refreshAudioQuiz)
                        .padding(.bottom)
                }
        }
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.teal.opacity(0.3))
                .frame(height: 1)
                .offset(y: -3)
        })
        .frame(height: 75)
        .offset(y: -49)
    }
}


#Preview {
    let errorManager = ErrorManager()
    let monitor = ConnectionMonitor(forTesting: true)
    let user = User()
    let appState = AppState()
    let observer = QuizPlayerObserver()
    let presentMgr = QuizViewPresentationManager()
    return HomePage()
        .environmentObject(user)
        .environmentObject(appState)
        .environmentObject(observer)
        .environmentObject(presentMgr)
        .environmentObject(errorManager)
        .environmentObject(monitor)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self, VoiceFeedbackMessages.self, DownloadedAudioQuiz.self], inMemory: true)
        .onAppear {
            // You can further manipulate the connection status here if needed
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                monitor.simulateDisconnection() // Simulate reconnection after 5 seconds
            }
        }
}
    
