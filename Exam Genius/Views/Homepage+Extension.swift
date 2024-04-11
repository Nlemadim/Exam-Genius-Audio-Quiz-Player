//
//  Homepage+Extension.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import Foundation

extension HomePage {
    
    func goToUserLibrary(_ didTap: Bool) {
        if didTap {
            selectedTab = 1
        }
    }
    
    

    
    func downloadFullPackage(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.questions.isEmpty else { return }
        DispatchQueue.main.async {
            self.interactionState = .isDownloading
        }
    
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process
        let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            user.selectedQuizPackage = audioQuiz
            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
            self.interactionState = .idle
        }
    }
    
    func downloadSample(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.questions.isEmpty else { return }
        DispatchQueue.main.async {
            isDownloadingSample.toggle()
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process
        let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
        print("Downloaded Sample Content: \(content)")
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            isDownloadingSample = false
            let list = audioQuiz.questions
            let playList = list.compactMap{$0.questionAudio}
            playSample(playlist: playList)
        }
    }
    
   func playSample(playlist: [String]) {
        isPlaying.toggle()
        let audioFile = playlist[0]
        questionPlayer.playSingleAudioQuestion(audioFile: audioFile)
    }
    
    func playNow(_ audioQuiz: AudioQuizPackage) {
        let playlist = audioQuiz.questions.compactMap{$0.questionAudio}
        isPlaying.toggle()
        let audioFile = playlist[0]
        questionPlayer.playSingleAudioQuestion(audioFile: audioFile)
    }
    
    func updatePlayState(interactionState: InteractionState) {
        if interactionState == .isNowPlaying || interactionState == .isDonePlaying {
            DispatchQueue.main.async {
                self.interactionState = interactionState
            }
        }
    }
    
    func playSampleQuiz(_ didTapPlay: Bool) {
        if didTapPlay {
            if let selectedQuizPackage = self.selectedQuizPackage {
                if selectedQuizPackage.questions.isEmpty {
                    Task {
                        try await downloadSample(selectedQuizPackage)
                    }
                } else {
                    playNow(selectedQuizPackage)
                }
            }
        }
    }
    
    func fetchFullPackage(_ didTapDownload: Bool) {
        if didTapDownload {
            if let selectedQuizPackage = self.selectedQuizPackage {
                Task {
                    try await downloadFullPackage(selectedQuizPackage)
                }
            }
        }
    }
    
    func updateCollections() {
        let topCollection = audioQuizCollection.filter { $0.category.contains(.topCollection) }
        let topPro = audioQuizCollection.filter { $0.category.contains(.topProfessionalCertification) }
        let topColledge = audioQuizCollection.filter { $0.category.contains(.topColledgePicks) }
        let cultureAndSociety = audioQuizCollection.filter { $0.category.contains(.cultureAndSociety) }
        DispatchQueue.main.async {
            self.topCollectionQuizzes.append(contentsOf: topCollection)
            self.topColledgeCollection.append(contentsOf: topColledge)
            self.topProCollection.append(contentsOf: topPro)
            self.cultureAndSociety.append(contentsOf: cultureAndSociety)
        }
    }
    
    func loadDefaultCollection() async {
        guard audioQuizCollection.isEmpty else { return }
        
        let collection = DefaultDatabase().getAllExamDetails()
        collection.forEach { examDetail in
            
            let newPackage = AudioQuizPackage(from: examDetail)
            
            modelContext.insert(newPackage)
            
            try! modelContext.save()
        }
    }
}
