//
//  Test.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/24/24.
//

import SwiftUI
import SwiftData

struct UserHomePage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @StateObject private var generator = ColorGenerator()
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State private var path = [AudioQuizPackage]()
    @State private var expandSheet: Bool = false
    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
    @State private var selectedTab = 0
    @State private var selectedQuizPackage: AudioQuizPackage? {
        didSet {
            // Automatically present and expand the bottom sheet when a quiz package is selected
            if selectedQuizPackage != nil {
                withAnimation {
                    expandSheet = true
                }
            }
        }
    }
    @State var selectedCategory: ExamCategory? {
        didSet {
            print("Category selected: \(selectedCategory?.rawValue ?? "None")")
        }
    }
    
    @Namespace private var animation
    let quizPlayer = QuizPlayer.shared
    let categories = ExamCategory.allCases
    
    var filteredAudioQuizCollection: [AudioQuizPackage] {
        audioQuizCollection.filter { quiz in
            guard let selectedCat = selectedCategory else {
                return true // Show all quizzes if no category is selected
            }
            return quiz.category.contains { $0.rawValue == selectedCat.rawValue }
        }
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                pageContent()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                ExploreAudioQuizView()
                    .tabItem {
                        Label("Explore", systemImage: "globe")
                    }
                    .tag(1)
                
                // Add more tabs as needed
            }
            .zIndex(0) // Ensures tab content is layered below the custom nav bar
            
            
            
            if expandSheet {
                bottomSheetView()
                    .offset(x: bottomSheetOffset, y: 0) // Apply the horizontal offset
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.5)) {
                            bottomSheetOffset = 0 // Move to center
                        }
                    }
                    .onDisappear {
                        bottomSheetOffset = -UIScreen.main.bounds.width // Reset when disappearing
                    }
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.black
        }
    }
    
    @ViewBuilder
    private func pageContent() -> some View {
        NavigationStack(path: $path) {
            VStack(spacing: 5) {
                customNavigationBar()
                
                
                TabView {
                    ForEach(filteredAudioQuizCollection, id: \.self) { quiz in
                        AudioQuizPackageView(quiz: quiz) 
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // Page style without index display
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                //.frame(width: 350, height: 400)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                await loadDefaultCollection()
            }
            .background(
                Image("Logo")
                    .blur(radius: 2.0, opaque: false)
                    .offset(x: 130)
            )
        }
    }
    
    @ViewBuilder
    private func customNavigationBar() -> some View {
        CustomNavigationBar2(categories: categories, selectedCategory: $selectedCategory)
        //.offset(y: -70)
    }
    
    @ViewBuilder
    private func bottomSheetView() -> some View {
        // Full implementation of your bottom sheet, including logic for minimizing and expanding
        ZStack {
            if expandSheet {
                FullScreenQuizPlayer(expandSheet: $expandSheet, animation: animation)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 1000)))
            } else {
                BottomMiniPlayer()
                    .onTapGesture {
                        withAnimation {
                            expandSheet = true
                        }
                    }
            }
        }
        .animation(.default, value: expandSheet)
        .transition(.slide)
    }
    
    @ViewBuilder
    private func BottomMiniPlayer() -> some View {
        // Implement the minimized version of the bottom sheet here
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.6))
                .frame(height: 70)
                .overlay {
                    // Content of the BottomMiniPlayer
                }
            // Add any additional overlays or components as needed
        }
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
    return  UserHomePage()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
    
}


/** message.badge.waveform
 message.badge.waveform.fill
 bubble.right.fill
 bubble.fill
 waveform
 play.desktopcomputer
 desktopcomputer.trianglebadge.exclamationmark
 desktopcomputer
 
 
 
 **/
