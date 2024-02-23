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
    
    let categories = ExamCategory.allCases
    
    @State private var selectedTab = 0
    @State var selectedCategory: ExamCategory?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ZStack {
                    VStack(spacing: 0) {
                        CustomNavBarView(categories: categories, selectedCategory: $selectedCategory)
                        
                        // Content of your main view
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 8) {
                                ForEach(audioQuizCollection.filter { selectedCategory == nil || $0.category == selectedCategory?.rawValue }, id: \.self) { quiz in
                                    AudioQuizPackageView(quiz: quiz) {
                                        // Handle selection or action
                                    }
                                }
                            }
                        }
                        .containerRelativeFrame(.vertical)
                    }
                }
                .task {
                    await loadDefaultCollection()
                }
                .background(
                    Image("Logo")
                        //.offset(x: 230, y: -100)
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
    
    @ViewBuilder
    private func CustomNavBarView(categories: [ExamCategory], selectedCategory: Binding<ExamCategory?>) -> some View {
        HStack {
            Spacer()
            // Profile picture
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(.teal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory.wrappedValue = category
                        }) {
                            Text(category.rawValue)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(selectedCategory.wrappedValue == category ? Color.teal : Color.gray.opacity(0.2))
                                .foregroundColor(selectedCategory.wrappedValue == category ? .black : .white)
                                .cornerRadius(18)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 10.0)
                
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollTargetLayout()
        
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top, 30.0)
        .background(Color.black)
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
