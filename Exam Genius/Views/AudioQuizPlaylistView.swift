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
    @StateObject var viewModel: AudioQuizPageViewModel
    @StateObject private var generator = ColorGenerator()
    @State var packetSizeDetails: String = "Packet contains over 72 hours of listening time with over 670 questions and answers spanning across 127 topics"
    
    @Bindable var audioQuiz: AudioQuizPackage
    let quizBuilder = QuizBuilder()
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 8.0) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(audioQuiz.imageUrl)
                                .resizable()
                                .scaledToFit()
                                .offset(y: 10)
                                
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.white).activeGlow(.white, radius: 1.5)
                                .padding(8)
                                .background(Material.ultraThin)
                                .clipShape(.circle)
                                .offset(x: -350, y: -350)
                                .zIndex(1.0)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                       
                        VStack {
                            VStack(alignment: .leading, spacing: 8.0) {
                                HStack {
                                    Text(audioQuiz.name)
                                        .font(.headline)
                                        .fontWeight(.heavy)
                                        .lineLimit(3, reservesSpace: false)
                                        .bold()
                                        .primaryTextStyleForeground()
                                    Spacer(minLength: 0)
                                }
                                
                                Text(audioQuiz.about)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)

                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8.0) {
                                Text(packetSizeDetails)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8.0) {
                                Button("Play Sample Questions") {
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(generator.dominantLightToneColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)

                                Button("Download For $26") {
                                   
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(generator.dominantDarkToneColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .padding(.all, 10.0)
                        }
                        .padding()
                    }
                }
            }
            .background(generator.dominantBackgroundColor)
                
        }
        .navigationTitle(audioQuiz.acronym + " Audio Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollTargetBehavior(.viewAligned)
        .preferredColorScheme(.dark)
        .onAppear {
            generator.updateAllColors(fromImageNamed: audioQuiz.imageUrl)
        }
    }
    
    func buildAudioQuizContent() {
        viewModel.buildAudioQuizContent(name: viewModel.audioQuiz.name)
    }
    
    func buildAudioQuizTopics(_ audioQuiz: AudioQuizPackage) async {
        self.isDownloading = true
        self.downloadButtonLabel = "Downloading"
        do {
            let fetchedTopics = try await quizBuilder.fetchTopicNames(context: audioQuiz.name)
            audioQuiz.topics = fetchedTopics.map { Topic(name: $0) }
            
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
        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "BarExam-Exam", category: [.legal])
        let viewModel = AudioQuizPageViewModel(audioQuiz: package)
        
        return AudioQuizPlaylistView(viewModel: viewModel, audioQuiz: package)
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
}




