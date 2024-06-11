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
    @EnvironmentObject var errorManager: ErrorManager
    @EnvironmentObject var connectionMonitor: ConnectionMonitor
    
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
    @State var isDownloadingSample:  Bool = false
    
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
                            
                            PlaySampleButton(interactionState: .constant(sampleButtonInteraction()), playAction: { fetchOrPlaySample() })
                                .padding(.horizontal)
                                .padding()
                                .padding(.top)
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
                        .offset(y: -40)
                        
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
            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    if let error = await errorManager.connectionError, error.displayNotification {
//                        ConnectionErrorView(error: error)
//                            .opacity(error.displayNotification ? 1.0 : 0.0)
//                    } else {
//                        EmptyView()
//                    }
//                }
            }
        }
        .onAppear {
            updateViewColors()
            checkSampleAvailability()
            checkVersionAvailability()
            
        }
        .alert(item: $errorManager.currentError) { error in
            Alert(
                title: Text(error.alertTitle),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK")) {
                    handleAlertAction(for: error)
                }
            )
        }
        .preferredColorScheme(.dark)
    }
    
    private func handleAlertAction(for error: AppError) {
        switch error {
        case .downloadError:
            // Handle retry logic
            print("Retrying...")
        
        default:
            break
        }
        errorManager.clearError()
    }
    
    func sampleButtonInteraction() -> InteractionState {
        var state: InteractionState = .idle
        if isDownloadingSample {
            state = .isDownloading
            return state
        }
        return state
    }
}

#Preview {
    do {
        let user = User()
        let monitor = ConnectionMonitor(forTesting: true)
        let errorManager = ErrorManager()
        let observer = QuizPlayerObserver()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        @State var package = AudioQuizPackage(id: UUID(), name: "The California Bar Examination American History", about: "The California Bar Examination is a rigorous test for aspiring lawyers. It consists of multiple components, including essay questions and performance tests. ", imageUrl: "AmericanHistory-Exam", category: [.legal])
        
        
        return QuizDetailPage(audioQuiz: package, selectedTab: .constant(0))
            .modelContainer(container)
            .environmentObject(user)
            .environmentObject(observer)
            .environmentObject(errorManager)
            .environmentObject(monitor)
            .onAppear {
                // Testing Code
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    monitor.simulateDisconnection() // Simulate disconnection after 5 seconds
                }
            }
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
    
}


extension QuizDetailPage {
    
    func fetchOrPlaySample() {
        if !hasDownloadedSample {
            Task {
                do {
                    try await downloadQuickQuiz()
                } catch {
                    DispatchQueue.main.async {
                        self.errorManager.handleError(.downloadError(description: "Oops! Something went wrong"))
                        self.isDownloadingSample = false
                    }
                }
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
                do {
                    try await downloadBasicPackage()
                } catch {
                    DispatchQueue.main.async {
                        self.errorManager.handleError(.downloadError(description: "Oops! Something went wrong"))
                        self.interactionState = .idle
                    }
                }
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
        
        
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared, errorManager: errorManager)
        let content = try await contentBuilder.buildCompletePackage(examName: audioQuiz.name)
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            self.interactionState = .idle
            self.hasFullVersion = true
            UserDefaultsManager.updateHasDownloadedFullVersion(true, for: audioQuiz.name)
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
            self.isDownloadingSample = true
        }
        
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: self.audioQuiz.name, shortTitle: self.audioQuiz.acronym, quizImage: self.audioQuiz.imageUrl)
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared, errorManager: errorManager)
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
            self.isDownloadingSample = false
            UserDefaultsManager.updateHasDownloadedSample(true, for: "\(newDownloadedQuiz.quizname)")
            //Open QuizPlayer Tab
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedTab = 1
                playQuickQuiz()
            }
        }
    }
    
    private func createNewAudioQuiz(_ selectedQuizPackage: AudioQuizPackage) {
        deleteExistingSample(selectedPackageName: selectedQuizPackage.name)
        
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedTab = 1
                dismiss()
            }
        }
    }
    
    private func deleteExistingSample(selectedPackageName: String) {
        guard let sampleQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == selectedPackageName }) else { return }
        let audioQuestions = sampleQuiz.questions
        deleteAudioFiles(for: audioQuestions)
        modelContext.delete(sampleQuiz)
    }
    
    private func deleteAudioFiles(for questions: [Question]) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        for question in questions {
            var audioFileName = question.questionAudio
            if  !audioFileName.isEmptyOrWhiteSpace {
                let fileURL = documentsDirectory.appendingPathComponent(audioFileName)
                do {
                    try fileManager.removeItem(at: fileURL)
                    print("Deleted audio file: \(fileURL)")
                } catch {
                    print("Error deleting audio file: \(error)")
                }
            }
            
            //Reset the swift data model property to default
            audioFileName = ""
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
