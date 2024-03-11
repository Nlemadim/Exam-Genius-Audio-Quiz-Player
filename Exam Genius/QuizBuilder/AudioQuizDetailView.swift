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
                                Button(sampleButtonLabel) {
                                   
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
            //updatePacketStatus()
        }
    }
    
    mutating func buildAudioQuizContent(name audioQuiz: AudioQuizPackage) {
        let contentBuilder = ContentBuilder(networkService: networkService)
        Task {
            do {
                let content = try await contentBuilder.buildContent(for: audioQuiz.name)
                DispatchQueue.main.async { self
                    self.audioQuiz = AudioQuizPackage.from(content: content)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
    }
    
    func playAudioQuizSample(playlist: [String]) {
        guard !audioQuiz.questions.isEmpty else {
            print("Empty Playlist")
            return
        }
        
        let sampleCollection = audioQuiz.questions.filter{ $0.questionAudio != "" }
        let playlist = sampleCollection.map{ $0.questionAudio }
        quizPlayer.playSampleQuiz(audioFileNames: playlist)
        
    }
    
//    func buildAudioQuizContent() {
//        //viewModel.buildAudioQuizContent(name: viewModel.audioQuiz.name)
//    }
    
    
    
    mutating func playSample(audioQuiz: AudioQuizPackage) {
        if audioQuiz.questions.isEmpty {
            buildAudioQuizContent(name: audioQuiz)
        } else {
            let playlist = audioQuiz.questions.map{ $0.questionAudio }
            playAudioQuizSample(playlist: playlist)
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
