//
//  LandingPage.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/16/24.
//

import SwiftUI
import SwiftData

struct LandingPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @State private var path = [AudioQuizPackage]()
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    @State var topPicks: [AudioQuizPackage] = []
    @State var topFree: [AudioQuizPackage] = []
    @State var generalEducation: [AudioQuizPackage] = []
    
    @State private var selectedTab = 0
    let colors: [Color] = [.red, .green, .blue, .orange, .purple]
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ZStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Featured")
                                    .font(.title)
                                    .padding(.leading)
                                Spacer()
                            }
                            ForEach(audioQuizCollection, id: \.self) { quiz in
                                AudioQuizPackageView(quiz: quiz, downloadAction: {}, startAction: {})
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                                    .cornerRadius(30)
                                    .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollTargetLayout()
                    .containerRelativeFrame(.vertical)
                }

                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.teal)
                            .padding(.bottom, 10)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                            Text("Home")
                                .fontWeight(.bold)
                    }
                }
                .task {
                    await loadDefaultCollection()
                }
                .background(
                    Image("Logo")
                        .offset(x: 230, y: -100)
                        .blur(radius: 50)
                )
            }
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)
            
            View2()
            .tabItem {
                TabIcons(title: "Explore", icon: "magnifyingglass")
            }
            .tag(1)
            
            View2()
            .tabItem {
                TabIcons(title: "Settings", icon: "slider.horizontal.3")
            }
            .tag(1)
            
        }
        .tint(.teal)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.black
        }
    }
    
    func loadDefaultCollection() async {
        guard audioQuizCollection.isEmpty else { return }
        let collection = DefaultAudioQuizCollection.allCases
        collection.forEach { package in
            let newPackage = AudioQuizPackage(id: UUID(), name: package.rawValue, imageUrl: package.image, category: package.category)
            modelContext.insert(newPackage)
            try! modelContext.save()
        }
        
        loadTopPicks()
        loadFreeCollection()
        loadGeneralEduction()
    }
    
    private func loadTopPicks() {
        let topPickCollection = DefaultAudioQuizCollection.topPicks.map { $0.rawValue }
        let filteredTopics = audioQuizCollection.filter { topPickCollection.contains($0.name)}
        self.topPicks = filteredTopics
    }
    
    private func loadFreeCollection() {
        let topPickCollection = DefaultAudioQuizCollection.freeCollection.map { $0.rawValue }
        let filteredTopics = audioQuizCollection.filter { topPickCollection.contains($0.name)}
        self.topFree = filteredTopics
    }
    
    private func loadGeneralEduction() {
        let educationCollection = DefaultAudioQuizCollection.generalEducation.map { $0.rawValue }
        let filteredTopics = audioQuizCollection.filter { educationCollection.contains($0.name)}
        
        self.generalEducation = filteredTopics
    }
}

#Preview {
    LandingPage()
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
