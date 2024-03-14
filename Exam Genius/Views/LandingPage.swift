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
    let quizPlayer = QuizPlayer.shared
    let viewModel = LandingPageViewModel()
    
    @StateObject private var generator = ColorGenerator()
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
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
//            Task {
//                try await playSampleQuiz(quiz)
//            }
            guard let selectedCat = selectedCategory else {
                return true // No category selected, show all quizzes
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
                                            Task {
                                               // try await buildContentOnly(quiz)
                                            }
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
//            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
//                AudioQuizDetailView(audioQuiz: selectedQuiz, isDownloading: $isDownloading)
//            }
            
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)
            
            ExploreAudioQuizView()
                .tabItem {
                    TabIcons(title: "Explore", icon: "globe")
                }
                .tag(1)
            
            SettingsPage()
                .tabItem {
                    TabIcons(title: "Settings", icon: "slider.horizontal.3")
                }
                .tag(1)
        }
        .tint(.teal)
        .safeAreaInset(edge: .bottom) {
           // BottomMiniPlayer()

        }
        .overlay {
            if expandSheet {
                FullScreenQuizPlayer(expandSheet: $expandSheet, animation: animation)
                //Transition Animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.black
        }
    }
    
    
    private func buildContentFromVm(audioQuiz: AudioQuizPackage) {
        let viewModel = AudioQuizDetailView.AudioQuizDetailVM(audioQuiz: audioQuiz)
        viewModel.buildAudioQuizContent(name: audioQuiz)
    }
    
    private func buildContentOnly(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.topics.isEmpty && audioQuiz.questions.isEmpty else {
            return }
        DispatchQueue.main.async {
            self.isDownloading = true
        }
        
        let sampleCollection = audioQuiz.questions
        if sampleCollection.isEmpty {
            let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
            // Begin content building process
            let content = try await contentBuilder.buildContent(for: audioQuiz.name)
            
            // Once content is built, update the main thread with new data
            DispatchQueue.main.async {
                audioQuiz.questions = content.questions.map { question in
                    Question(id: UUID(), questionContent: question.questionContent, questionNote: "", topic: question.topic, options: question.options, correctOption: question.correctOption, selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: question.questionAudio, questionNoteAudio: "")}
                audioQuiz.topics = content.topics.map { Topic(name: $0.name) }
                self.isDownloading = false
            }
        } else {
            DispatchQueue.main.async {
                self.isDownloading = false
                
            }
        }
    }
    
    private func playSampleQuiz(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.topics.isEmpty && audioQuiz.questions.isEmpty else {
//            let playlist = audioQuiz.questions.compactMap{$0.questionAudio}
//            quizPlayer.playSampleQuiz(audioFileNames: playlist)
            return
        }
        DispatchQueue.main.async {
            self.isDownloading = true
        }
        
        var sampleCollection = audioQuiz.questions.compactMap { $0.questionAudio }
        if sampleCollection.isEmpty {
            let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
            // Begin content building process
            let content = try await contentBuilder.buildContent(for: audioQuiz.name)
            
            // Once content is built, update the main thread with new data
            DispatchQueue.main.async {
                audioQuiz.questions = content.questions.map { question in
                    Question(id: UUID(), questionContent: question.questionContent, questionNote: "", topic: question.topic, options: question.options, correctOption: question.correctOption, selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: question.questionAudio, questionNoteAudio: "")}
                audioQuiz.topics = content.topics.map { Topic(name: $0.name) }
                
                sampleCollection = audioQuiz.questions.compactMap { $0.questionAudio }
                
                // After updating sampleCollection, check again if it's not empty
                if !sampleCollection.isEmpty {
                    // Set downloading to false before beginning playback
                    self.isDownloading = false
                    self.isPlaying = true
                    // Play the audio without additional delay as it's now handled within the player
                   //quizPlayer.playSampleQuiz(audioFileNames: sampleCollection)
                    //self.isPlaying = quizPlayer.isFinishedPlaying
                    //viewModel.monitorPlaybackCompletion()
                } else {
                    // Handle case with no downloadable content
                    self.isDownloading = false
                    // Implement UI feedback for no content available
                }
            }
        } else {
            // If there are already audio files available, play them without fetching content
            DispatchQueue.main.async {
                self.isDownloading = false
                self.isPlaying = true
                // Play the audio without additional delay
                //quizPlayer.playSampleQuiz(audioFileNames: sampleCollection)
                //viewModel.monitorPlaybackCompletion()
            }
        }
    }

    
    //MARK TODO:
    // Handle the case where there are still no audio files to play
    // Update the UI to indicate that downloading has failed or no content is available
    // Perhaps show an error message or alter the UI accordingly
    
