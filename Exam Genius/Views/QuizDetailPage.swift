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
    
    @StateObject private var generator = ColorGenerator()
    
    @Bindable var audioQuiz: AudioQuizPackage
    
    @Binding var interactionState: InteractionState
    @Binding var didTapSample: Bool
    @Binding var didTapDownload: Bool
    @Binding var goToLibrary: Bool
    @State var downloadButtonLabel: String = "Free Download"
    @State var playButtonLabel: String = "Play Sample"
    @State var stillDownloading: Bool = false
    
    init(audioQuiz: AudioQuizPackage, didTapSample: Binding<Bool>, didTapDownload: Binding<Bool>, goToLibrary: Binding<Bool>, interactionState: Binding<InteractionState>) {
//        viewModel = QuizDetailPageVM(audioQuiz: audioQuiz)
        _audioQuiz = Bindable(wrappedValue: audioQuiz)
        _didTapSample = didTapSample
        _interactionState = interactionState
        _didTapDownload = didTapDownload
        _goToLibrary = goToLibrary
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
                        VStack(spacing: -5) {
                            Image(audioQuiz.imageUrl)
                                .resizable()
                                .frame(width: 250, height: 250)
                                .cornerRadius(20)
                                .padding()
                            
                            Text(audioQuiz.name)
                                .lineLimit(3, reservesSpace: true)
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .hAlign(.center)
                                //.padding()
                        }
                        .frame(height: 300)
                        .frame(maxWidth:.infinity)
                        .padding()
                        .padding(.horizontal, 40)
                        .hAlign(.center)
                        
                        PlaySampleButton(interactionState: .constant(.idle), playAction: {})
                            .hAlign(.center)
                            .offset(y: -20)
                        
                        VStack(alignment: .leading, spacing: 8.0) {
                    
                            PlainClearButton(color: generator.dominantBackgroundColor.opacity(interactionState == .isDownloading ? 0 : 1), label: audioQuiz.questions.isEmpty ?  downloadButtonLabel : "View In Library") {
                                downloadAudioQuiz()
                            }
                            .disabled(interactionState == .isDownloading || interactionState == .isNowPlaying)
                            
                        }
                        .padding()
                        
                        VStack {
                            
                            Text("Category")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .hAlign(.leading)
                            
                            HStack(spacing: 16.0) {
                                ForEach(audioQuiz.category, id: \.self) { category in
                                    Text(category.descr)
                                        .font(.system(size: 10))
                                        .fontWeight(.light)
                                        .lineLimit(1)
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
            .onChange(of: interactionState, { _, newState in
                updateState(newState)
            })
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
            updateViewColors()
        }
        .onDisappear {
          resetView()
        }
        .preferredColorScheme(.dark)
    }
    
    private func downloadAudioQuiz() {
        guard audioQuiz.questions.isEmpty else {
            goToLibrary = true
            dismiss()
            return
        }
        self.didTapDownload = true
    }
    
    private func playSampleQuestion() {
        self.didTapSample = true
    }
    
    private func updateViewColors() {
        generator.updateDominantColor(fromImageNamed: audioQuiz.imageUrl)
    }
    
    private func updateState(_ state: InteractionState) {
        if state == .isDownloading {
            DispatchQueue.main.async {
                self.downloadButtonLabel = "Downloading"
            }
        } else if state == .isNowPlaying {
            DispatchQueue.main.async {
                self.playButtonLabel = "Now playing"
            }
        } else {
            DispatchQueue.main.async {
                self.interactionState = .idle
                self.didTapSample = false
                self.didTapDownload = false
                self.downloadButtonLabel = "Free Download"
                self.playButtonLabel = "Play Sample"
                
            }
        }
    }
    
    private func resetView() {
        self.interactionState = .idle
        self.didTapSample = false
        self.goToLibrary = false
        self.didTapDownload = false
    }
}

#Preview {
    do {
        let user = User()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "American History", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "AmericanHistory-Exam", category: [.legal])
   
        
        return QuizDetailPage(audioQuiz: package, didTapSample: .constant(false), didTapDownload: .constant(false), goToLibrary:  .constant(false), interactionState: .constant(.idle))
            .modelContainer(container)
            .environmentObject(user)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
    
}


extension QuizDetailPage {
    class QuizDetailPageVM: ObservableObject {
        @Published var interactionState: InteractionState = .idle
        var error: Error?
        @Bindable var audioQuiz: AudioQuizPackage
        private let networkService = NetworkService.shared
        var isDownloading: Bool = false
        
        
        init(audioQuiz: AudioQuizPackage) {
            self.audioQuiz = audioQuiz
        }
        
        func buildAudioQuizContent(name audioQuiz: AudioQuizPackage)  {
            interactionState = .isDownloading
            let contentBuilder = ContentBuilder(networkService: networkService)
            Task {
                do {
                    let content = try await contentBuilder.buildQuestionContent(for: audioQuiz.name)
                    DispatchQueue.main.async {
                        audioQuiz.topics.append(contentsOf: content.topics)
                        audioQuiz.questions.append(contentsOf: content.questions)
                        self.interactionState = .idle
                        
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.isDownloading = false
                        self?.error = error
                        self?.interactionState = .errorResponse
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
