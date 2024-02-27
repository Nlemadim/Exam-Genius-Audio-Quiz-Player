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
    @State private var path = [AudioQuizPackage]()
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    private let networkService: NetworkService = NetworkService.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Sample Collection Section
                        Text("Library")
                            .font(.headline)
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem(.fixed(200))], spacing: 20) {
                                ForEach(audioQuizCollection, id: \.self) { quiz in // Assuming 'FeaturedQuiz' is a placeholder
                                    AudioQuizSearchCollectionView(quiz: quiz) // Assuming this view takes a quiz and displays it
                                        .frame(width: 180, height: 260)
                                }
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .contentMargins(20, for: .scrollContent)
                            .containerRelativeFrame(.horizontal)
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
                                AudioQuizSearchCollectionView(quiz: quiz)
                            }
                            
                            // Display placeholders
                            ForEach(0..<placeholderCount, id: \.self) { _ in
                                AudioQuizPlaceHolder()
                                    .frame(height: 260)
                            }
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .contentMargins(20, for: .scrollContent)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Image("Logo")
                    .offset(x: 230, y: 10)
                    //.blur(radius: 20.0, opaque: false)
            )
            
        }
        .searchable(text: .constant("search"))
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    return ExploreAudioQuizView()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
        .preferredColorScheme(.dark)
}
