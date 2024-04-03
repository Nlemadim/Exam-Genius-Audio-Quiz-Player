//
//  QuizPlayerPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/14/24.
//

import SwiftUI
import SwiftData
import Combine
import AVKit


struct QuizPlayerPage: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @StateObject var generator = ColorGenerator()
    @StateObject var questionPlayer = QuestionPlayer()
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State var interactionState: InteractionState = .idle
    @State var didTapDownload = false
    @State var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var didTapPlaySample: Bool = false
    @State var isDownloadingSample: Bool = false
    @State var isPlaying: Bool = false
    @State var bottomSheetOffset = -UIScreen.main.bounds.width
    @State var selectedTab = 0
    @State var currentItem: Int = 0
    @State var backgroundImage: String = ""
    @State var selectedQuizPackage: AudioQuizPackage?
    @State var topCollectionQuizzes: [AudioQuizPackage] = []
    @State var topFreeCollection: [AudioQuizPackage] = []
    @State var topProCollection: [AudioQuizPackage] = []
    @State var topColledgeCollection: [AudioQuizPackage] = []
    @State var path = [AudioQuizPackage]()
    @State var selectedCategory: ExamCategory?
    @Namespace var animation
    
    
    let categories = ExamCategory.allCases
    let categoryOrder: [ExamCategory] = [.topProfessionalCertification, .topColledgePicks, .history, .free]
    var cancellables = Set<AnyCancellable>()
    
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
                        }
                    }
                    .zIndex(1)
                }
                .task {
                    await loadDefaultCollection()
                    updateCollections()
                    
                    generator.updateDominantColor(fromImageNamed: backgroundImage)
                    
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "person.circle")
                                .foregroundStyle(.white)
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            /// Hiding tabBar when Sheet is expended
            .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            
            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
                QuizDetailPage(audioQuiz: selectedQuiz, didTapSample: $didTapPlaySample, interactionState: $interactionState)
                
            }
            .onChange(of: didTapDownload, { _, newValue in
                if newValue {
                    
                    if let selectedQuizPackage = self.selectedQuizPackage {
                        print(selectedQuizPackage.name)
                        
                        Task {
                            // try await downloadAudioQuiz(selectedQuizPackage)
                        }
                    }
                }
            })
            .onChange(of: questionPlayer.interactionState, { _, newValue in
                updatePlayState(interactionState: newValue)
            })
            .onChange(of: didTapPlaySample, { _, newValue in
                playingSampleQuiz(didTapPlay: newValue)
            })
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)
            
            ExploreAudioQuizView()
                .tabItem {
                    TabIcons(title: "Browse", icon: "square.grid.2x2")
                }
                .tag(1)
            
            MyLibrary()
                .tabItem {
                    TabIcons(title: "Quiz player", icon: "books.vertical.fill")
                }
                .tag(2)
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor.black
            updateCollections()
            generator.updateDominantColor(fromImageNamed: backgroundImage)
            
            
        }
        .tint(.white).activeGlow(.white, radius: 2)
        .preferredColorScheme(.dark)
    }
    
    func downloadSample(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.questions.isEmpty else { return }
        DispatchQueue.main.async {
            isDownloadingSample.toggle()
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process
        let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
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
    
    private func playSample(playlist: [String]) {
        isPlaying.toggle()
        questionPlayer.playAudioQuestions(audioFileNames: playlist)
    }
    
    private func playNow(_ audioQuiz: AudioQuizPackage) {
        let playlist = audioQuiz.questions.compactMap{$0.questionAudio}
        isPlaying.toggle()
        let audioFile = playlist[0]
        questionPlayer.playSingleAudioQuestion(audioFile: audioFile)
    }
    
    private func updatePlayState(interactionState: InteractionState) {
        if interactionState == .isNowPlaying || interactionState == .isDonePlaying {
            DispatchQueue.main.async {
                self.interactionState = interactionState
            }
        }
    }
    
    func playingSampleQuiz(didTapPlay: Bool) {
        if didTapPlay {
            if let selectedQuizPackage = self.selectedQuizPackage {
                if selectedQuizPackage.questions.isEmpty {
                    Task {
                        try await downloadSample(selectedQuizPackage)
                    }
                } else {
                    playNow(selectedQuizPackage)
                }
            }
        }
    }
    
    func updateCollections() {
        let topCollection = audioQuizCollection.filter { $0.category.contains(.topCollection) }
        let topPro = audioQuizCollection.filter { $0.category.contains(.topProfessionalCertification) }
        let topColledge = audioQuizCollection.filter { $0.category.contains(.topColledgePicks) }
        DispatchQueue.main.async {
            self.topCollectionQuizzes.append(contentsOf: topCollection)
            self.topColledgeCollection.append(contentsOf: topColledge)
            self.topProCollection.append(contentsOf: topPro)
        }
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
}


#Preview {
    let container = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "BPTC-Exam")
    let user = User()
    let appState = AppState()
    let playListItemFromContainer = MyPlaylistItem(from: container)
    return QuizPlayerPage()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
}