//    private func playSampleQuiz(_ audioQuiz: AudioQuizPackage) async {
//        self.isDownloading.toggle()
//        var sampleCollection = audioQuiz.questions.map{ $0.questionAudio }
//        if !sampleCollection.isEmpty {
//            self.isDownloading.toggle()
//            self.isPlaying.toggle()
//            quizPlayer.playSampleQuiz(audioFileNames: sampleCollection)
//
//        } else {
//            self.isDownloading.toggle()
//            let content = await viewModel.buildSampleContent(examName: audioQuiz)
//            
//            audioQuiz.questions = content.questions.map { Question(from: $0) }
//            audioQuiz.topics = content.topics.map { Topic(name: $0) }
//            sampleCollection = audioQuiz.questions.map{ $0.questionAudio }
//            self.isDownloading.toggle()
//            self.isPlaying.toggle()
//            quizPlayer.playSampleQuiz(audioFileNames: sampleCollection)
//        }
//    }
    
    @ViewBuilder
    private func CustomNavBarView(categories: [ExamCategory], selectedCategory: Binding<ExamCategory?>) -> some View {
        HStack {
            Spacer()
            // Profile picture
            HStack(alignment: .bottom) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.teal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                print("Category selected: \(category.rawValue)")
                                selectedCategory.wrappedValue = category
                            }) {
                                Text(category.rawValue)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(LinearGradient(gradient: Gradient(colors: [.themePurpleLight, .themePurple]), startPoint: .top, endPoint: .bottom))
                                    .foregroundStyle(.white)
                                    .cornerRadius(18)
                                    .opacity(selectedCategory.wrappedValue == category ? 1 : 0)
                            }
                            .shadow(color: .teal, radius: 1)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 25.0)
                    .padding(.horizontal)
                    
                }
                .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                .scrollTargetLayout()
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top, 30.0)
        .background(.black)
    }
    
    @ViewBuilder
    func BottomMiniPlayer() -> some View {
        ///Animating Sheet bnackground
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.black.opacity(0.6))
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                    )
                    .overlay {
                        AudioQuizPlayer(expandSheet: $expandSheet, animation: animation)
                        
                    }
                    .matchedGeometryEffect(id: "MAINICON", in: animation)
            }
        }
        .frame(height: 70)
        ///Seperator LIne
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.teal.opacity(0.3))
                .frame(height: 1)
                .offset(y: -5)
        })
        ///Default Height set to 49
        .offset(y: -49)
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
            //print(newPackage.category)
            
            modelContext.insert(newPackage)
            try! modelContext.save()
        }
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    var quizBuilder = AudioQuizPlaylistView.QuizBuilder()
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


/**
 
 Mark: BottomSheet Optional Display Logic
 //            if playerReady {
 //                BottomMiniPlayer()
 //                    .offset(x: bottomSheetOffset, y: 0)
 //                    .onAppear {
 //                        withAnimation(.easeOut(duration: 0.5)) {
 //                            bottomSheetOffset = 0 // Move to center
 //                        }
 //                    }
 //                    .onDisappear {
 //                        bottomSheetOffset = -UIScreen.main.bounds.width // Reset when disappearing
 //                    }
 //            }
 
 */
