//
//  ExploreAudioQuizView.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 2/9/24.
//

import SwiftUI
import SwiftData


struct ExploreAudioQuizView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State var interactionState: InteractionState = .idle
    @State var selectedQuizPackage: AudioQuizPackage?
    @State private var searchText = ""
    @Binding var didTapSample: Bool
    @Binding var didTapDownload: Bool
    @Binding var goToLibrary: Bool
    
    private let networkService: NetworkService = NetworkService.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(filteredQuizzes, id: \.self) { quiz in
                                let quizItem = MyPlaylistItem(from: quiz)
                                AudQuizCardViewMid(quiz: quizItem)
                                    .onTapGesture {
                                        self.selectedQuizPackage = quiz
                                    }
                            }
                        }
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
                QuizDetailPage(audioQuiz: selectedQuiz, didTapSample: $didTapSample, didTapDownload: $didTapDownload, goToLibrary: $goToLibrary, interactionState: $interactionState)
            }
            .onChange(of: didTapDownload, { _, startDownload in
                if startDownload {
                    getOrGoToQuiz()
                }
            })
            .onChange(of: goToLibrary, { _, goToLibrary in
                if goToLibrary {
                    getOrGoToQuiz()
                }
            })
            .onChange(of: didTapSample, { _, playSample in
                if playSample {
                    playSampleQuestion()
                }
            })
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by Name, Acronym or Category")
        }
    }
    
    private var filteredQuizzes: [AudioQuizPackage] {
        if searchText.isEmpty {
            return audioQuizCollection
        } else {
            return audioQuizCollection.filter { quiz in
                quiz.name.localizedCaseInsensitiveContains(searchText) ||
                quiz.acronym.localizedCaseInsensitiveContains(searchText) ||
                quiz.category.contains { $0.descr.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    private func getOrGoToQuiz() {
        guard let package = selectedQuizPackage, package.questions.isEmpty else {
            goToLibrary = true
            return
        }
        
        self.didTapDownload = true
    }
    
    private func playSampleQuestion() {
        self.didTapSample = true
    }
}

struct ExploreAudioQuizViewV2: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State var interactionState: InteractionState = .idle
    @State var selectedQuizPackage: AudioQuizPackage?
    @State private var searchText = ""
    @Binding var didTapSample: Bool
    @Binding var didTapDownload: Bool
    @Binding var goToLibrary: Bool
   
    
    private let networkService: NetworkService = NetworkService.shared
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var filteredQuizzes: [String: [AudioQuizPackage]] {
        if searchText.isEmpty {
            // Return all quizzes grouped by category if there is no search text.
            return Dictionary(grouping: audioQuizCollection, by: { $0.category.first?.descr ?? "Uncategorized" })
        } else {
            let lowercasedSearchText = searchText.lowercased()
            // Return only quizzes that match the search criteria when search text is not empty.
            return Dictionary(grouping: audioQuizCollection.filter {
                $0.name.lowercased().contains(lowercasedSearchText) ||
                $0.category.contains(where: { $0.descr.lowercased().contains(lowercasedSearchText) })
            }, by: { $0.category.first?.descr ?? "Uncategorized" })
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, pinnedViews: .sectionHeaders) {
                    ForEach(filteredQuizzes.keys.sorted(), id: \.self) { key in
                        Section {
                            ForEach(filteredQuizzes[key] ?? [], id: \.self) { quiz in
                                let quizItem = MyPlaylistItem(from: quiz)
                                AudQuizCardViewMid(quiz: quizItem)
                                    .onTapGesture {
                                        self.selectedQuizPackage = quiz
                                    }
                            }
                        } header: {
                            Text(key)
                                .font(.headline)
                                .hAlign(.leading)
                        }
                        
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
                .scrollTargetLayout()
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            //.scrollTargetBehavior(.viewAligned)
            .fullScreenCover(item: $selectedQuizPackage) { selectedQuiz in
                QuizDetailPage(audioQuiz: selectedQuiz, didTapSample: $didTapSample, didTapDownload: $didTapDownload, goToLibrary: $goToLibrary, interactionState: $interactionState)
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}




//#Preview {
//    let user = User()
//    let appState = AppState()
//    return ExploreAudioQuizViewV2(didTapSample: .constant(false), didTapDownload: .constant(false), goToLibrary: .constant(false))
//        .environmentObject(user)
//        .environmentObject(appState)
//        .preferredColorScheme(.dark)
//        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
//        .preferredColorScheme(.dark)
//}


/**
 
 // Complete Collection Section
 Text("Full Collection")
 .font(.headline)
 .padding(.leading)
 
 
 
 LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
 // Display actual items
 ForEach(audioQuizCollection, id: \.self) { quiz in
 AudioQuizSearchCollectionView(quiz: quiz)
 }
 
 }
 .scrollTargetBehavior(.viewAligned)
 .contentMargins(20, for: .scrollContent)
 
 
 ZStack {
 ScrollView {
 VStack(alignment: .leading, spacing: 20) {
 // Sample Collection Section
 Text("Sample Collection")
 .font(.headline)
 .padding(.leading)
 
 ScrollView(.horizontal, showsIndicators: false) {
 LazyHGrid(rows: [GridItem(.fixed(200))], spacing: 20) {
 ForEach(FeaturedQuiz.allCases.prefix(5), id: \.self) { quiz in // Assuming 'FeaturedQuiz' is a placeholder
 AudioQuizView(quiz: quiz) // Assuming this view takes a quiz and displays it
 .frame(width: 180, height: 260)
 }
 }
 .padding(.horizontal)
 }
 
 // Complete Collection Section
 Text("Full Collection")
 .font(.headline)
 .padding(.leading)
 
 // Dynamically calculate placeholders to display based on actual items available
 let placeholderCount = max(0, 20 - audioQuizCollection.count)
 
 LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
 // Display actual items
 ForEach(audioQuizCollection, id: \.self) { quiz in
 AudioQuizPackageView(quiz: quiz)
 }
 
 // Display placeholders
 ForEach(0..<placeholderCount, id: \.self) { _ in
 AudioQuizPlaceHolder()
 .frame(height: 260)
 }
 }
 }
 .padding(.top)
 }
 }
 .navigationTitle("Audio Quiz Collection")
 .navigationBarTitleDisplayMode(.inline)
 
 
 
 */
