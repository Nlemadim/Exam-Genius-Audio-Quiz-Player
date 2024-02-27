//
//  AudioQuizPlaylistView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/26/24.
//

import SwiftUI
import SwiftData
import Foundation

struct AudioQuizPlaylistView: View {
    @EnvironmentObject var user: User
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var topicLabel: String = ""
    @State var isDownloading: Bool = false
    @State var numberOfTopics: Int = 0
    
    let audioQuiz: AudioQuizPackage
    let quizBuilder = QuizBuilder()
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            ZStack(alignment: .bottomTrailing) {
                Image(audioQuiz.imageUrl)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15.0)
            }
            .overlay(
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.down")
                        .fontWeight(.black)
                        .padding(10)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(.circle)
                        .offset(x: -160, y: -160)
                })
            )
            
            
            VStack(alignment: .leading, spacing: 8.0) {
                HStack {
                    Text(audioQuiz.name)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .lineLimit(3)
                        .bold()
                        .primaryTextStyleForeground()
                    Text("\(audioQuiz.questions.count) Questions".uppercased())
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                }
                
                Text(audioQuiz.about)
                    .font(.footnote)
                    .lineLimit(5, reservesSpace: false)
                    .foregroundStyle(.primary)
        
            }
            .padding(.leading)
            .padding(.top)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Divider()
                    
                    HStack {
                        Text("Topics:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
   
                            Spacer()
                        
                        HStack(spacing: 5) {
                            Text("\(numberOfTopics)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            HStack {
                if audioQuiz.questions.isEmpty {
                    DownloadAudioQuizButton(buildProcesses: {
                        Task {
                            await buildAudioQuizTopics(audioQuiz)
                        }
                    }, cancelDownload: {
                        
                    }, isDownloading: $isDownloading)
                    
                } else {
                    
                    LaunchQuizButton(pressedPlay: $isDownloading, startAudioQuiz: {
                        
                    })
                }
            }
            .padding()
        }
        .navigationTitle(audioQuiz.acronym + " Audio Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollTargetBehavior(.viewAligned)
        .preferredColorScheme(.dark)
    }
    
    func buildAudioQuizTopics(_ audioQuiz: AudioQuizPackage) async {
        self.isDownloading = true
        do {
            let fetchedTopics = try await quizBuilder.fetchTopicNames(context: audioQuiz.name)
            DispatchQueue.main.async {
                // Update the UI on the main thread
                self.numberOfTopics += fetchedTopics.count
                self.isDownloading = false
            }
            for topic in fetchedTopics {
                let newTopic = Topic(name: topic)
                audioQuiz.topics.append(newTopic)
            }
            // Assuming modelContext is a part of your data layer
            //modelContext.insert(audioQuiz)
            try! modelContext.save()
        } catch {
            // Handle errors if needed
            DispatchQueue.main.async {
                self.isDownloading = false
            }
            print(error.localizedDescription)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        let package = AudioQuizPackage(id: UUID(), name: "California Bar", imageUrl: "BarExam-Exam")
        return AudioQuizPlaylistView(audioQuiz: package)
            .modelContainer(container)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
}

