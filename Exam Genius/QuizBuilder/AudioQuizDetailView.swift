//
//  AudioQuizDetailView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/11/24.
//

import SwiftUI
import SwiftData

struct AudioQuizDetailView: View {
    @EnvironmentObject var user: User
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var topicLabel: String = ""
    @State var isDownloading: Bool = false
    @State var numberOfTopics: Int = 0
    @State var downloadButtonLabel: String = "Download Audio Quiz"
    @StateObject private var generator = ColorGenerator()
    @State var packetSizeDetails: String = "Packet contains over 72 hours of listening time with over 670 questions and answers spanning across 127 topics"
    //@State var sampleButtonLabel: String = "Download Sample Question"
    @State var sampleButtonLabel: String = "Download Sample Question" {
        didSet {
           sampleButtonLabel = audioQuiz.questions.isEmpty ? "Download Sample Question" : "Play Sample Question"
        }
        
    }
    
    @Bindable var audioQuiz: AudioQuizPackage
    private let networkService = NetworkService.shared
    private let quizPlayer = QuizPlayer.shared
    var error: Error?
    
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
                                .foregroundStyle(.white).activeGlow(.white, radius: 2.0)
                                .padding(8)
                                .background(Material.ultraThick)
                                .clipShape(.circle)
                                .offset(x: -337, y: -330)
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
                            
                            VStack(alignment: .leading, spacing: 12.0) {
                                Button(sampleButtonLabel) {
                                    Task {
                                        //try await playSampleQuiz(audioQuiz)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(generator.dominantLightToneColor)
                                .foregroundColor(.white)
                                .activeGlow(.white, radius: 1)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )

                                Button("Download For $26") {
                                   
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(generator.dominantLightToneColor)
                                .foregroundColor(.white)
                                .activeGlow(.white, radius: 1)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1) 
                                )
                            }
                            .padding(.all, 10.0)
                        }
                        .padding()
                    }
                }
            }
            .background(generator.dominantBackgroundColor.opacity(0.5))
                
        }
        .navigationTitle(audioQuiz.acronym + " Audio Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollTargetBehavior(.viewAligned)
        .preferredColorScheme(.dark)
        .onAppear {
            generator.updateAllColors(fromImageNamed: audioQuiz.imageUrl)
            //updatePacketStatus()
        }
    }
    
    
    
    private func playSampleQuiz(_ audioQuiz: AudioQuizPackage) async throws {
        //self.selectedQuizPackage = AudioQuizPackage(id: UUID(), name: audioQuiz.name)
        
        var sampleCollection = audioQuiz.questions.compactMap { $0.questionAudio }
        if sampleCollection.isEmpty {
            let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
            // Begin content building process
            let content = try await contentBuilder.buildContent(for: audioQuiz.name)
            
            // Once content is built, update the main thread with new data
            DispatchQueue.main.async {
                audioQuiz.questions = content.questions.map { question in
                    Question(id: UUID(), questionContent: question.questionContent, questionNote: "", topic: question.topic, options: question.options, correctOption: question.correctOption, selectedOption: "", isAnswered: false, isAnsweredCorrectly: false, numberOfPresentations: 0, questionAudio: question.questionAudio, questionNoteAudio: "")}
                audioQuiz.topics = content.topics.map { Topic(name: $0.name) }
                
                sampleCollection = audioQuiz.questions.compactMap { $0.questionAudio }
                
                // After updating sampleCollection, check again if it's not empty
                if !sampleCollection.isEmpty {
                    // Set downloading to false before beginning playback
                    self.isDownloading = false
                    //self.isPlaying = true
                    // Play the audio without additional delay as it's now handled within the player
                   quizPlayer.playSampleQuiz(audioFileNames: sampleCollection)
                    //self.isPlaying = quizPlayer.isFinishedPlaying
                    //viewModel.monitorPlaybackCompletion()
                } else {
                    // Handle case with no downloadable content
                    self.isDownloading = false
                    // Implement UI feedback for no content available
                }
            }
        } else {
            // If there are already audio files available, play them without fetching content
            DispatchQueue.main.async {
                self.isDownloading = false
                //self.isPlaying = true
                // Play the audio without additional delay
                quizPlayer.playSampleQuiz(audioFileNames: sampleCollection)
                //viewModel.monitorPlaybackCompletion()
            }
        }
    }
   
    func updatePacketStatus() {
        let questionCount = audioQuiz.questions.filter {$0.questionContent != ""}
        let audioFiles = questionCount.map{$0.questionAudio}
        print(audioFiles.isEmpty ? "No audiofiles have been saved" : "\(audioFiles.count) audio files saved")
        print(questionCount.isEmpty ? "No audiofiles have been saved" : "\(questionCount.count) questions saved")
    }
}

#Preview {
    do {
        let user = User()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "BarExam-Exam", category: [.legal])
        let viewModel = AudioQuizPageViewModel(audioQuiz: package)
        
        return AudioQuizDetailView(audioQuiz: package)
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
}
