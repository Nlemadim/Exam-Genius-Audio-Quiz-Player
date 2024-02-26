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
    var quizPlayer = QuizPlayer()
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    @State private var path = [AudioQuizPackage]()
    
    @StateObject private var generator = ColorGenerator()
    
    @State private var expandSheet: Bool = false
    @State var conditions: [String] = ["Redeem Gift Card or Code","Privacy", "Terms and Conditons"]
    
    let categories = ExamCategory.allCases
    
    @State private var selectedTab = 0
    @State var selectedCategory: ExamCategory? {
        didSet {
            print("Category selected: \(selectedCategory?.rawValue ?? "None")")
            // Trigger the loading or filtering of your views here
        }
    }
    
    @Namespace private var animation
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ZStack {
                    VStack(spacing: 5) {
                        CustomNavBarView(categories: categories, selectedCategory: $selectedCategory)
                        /// Content main view
                        ScrollView(.vertical, showsIndicators: false) {
                                    
                            VStack(spacing: 8) {
                                ForEach(filteredAudioQuizCollection, id: \.self) { quiz in
                                    AudioQuizPackageView(quiz: quiz) {
                                        user.selectedQuizPackage = quiz
                                        print(user.selectedQuizPackage?.name ?? "Not Selected")
                                        //MARK: TODO - Handle selection or action
                                    }
                                }
                                
                                Rectangle()
                                    .fill(Material.ultraThin)
                                    .frame(height: 270)
                                    .overlay(
                                        VStack(spacing: 10) {
                                            ForEach(conditions, id: \.self) { condition in
                                                HStack {
                                                    Spacer()
                                                    NavigationLink(destination: Text(condition)) {
                                                        Text(condition)
                                                            .foregroundColor(.primary)
                                                            .padding()
                                                    }
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .padding(.horizontal)
                                                }
                                            }
                                        }
                                    )
                                    .padding(.bottom, 30)
                            }
                        }
                        .containerRelativeFrame(.vertical)
                    }
                }
                .task {
                    await loadDefaultCollection()
                }
                /// Hiding tabBar when Sheet is expended
                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
                .background(
                    Image("Logo")
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
        .safeAreaInset(edge: .bottom) {
            BottomMiniPlayer()
        }
        .overlay {
            if expandSheet {
                FullScreenQuizPlayer(expandSheet: $expandSheet, quizPlayer: quizPlayer, animation: animation)
                //Transition Animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.black
        }
    }
    
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
                                    .background(selectedCategory.wrappedValue == category ? Color.teal : .themePurpleLight.opacity(0.3))
                                    .foregroundColor(selectedCategory.wrappedValue == category ? .black : .white)
                                    .cornerRadius(18)
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
                        AudioQuizPlayer(expandSheet: $expandSheet, user: user, recordAction: {}, playPauseAction: {}, nextAction: {}, repeatAction: {}, animation: animation)

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
        .onAppear {
            generator.updateDominantColor(fromImageNamed: user.selectedQuizPackage?.imageUrl ?? "IconImage")
        }
    }
    
    
    var filteredAudioQuizCollection: [AudioQuizPackage] {
        audioQuizCollection.filter { quiz in
            guard let selectedCat = selectedCategory else {
                return true // No category selected, show all quizzes
            }
            return quiz.category.contains { $0.rawValue == selectedCat.rawValue }
        }
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
