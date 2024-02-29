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
    @State var downloadButtonLabel: String = "Download Audio Quiz"
    
    @Bindable var audioQuiz: AudioQuizPackage
    let quizBuilder = QuizBuilder()
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 8.0) {
                    ZStack(alignment: .bottomTrailing) {
                        Image(audioQuiz.imageUrl)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15.0)
                        Text("\(audioQuiz.questions.count) Questions".uppercased())
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundStyle(.white)
                            .background(Material.ultraThin)
                            .clipShape(.rect(cornerRadius: 10))
                            .offset(x: -5, y: -5)
                    }
                    
                    VStack(alignment: .leading, spacing: 8.0) {
                        HStack {
                            Text(audioQuiz.name)
                                .font(.title2)
                                .fontWeight(.heavy)
                                .lineLimit(3)
                                .bold()
                                .primaryTextStyleForeground()
                            Spacer(minLength: 0)
                        }
                        
                        Text(audioQuiz.about)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                
//                                Divider()
//                                
//                                HStack {
//                                    Text("Topics:")
//                                        .font(.subheadline)
//                                        .foregroundStyle(.secondary)
//                                    
//                                    Spacer()
//                                    
//                                    HStack(spacing: 5) {
//                                        Text("\(numberOfTopics)")
//                                            .font(.subheadline)
//                                            .foregroundStyle(.secondary)
//                                        Image(systemName: "chevron.right")
//                                            .foregroundStyle(.secondary)
//                                    }
//                                }
                            }
                        }
                        .padding(.top)
                        
                        Spacer()
 
                            HStack {
                                Spacer(minLength: 0)
                                VStack{
                                    DownloadAudioQuizButton(
                                        buildProcesses: { Task { await buildAudioQuizTopics(audioQuiz) } },
                                        buttonText: downloadButtonLabel,
                                        isDownloading: $isDownloading)
                                    Spacer()
                                    Button("Cancel", systemImage: "xmark.circle", action: { dismiss() }).foregroundStyle(.red)
                                        .padding()
                                }
                                Spacer(minLength: 0)
                            }
                            .padding()
                            .padding(.horizontal)
                        }.padding()
                }
            }
        }
        .navigationTitle(audioQuiz.acronym + " Audio Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollTargetBehavior(.viewAligned)
        .preferredColorScheme(.dark)
        .onAppear {
            print("Number of topics for \(audioQuiz.name): \(self.audioQuiz.topics.count)")
        }
        
    }
    
    func buildAudioQuizTopics(_ audioQuiz: AudioQuizPackage) async {
        self.isDownloading = true
        self.downloadButtonLabel = "Downloading"
        do {
            let fetchedTopics = try await quizBuilder.fetchTopicNames(context: audioQuiz.name)
           
            for topic in fetchedTopics {
                let newTopic = Topic(name: topic)
                audioQuiz.topics.append(newTopic)
                numberOfTopics += 1
            }
            
            print(self.audioQuiz.topics.count)
            self.downloadButtonLabel = "Start Audio Quiz"
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
        let user = User()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. Candidates must demonstrate their ability to analyze facts, discern relevant legal points, and apply principles logically. The exam evaluates their proficiency in using and applying legal theories.", imageUrl: "BarExam-Exam", category: [.legal])
        
        return AudioQuizPlaylistView(audioQuiz: package)
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
}



