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
    
    @ObservedObject private var viewModel: AudioQuizDetailVM
    @ObservedObject var quizPlayer = QuizPlayer.shared
    
    @StateObject private var generator = ColorGenerator()
    
    @Bindable var audioQuiz: AudioQuizPackage
    @Binding var isDownloading: Bool
    @Binding var isNowPlaying: Bool
    @Binding var isDownloadingSample: Bool
    @Binding var didTapDownload: Bool
    @Binding var didTapPlaySample: Bool
    
    @State var topicLabel: String = ""
    @State var stillDownloading: Bool = false
    
    
    @State var numberOfTopics: Int = 0
    @State var downloadButtonLabel: String = "Download Audio Quiz"
    
    @State var packetSizeDetails: String = "Packet contains over 72 hours of listening time with over 670 questions and answers spanning across 127 topics"
    //@State var sampleButtonLabel: String = "Download Sample Question"
    @State var sampleButtonLabel: String = "Download Sample Question" {
        didSet {
           sampleButtonLabel = audioQuiz.questions.isEmpty ? "Download Sample Question" : "Play Sample Question"
        }
        
    }
    
   
    private let networkService = NetworkService.shared
    
    let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
    var error: Error?
    
    init(audioQuiz: AudioQuizPackage, isDownloading: Binding<Bool>, didTapDownload: Binding<Bool>, isNowPlaying: Binding<Bool>, isDownloadingSample: Binding<Bool>, didTapPlaySample:  Binding<Bool>) {
        viewModel = AudioQuizDetailVM(audioQuiz: audioQuiz)
        _audioQuiz = Bindable(wrappedValue: audioQuiz)
        _didTapDownload = didTapDownload
        _isDownloading = isDownloading
        _isNowPlaying = isNowPlaying
        _isDownloadingSample = isDownloadingSample
        _didTapPlaySample = didTapPlaySample
    }
    
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
                                .opacity(isDownloading ? 0 : 1)
                                .onTapGesture {
                                    dismiss()
                                }
                            
                            CircularPlayButton(isPlaying: $isNowPlaying,
                                               isDownloading: $isDownloadingSample,
                                               color: generator.dominantLightToneColor,
                                               playAction: { self.didTapPlaySample = true }
                            )
                            .zIndex(1.0)
                            .padding()
                            .offset(y: 15)
                            .onReceive(quizPlayer.$interactionState, perform: { newValue in
                                if newValue == .isNowPlaying {
                                    self.isNowPlaying = true
                                }
                            })  
                        }
                       
                        VStack {
                            VStack(alignment: .leading, spacing: 16.0) {
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
                                PlainClearButton(color: generator.dominantLightToneColor,
                                                 label: isDownloading ? "Downloading" : "Download",
                                                 playAction: { downloadAudioQuiz() }
                                    
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
            
        }
    }
    
    
    private func buildTestContentOnly(_ audioQuiz: AudioQuizPackage) async throws {
        DispatchQueue.main.async {
            stillDownloading = true
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process
        let content = try await contentBuilder.alternateBuildTestContent(for: audioQuiz.name)
        print("Downloaded Detail Page Content: \(content)")
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            stillDownloading = false
        }
    }
    
    private func downloadAudioQuiz() {
        self.didTapDownload = true
        user.selectedQuizPackage = audioQuiz
        UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
    }
    
    func listAllJSONFilesInBundle() {
        if let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            print("Listing all JSON files found in bundle:")
            for url in urls {
                print(url.lastPathComponent)
            }
        } else {
            print("No JSON files found in bundle.")
        }
    }
}

#Preview {
    do {
        let user = User()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)California Bar (MBE)California Bar (MBE)", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "BarExam-Exam", category: [.legal])
   
        
        return AudioQuizDetailView(audioQuiz: package, isDownloading: .constant(false), didTapDownload: .constant(false), isNowPlaying: .constant(false), isDownloadingSample: .constant(false), didTapPlaySample: .constant(false))
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
}