struct BackgroundView: View {
    var backgroundImage: String
    var color: Color
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 300)
            .background(
                LinearGradient(gradient: Gradient(colors: [color, .black]), startPoint: .top, endPoint: .bottom)
            )
            .overlay {
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            .frame(height: 300)
            .blur(radius: 100)
    }
}


struct QuizCarouselView: View {
    var quizzes: [AudioQuizPackage]
    @Binding var currentItem: Int
    @ObservedObject var generator: ColorGenerator
    @Binding var backgroundImage: String
    let tapAction: () -> Void
    
    var body: some View {
        Text("Top Picks")
            .font(.headline)
            .fontWeight(.bold)
            .padding(.horizontal)
            .hAlign(.leading)
        
        TabView(selection: $currentItem) {
            ForEach(quizzes.indices, id: \.self) { index in
                let quiz = quizzes[index]
                VStack(spacing: 4) {
                    Image(quiz.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 240, height: 240)
                        .cornerRadius(10.0)
                    
                    Text(quiz.name)
                        .fontWeight(.black)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .frame(width: 180)
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                }
                .onTapGesture {
                    tapAction()
                }
                .onAppear {
                    generator.updateAllColors(fromImageNamed: quiz.imageUrl)
                    backgroundImage = quiz.imageUrl // Update background
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 380)
    }
}


struct HorizontalQuizListView: View {
    var quizzes: [AudioQuizPackage]
    var title: String
    let tapAction: (AudioQuizPackage) -> Void

    var body: some View {
        VStack(spacing: 4.0) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .hAlign(.leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8.0) {
                    ForEach(quizzes, id: \.self) { quiz in
                        ImageAndTitleView(title: quiz.name, titleImage: quiz.imageUrl, tapAction: tapAction, quiz: quiz)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}



struct ImageAndTitleView: View {
    var title: String
    var titleImage: String
    let tapAction: (AudioQuizPackage) -> Void
    var quiz: AudioQuizPackage // Assume this is passed to the view

    var body: some View {
        VStack {
            Image(titleImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 180)
                .cornerRadius(10.0)
            Text(title)
                .font(.system(size: 16))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 180)
                .padding(.horizontal, 8)
                .padding(.bottom)
        }
        .onTapGesture {
            tapAction(quiz)
        }
    }
}



struct PerformanceView: View {
    var body: some View {
        VStack {
            Text("Performance")
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .hAlign(.leading)
            
            Rectangle()
                .fill(Material.ultraThin)
                .frame(height: 220)
                .cornerRadius(20)
                .overlay {
                    ZStack {
                        Image(systemName: "chart.bar.xaxis.ascending")
                            .resizable()
                            .frame(width: 280, height: 200)
                            .opacity(0.05)
                        VStack {
                            Spacer()
                            Text("No performance history yet")
                            Spacer()
                        }
                    }
                }
        }
        .padding()
    }
}




//                                Text("Recommended listens")
//                                    .fontWeight(.bold)
//                                    .foregroundStyle(.primary)
//                                    .hAlign(.leading)
//
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)


//                            VStack(spacing: 16.0) {
//                                Text("Top collection samples")
//                                    .fontWeight(.bold)
//                                    .foregroundStyle(.primary)
//                                    .hAlign(.leading)
//
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)
//                                RelevantTopicsCard(topicName: "Swift Programming Language", quizImage: "SwiftProgramming", numberOfQuestions: 25)
//                            }
//                            .padding()
//



//                            Text("Course details")
//                                .fontWeight(.bold)
//                                .foregroundStyle(.primary)
//                                .padding(.horizontal)
//                                .hAlign(.leading)
//
//                            VStack(spacing: 8.0){
//                                LabeledContent("Total Questions", value: "\(quiz.audioCollection?.count ?? 0 )")
//                                LabeledContent("Questions Answered", value: "\(quiz.audioCollection?.count ?? 0)")
//                                LabeledContent("Quizzes Completed", value: "\(quiz.audioCollection?.count ?? 0 )")
//                                LabeledContent("Current High Score", value: "\(quiz.audioCollection?.count ?? 0)%")
//                                LabeledContent("Current High Score", value: "\(quiz.audioCollection?.count ?? 0)%")
//                            }
//                            .padding()
