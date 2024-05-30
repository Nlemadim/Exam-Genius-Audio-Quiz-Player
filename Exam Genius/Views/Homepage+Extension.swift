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
            
            if let package = self.selectedQuizPackage {
                user.selectedQuizPackage = package
            }
        }
    }
    
    private func downloadFullPackage(_ audioQuiz: AudioQuizPackage) async throws {
        guard audioQuiz.questions.isEmpty else { return }
        DispatchQueue.main.async {
            self.interactionState = .isDownloading
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        // Begin content building process
        //MARK: Test Method
        //let content = try await contentBuilder.buildForProd(for: audioQuiz.name)
        
        //MARK: ProductionFlow Method
        let content = try await contentBuilder.buildQuestionsOnly(examName: audioQuiz.name)
        
        print("Downloaded \(content.questions.count) Questions without audio")
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
            user.selectedQuizPackage = audioQuiz
            print("Prepare to download audio questions")
            
            Task {
                await loadNewAudioQuiz(quiz: audioQuiz)
            }
        }
    }
    
    func downloadBasicPackage() async throws {
        guard let audioQuiz = audioQuizCollection.first(where: { $0.name == self.quizName }) else {
            return // Exit if audioQuiz is not found
        }
        
        guard audioQuiz.questions.count <= 300 else {
            return // Exit if there are too many questions in audioQuiz
        }
        
        DispatchQueue.main.async {
            print("Starting complete download process")
        }
       
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        let content = try await contentBuilder.buildCompletePackage(examName: audioQuiz.name, topics: audioQuiz.topics)
        
        DispatchQueue.main.async {
            audioQuiz.topics.append(contentsOf: content.topics)
            audioQuiz.questions.append(contentsOf: content.questions)
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
           // let list = audioQuiz.questions
            //let playList = list.compactMap{$0.questionAudio}
            //playSample(playlist: playList)
        }
    }
    
   func playSample(playlist: [String]) {
        isPlaying.toggle()
        //let audioFile = playlist[0]
        //questionPlayer.playSingleAudioQuestion(audioFile: audioFile)
    }

    
    func packetStatusPrintOut() {
        print("Status Check...")
        let userHasPackage = audioQuizCollection.contains(where: {$0.name == self.quizName})
        let userHasAudioQuiz = downloadedAudioQuizCollection.contains(where: {$0.quizname == self.quizName})
        let userPackage = audioQuizCollection.first(where: { $0.name == self.quizName })
        let userQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == self.quizName })
        
        print(quizName)
        print("Has Package in Database: \(userHasPackage)")
        print("Package name: \(userPackage?.name ?? "None")")
        print("Package questions: \(userPackage?.questions.count ?? 0)")
        print("Has audioQuiz in Database: \(userHasAudioQuiz)")
        print("Quiz name: \(userQuiz?.quizname ?? "None")")
        print("Has selected package: \(user.selectedQuizPackage?.name ?? "None")")
        print("Has selected package: \(user.downloadedQuiz?.quizname ?? "None")")
  
    }

    
    func playNow(_ audioQuiz: AudioQuizPackage) {
        isPlaying.toggle()
    }
    
    func setQuizObserverAction(observer state: QuizPlayerState) {
        if state == .startedPlayingQuiz {
            
        }
    }
    
    func updatePlayState(interactionState: QuizPlayerState) {
        DispatchQueue.main.async {
            self.quizPlayerObserver.playerState = interactionState
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
    
    func loadUserDetails() async {
        guard !self.quizName.isEmptyOrWhiteSpace else {
            print("Quiz name is unavailable")
            return }
        
        guard let audioQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == quizName }) else {
            print("No downloaded quiz")
            return
        }
        
        if audioQuiz.questions.isEmpty {
            print("Populating audio quiz questions")
            await loadQuestions(self.quizName)
            DispatchQueue.main.async {
                user.downloadedQuiz = audioQuiz
                print(user.downloadedQuiz?.questions.count ?? 0)
            }
            
        } else {
            user.downloadedQuiz = audioQuiz
        }
    }
    
    func loadQuestions(_ quizName: String) async {
        guard let userPackage = audioQuizCollection.first(where: { $0.name == quizName }),
              let audioQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == quizName }),
              !userPackage.questions.isEmpty else {
            return
        }
        
        // Filter questions that need to be downloaded
        let questionsToDownload = userPackage.questions.filter { $0.questionAudio.isEmptyOrWhiteSpace && !$0.isAnswered }
        
        // Fetch random questions limited to the default question count
        let audioQuestions = Array(questionsToDownload.shuffled().prefix(self.defaultQuestionCount))
        
        print(audioQuestions.count)
        
        // Download the audio files and update the questions in the audioQuiz
        await addAudioFiles(audioQuestions)
        
        audioQuiz.questions = audioQuestions
    }
    
    
    
    private func addAudioFiles(_ questionsToDownload: [Question]) async {
        print("Adding audioFiles to questions")
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        await contentBuilder.downloadAudioQuestions(for: questionsToDownload)
        
    }
    
    
    func getFeedBackMessages() -> FeedBackMessageUrls {
        let userFeedbackMessages = voiceFeedbackMessages.first
        let feedbackMessages = FeedBackMessageUrls(
            quizStartMessage: userFeedbackMessages?.quizStartAudioUrl ?? "",
            quizEndingMessage: userFeedbackMessages?.quizEndingAudioUrl ?? "",
            nextQuestionCallout: userFeedbackMessages?.nextQuestionCalloutAudioUrl ?? "",
            finalQuestionCallout: userFeedbackMessages?.finalQuestionCalloutAudioUrl ?? "",
            repeatQuestionCallout: userFeedbackMessages?.repeatQuestionCalloutAudioUrl ?? "",
            listeningCallout: userFeedbackMessages?.listeningCalloutAudioUrl ?? "",
            waitingForResponseCallout: userFeedbackMessages?.waitingForResponseCalloutAudioUrl ?? "",
            pausedCallout: userFeedbackMessages?.pausedCalloutAudioUrl ?? "",
            correctAnswerCallout: userFeedbackMessages?.correctAnswerCalloutUrl ?? "",
            correctAnswerLowStreakCallOut: userFeedbackMessages?.correctAnswerLowStreakCallOutAudioUrl ?? "",
            correctAnswerMidStreakCallout: userFeedbackMessages?.correctAnswerMidStreakCalloutAudioUrl ?? "",
            correctAnswerHighStreakCallout: userFeedbackMessages?.correctAnswerHighStreakCalloutAudioUrl ?? "",
            inCorrectAnswerCallout: userFeedbackMessages?.inCorrectAnswerCalloutAudioUrl ?? "",
            zeroScoreComment: userFeedbackMessages?.zeroScoreCommentAudioUrl ?? "",
            tenPercentScoreComment: userFeedbackMessages?.tenPercentScoreCommentAudioUrl ?? "",
            twentyPercentScoreComment: userFeedbackMessages?.twentyPercentScoreCommentAudioUrl ?? "",
            thirtyPercentScoreComment: userFeedbackMessages?.thirtyPercentScoreCommentAudioUrl ?? "",
            fortyPercentScoreComment: userFeedbackMessages?.fortyPercentScoreCommentAudioUrl ?? "",
            fiftyPercentScoreComment: userFeedbackMessages?.fiftyPercentScoreCommentAudioUrl ?? "",
            sixtyPercentScoreComment: userFeedbackMessages?.sixtyPercentScoreCommentAudioUrl ?? "",
            seventyPercentScoreComment: userFeedbackMessages?.seventyPercentScoreCommentAudioUrl ?? "",
            eightyPercentScoreComment: userFeedbackMessages?.eightyPercentScoreCommentAudioUrl ?? "",
            ninetyPercentScoreComment: userFeedbackMessages?.ninetyPercentScoreCommentAudioUrl ?? "",
            perfectScoreComment: userFeedbackMessages?.perfectScoreCommentAudioUrl ?? "",
            errorTranscriptionCallout: userFeedbackMessages?.errorTranscriptionAudioUrl ?? "",
            invalidResponseCallout: userFeedbackMessages?.invalidResponseCalloutAudioUrl ?? "",
            invalidResponseUserAdvisory: userFeedbackMessages?.invalidResponseUserAdvisoryAudioUrl ?? "")
        
        return feedbackMessages
    }
    
    func loadNewAudioQuiz(quiz package: AudioQuizPackage) async {
        // Check if the package name already exists in the downloaded collection
        guard !downloadedAudioQuizCollection.contains(where: { $0.quizname == package.name }) else { return }
        
        DispatchQueue.main.async {
            print("Creating New Audio Quiz")
        }
        
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        let newDownloadedQuiz = DownloadedAudioQuiz(quizname: package.name, shortTitle: package.acronym, quizImage: package.imageUrl)
        let audioQuestions = package.questions
        
        await contentBuilder.downloadAudioQuestions(for: audioQuestions)
        newDownloadedQuiz.questions = audioQuestions
        
        modelContext.insert(newDownloadedQuiz)
        try! modelContext.save()
        
        DispatchQueue.main.async {
            user.downloadedQuiz = newDownloadedQuiz
            UserDefaultsManager.setQuizName(quizName: newDownloadedQuiz.quizname)
            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
            self.interactionState = .idle
            
        }
    }
    

    

    
    func refreshQuiz(_ refreshQuiz: Bool) {
        print("Refresh Tapped")
        if refreshQuiz {
            Task {
                //await updateAudioQuizQuestions()
            }
        }
    }
    
    private func updateAudioQuizQuestions() async {
        let questionCount = UserDefaultsManager.numberOfTestQuestions()
        let currentQuizName = UserDefaultsManager.quizName()
        
        guard !currentQuizName.isEmptyOrWhiteSpace else { return }
        
        // Filter the current audio quiz
        guard let currentAudioQuiz = downloadedAudioQuizCollection.first(where: { $0.quizname == currentQuizName }) else { return }
        
        // Filter the current quiz package
        guard let currentQuizPackage = audioQuizCollection.first(where: { $0.name == currentQuizName }) else { return }
        
        // Get new questions from the current quiz package
        let newQuestions = currentQuizPackage.questions
        
        // Filter questions that need to be downloaded
        var questionsToDownload = newQuestions.filter { $0.questionAudio.isEmptyOrWhiteSpace && !$0.isAnswered }
        
        // Limit the number of questions to download
        if questionsToDownload.count > questionCount {
            questionsToDownload = Array(questionsToDownload.prefix(questionCount))
        }
        
        // Initialize the content builder and download audio questions
        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
        await contentBuilder.downloadAudioQuestions(for: questionsToDownload)
        
        // Update the questions in the current audio quiz
        currentAudioQuiz.questions = questionsToDownload
        
        // Update the UI on the main thread
        DispatchQueue.main.async {
            print("Quiz Refreshed")
            self.refreshAudioQuiz = false
        }
    }
    
    
}





