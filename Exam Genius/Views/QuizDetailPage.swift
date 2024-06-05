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
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    
    @StateObject private var generator = ColorGenerator()
    @State var quizName = UserDefaultsManager.quizName()
    
    
    @Bindable var audioQuiz: AudioQuizPackage
    @Binding var selectedTab: Int
    
    @Query(sort: \DownloadedAudioQuiz.quizname) var downloadedAudioQuizCollection: [DownloadedAudioQuiz]
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State var interactionState: InteractionState = .idle
    
    @State var downloadButtonLabel: String = "Download Full Version"
    @State var playButtonLabel: String = "Play Sample"
    @State var stillDownloading: Bool = false
    @State var hasDownloadedSample: Bool = false
    @State var hasFullVersion: Bool = false
    
    init(audioQuiz: AudioQuizPackage, selectedTab: Binding<Int>) {
        _audioQuiz = Bindable(wrappedValue: audioQuiz)
        _selectedTab = selectedTab
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
                                .lineLimit(4, reservesSpace: true)
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .hAlign(.center)
                            
                        }
                        .frame(height: 300)
                        .frame(maxWidth:.infinity)
                        .padding()
                        .hAlign(.center)
                        
                        
                        VStack(alignment: .leading) {
                            
                            PlaySampleButton(interactionState: .constant(.idle), playAction: {fetchOrPlaySample()})
                                .padding(.horizontal)
                                .padding()
                                .hAlign(.center)
                            
                            PlainClearButton(color: interactionState == .isDownloading ? generator.dominantBackgroundColor.opacity(0.4) : generator.dominantBackgroundColor, label: !hasFullVersion ? downloadButtonLabel : "Start Quiz") {
                                goToFullVersion()
                            }
                            .disabled(interactionState == .isDownloading)
                            .padding(.horizontal)
                            .padding(5)
                            
                            NavigationLink(destination: Text("Customize Page"), label: {
                                PlainClearButton(color: .themePurple, label: "Customize") {
                                    //downloadAudioQuiz()
                                }
                                .padding(.horizontal)
                                .padding(5)
                            })
                        }
                        .padding(.horizontal)
                        .offset(y: -50)
                        
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
            checkSampleAvailability()
            checkVersionAvailability()
            
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    do {
        let user = User()
        let observer = QuizPlayerObserver()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "The California Bar Examination American History", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "AmericanHistory-Exam", category: [.legal])
        
        
        return QuizDetailPage(audioQuiz: package, selectedTab: .constant(0))
            .modelContainer(container)
            .environmentObject(user)
            .environmentObject(observer)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
    
}


extension QuizDetailPage {
    
    func fetchOrPlaySample() {
        if !hasDownloadedSample {
            Task {
                try await downloadQuickQuiz()
            }
        }
    }
    
    func playQuickQuiz() {
        UserDefaultsManager.enableQandA(true)
        self.quizPlayerObserver.playerState = .startedPlayingQuiz
        dismiss()
    }
    
    func goToFullVersion() {
        guard let Fullpacket = audioQuizCollection.first(where: {$0.name == self.audioQuiz.name}) else {
            print("Package Not Found")
            return
        }
        if Fullpacket.questions.count >= 35 {
            DispatchQueue.main.async {
                UserDefaultsManager.updateHasDownloadedFullVersion(true, for: self.audioQuiz.name)
                self.selectedTab = 1
                dismiss()
            }
        } else {
            Task {
                try await downloadBasicPackage()
            }
        }
    }
    
    
    
    func updateViewColors() {
        generator.updateDominantColor(fromImageNamed: audioQuiz.imageUrl)
    }
    
    func updateState(_ state: InteractionState) {
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
                self.downloadButtonLabel = "Download Full Version"
                self.playButtonLabel = "Play Sample"
                
            }
        }
    }
    
    func downloadBasicPackage() async throws {
        guard !hasFullVersion else { return }
        DispatchQueue.main.async {
            print("Downloading Complete Package")
            self.interactionState = .isDownloading
           
        }
        
        guard let audioQuiz = audioQuizCollection.first(where: { $0.name == self.audioQuiz.name }), audioQuiz.questions.count <= 50 else {
            print("Package Not Found")
            DispatchQueue.main.async {
                print("Downloading Complete Package")
                self.interactionState = .idle
                self.selectedTab = 1
                dismiss()
               
            }
            return // Exit if audioQuiz is not found
        }
        
        
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        let content = try await contentBuilder.buildCompletePackage(examName: audioQuiz.name)
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            self.interactionState = .idle
            self.hasFullVersion = true
            createNewAudioQuiz(audioQuiz)
            
        }
    }
    
    func downloadQuickQuiz() async throws {
        guard !self.audioQuiz.name.isEmptyOrWhiteSpace else {
            print("No audio Quiz Selected")
            return
        }
        
        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == self.audioQuiz.name}) else { return }
        
        DispatchQueue.main.async {
            print("Downloading Quick Quiz")
            self.interactionState = .isDownloading
        }
        
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: self.audioQuiz.name, shortTitle: self.audioQuiz.acronym, quizImage: self.audioQuiz.imageUrl)
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        let content = try await contentBuilder.buildForProd(for: newDownloadedQuiz.quizname)
        
        modelContext.insert(newDownloadedQuiz)
        
        do {
            try modelContext.save()
            
        } catch {
            print("Failed to save new downloaded quiz: \(error)")
        }
        
        DispatchQueue.main.async {
            newDownloadedQuiz.questions.append(contentsOf: content.questions)
            user.downloadedQuiz = newDownloadedQuiz
            print("Saved new downloaded quiz: \(newDownloadedQuiz.quizname)")
            self.interactionState = .idle
            self.hasDownloadedSample = true
            UserDefaultsManager.updateHasDownloadedSample(true, for: "\(newDownloadedQuiz.quizname)")
            //Open QuizPlayer Tab
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedTab = 1
                playQuickQuiz()
            }
        }
    }
    
    func createNewAudioQuiz(_ selectedQuizPackage: AudioQuizPackage) {
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: selectedQuizPackage.name, shortTitle: selectedQuizPackage.acronym, quizImage: selectedQuizPackage.imageUrl)
        
        modelContext.insert(newDownloadedQuiz)
        
        do {
            try modelContext.save()
            
        } catch {
            print("Failed to save new downloaded quiz: \(error)")
        }
        
        DispatchQueue.main.async {
            user.downloadedQuiz = newDownloadedQuiz
            print("Saved new downloaded quiz after Full Version Download: \(newDownloadedQuiz.quizname)")
            UserDefaultsManager.setQuizName(quizName: newDownloadedQuiz.quizname)
            self.interactionState = .idle
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.selectedTab = 1
//                dismiss()
//            }
        }
    }
    
    private func checkSampleAvailability() {
        let sampleAvailable = UserDefaultsManager.hasDownloadedSample(for: self.audioQuiz.name) ?? false
        DispatchQueue.main.async {
            self.hasDownloadedSample = sampleAvailable
        }
    }
    
    private func checkVersionAvailability() {
        let hasFullVersion = UserDefaultsManager.hasFullVersion(for: self.audioQuiz.name) ?? false
        DispatchQueue.main.async {
            self.hasFullVersion = hasFullVersion
        }
    }
}
