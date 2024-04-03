//
//  QuizDetailPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/2/24.
//

import SwiftUI
import SwiftData

struct QuizDetailPage: View {
    @EnvironmentObject var user: User
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject private var viewModel: QuizDetailPageVM
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
        viewModel = QuizDetailPageVM(audioQuiz: audioQuiz)
        _audioQuiz = Bindable(wrappedValue: audioQuiz)
        _didTapDownload = didTapDownload
        _isDownloading = isDownloading
        _isNowPlaying = isNowPlaying
        _isDownloadingSample = isDownloadingSample
        _didTapPlaySample = didTapPlaySample
    }
    
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .center) {
                    Image(audioQuiz.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
                .frame(height: 280)
                .blur(radius: 60)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 5) {
                            Image(audioQuiz.imageUrl)
                                .resizable()
                                .frame(width: 250, height: 250)
                                .cornerRadius(20)
                                .padding()
                            
                            Text(audioQuiz.name)
                                .lineLimit(2, reservesSpace: true)
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .hAlign(.center)
                                .padding()
                        }
                        .frame(height: 300)
                        .padding()
                        .padding(.horizontal, 40)
                        .hAlign(.center)
                        
                        VStack(alignment: .leading, spacing: 8.0) {
                            
                            Divider()
                            
                            PlainClearButton(color: generator.dominantBackgroundColor, label: "Play sample") {
                                
                            }
                            
                            PlainClearButton(color: generator.dominantBackgroundColor, label: "Add to Library") {
                                
                            }
                            
                            PlainClearButton(color: generator.dominantBackgroundColor, label: "Customize", image: "wand.and.stars.inverse") {
                            }
                        }
                        .padding()
                        
                        VStack {
                            
                            Text("Category")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .hAlign(.leading)
                            
                            HStack(spacing: 16.0) {
                                ForEach(audioQuiz.category, id: \.self) { category in
                                    Text(category.rawValue)
                                        .font(.caption2)
                                        .fontWeight(.light)
                                        .lineLimit(2, reservesSpace: false)
                                        .padding(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 0.5)
                                        )
                                }
                            }
                            .hAlign(.leading)
                            .multilineTextAlignment(.leading)
                        }
                        .padding()
                        
                        VStack {
                            Text("About \(audioQuiz.acronym)")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .hAlign(.leading)
                            Divider()
                            
                            Text(audioQuiz.about)
                                .font(.subheadline)
                                .fontWeight(.light)
                                .hAlign(.leading)
                        }
                        .padding()
                        .padding(.bottom)
                        
                        Rectangle()
                            .fill(.black)
                            .frame(height: 100)
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {dismiss()}, label: {
                        Image(systemName: "chevron.left.circle")
                            .foregroundStyle(.white)
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { /*  shareAction() */}, label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20.0)
                    })
                }
            }
        }
        .onAppear {
            generator.updateDominantColor(fromImageNamed: audioQuiz.imageUrl)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    do {
        let user = User()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)California Bar (MBE)California Bar (MBE)", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "BarExam-Exam", category: [.legal])
   
        
        return QuizDetailPage(audioQuiz: package, isDownloading: .constant(false), didTapDownload: .constant(false), isNowPlaying: .constant(false), isDownloadingSample: .constant(false), didTapPlaySample: .constant(false))
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
    
}


extension QuizDetailPage {
    class QuizDetailPageVM: ObservableObject {
        var error: Error?
        @Bindable var audioQuiz: AudioQuizPackage
        private let networkService = NetworkService.shared
        private let quizPlayer = QuizPlayer.shared
        var isDownloading: Bool = false
        
        init(audioQuiz: AudioQuizPackage) {
            self.audioQuiz = audioQuiz
        }
        
        func buildAudioQuizContent(name audioQuiz: AudioQuizPackage)  {
            isDownloading = true
            let contentBuilder = ContentBuilder(networkService: networkService)
            Task {
                do {
                    let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
                    DispatchQueue.main.async {
                        audioQuiz.topics.append(contentsOf: content.topics)
                        audioQuiz.questions.append(contentsOf: content.questions)
                        self.isDownloading = false
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.isDownloading = false
                        self?.error = error
                    }
                }
            }
        }
        
        func buildAudioQuizTestContent(name audioQuiz: AudioQuizPackage)  {
            isDownloading = true
            let contentBuilder = ContentBuilder(networkService: networkService)
            Task {
                do {
                    let content = try await contentBuilder.alternateBuildTestContent(for: audioQuiz.name)
                    DispatchQueue.main.async {
                        audioQuiz.topics.append(contentsOf: content.topics)
                        audioQuiz.questions.append(contentsOf: content.questions)
                        self.isDownloading = false
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.isDownloading = false
                        self?.error = error
                    }
                }
            }
        }
        
        func playAudioQuizSample(playlist: [String]) {
            sampleContent(audioQuiz: audioQuiz)
        }
        
        func sampleContent(audioQuiz: AudioQuizPackage) {
            let samples  = getPlaylist(audioQuiz: audioQuiz)
            let playlist = samples.map{ $0.questionAudio }
            let sortedPlaylist = playlist.sorted()
            quizPlayer.playSampleQuiz(audioFileNames: sortedPlaylist)
           // isNowPlaying = true
        }
        
        func getPlaylist(audioQuiz: AudioQuizPackage) -> [Question] {
            var playlist: [Question] = []
            for question in audioQuiz.questions {
                if !question.questionAudio.isEmpty {
                    playlist.append(question)
                }
            }
            print(playlist.count)
            return playlist
        }
        
    }
}
