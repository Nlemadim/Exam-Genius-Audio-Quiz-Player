//
//  AudioQuizPageViewModel.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/11/24.
//

import Foundation
import SwiftUI
import SwiftData

class AudioQuizPageViewModel: ObservableObject {
    @Bindable var audioQuiz: AudioQuizPackage
    @Published var isDownloading = false
    var error: Error?
    private let networkService = NetworkService.shared

    init(audioQuiz: AudioQuizPackage) {
        self.audioQuiz = audioQuiz
    }

    func buildAudioQuizContent(name: String) {
        let contentBuilder = ContentBuilder(networkService: networkService)
        Task {
            do {
                let content = try await contentBuilder.buildContent(for: audioQuiz.name)
                DispatchQueue.main.async {
                    self.audioQuiz = AudioQuizPackage.from(content: content)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
    }
}




extension ExperimentalView {
    class ExperimentVM: ObservableObject {
        var error: Error?
        @Bindable var object: AudioQuizPackage
        private let networkService = NetworkService.shared
        
        init(object: AudioQuizPackage) {
            self.object = object
        }
        
        func buildAudioQuizContent(name: String) {
            let contentBuilder = ContentBuilder(networkService: networkService)
            Task {
                do {
                    let content = try await contentBuilder.buildContent(for: object.name)
                    DispatchQueue.main.async {
                        self.object = AudioQuizPackage.from(content: content)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error = error
                    }
                }
            }
        }
    }
}

struct ExperimentalView: View {
    @Bindable var objectToPersist: AudioQuizPackage
    @StateObject var viewModel: ExperimentVM
    let quizPlayer = QuizPlayer.shared
    
    init(objectToPersist: AudioQuizPackage) {
        self.objectToPersist = objectToPersist
        self._viewModel = StateObject(wrappedValue: ExperimentVM(object: objectToPersist))
    }
    
    var body: some View {
        VStack {
            Text("Hello Experiment")
            
            Image(objectToPersist.imageUrl)
            
            Text(objectToPersist.name)
            
            if objectToPersist.questions.isEmpty {
                Text("Getting Sample...")
            } else {
                let sampleQuestions = objectToPersist.questions.map{$0.questionAudio}
                Button("Play Sample Quiz") {
                    quizPlayer.playSampleQuiz(audioFileNames: sampleQuestions)
                }
            }
        }
        .onAppear {
            viewModel.buildAudioQuizContent(name: objectToPersist.name)
        }
    }
}

struct ExperimentUsingView: View {
    @State var userObject: AudioQuizPackage?
    @EnvironmentObject var user: User
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                Text("Hello Experiment User")
                Button("Selecting a package", action: {
                    selectPackage()
                })
                .padding(.all, 30)
                
                NavigationLink("Going to Experiment Page", destination: {

                    if let selectedPackage = userSelection() {
                        
                       ExperimentalView(objectToPersist: selectedPackage)
                        
                    } else {
                        // If there is no selected package, provide a default or placeholder view
                        // Alternatively, provide a default AudioQuizPackage if your UI requires it
                        Text("No package selected or available")
                    }
                })
                Spacer()
                
            }
        }
    }
    
    func selectPackage() {
        let pakage = AudioQuizPackage(id: UUID(), name: "California Bar (MBE)", imageUrl: "BarExam-Exam")
        user.selectedQuizPackage = pakage
    }
    
    func userSelection() -> AudioQuizPackage? {
        if let selectedPackage = user.selectedQuizPackage {
            self.userObject = selectedPackage
            return selectedPackage
        } else {
            return nil
        }
    }
}
