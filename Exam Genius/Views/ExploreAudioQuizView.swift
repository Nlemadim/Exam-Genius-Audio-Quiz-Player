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
    @State private var searchText = ""
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    private let networkService: NetworkService = NetworkService.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            // Display actual items
                            ForEach(audioQuizCollection, id: \.self) { quiz in
                                AudioQuizSearchCollectionView(quiz: quiz)
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
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        HStack(spacing: 5) {
                            Text("New Quiz")
                            Image(systemName: "plus")
                        }
                        .font(.headline)
                        .foregroundStyle(.teal)
                    })
                }
            }
            .searchable(text: $searchText)
            .background(
                Image("Logo")
                    .offset(x: 230, y: 10)
                    
            )
        }
    }
    
    var filteredQuizzesByCategory: [ExamCategory: [AudioQuizPackage]] {
        var result: [ExamCategory: [AudioQuizPackage]] = [:]

        // Populate the result dictionary with empty arrays for each category
        ExamCategory.allCases.forEach { category in
            result[category] = []
        }

        for quiz in audioQuizCollection {
            // Include the quiz if the name matches the search text, irrespective of category
            let matchesSearchText = searchText.isEmpty || quiz.name.localizedCaseInsensitiveContains(searchText)

            for category in quiz.category where matchesSearchText || category.rawValue.localizedCaseInsensitiveContains(searchText) {
                // Append the quiz to each matching category
                result[category]?.append(quiz)
            }
        }

        // Remove categories with no quizzes
        result = result.filter { !$0.value.isEmpty }
        
        return result
    }
}


#Preview {
    let user = User()
    let appState = AppState()
    return ExploreAudioQuizView()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
        .preferredColorScheme(.dark)
}


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
