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

    func resetQuiz() {
        
        // Access the questions array from the selected quiz package.
        let filteredQuestions = user.selectedQuizPackage?.questions.filter { !$0.questionAudio.isEmpty }
        
        // Iterate over the filtered questions
        DispatchQueue.main.async {
            filteredQuestions?.forEach { question  in
                //Resetting answered questions
                question.selectedOption = " "
                question.isAnswered = false
                question.isAnsweredCorrectly = false
            }
            
            self.quizPlayerObserver.playerState = .idle
            packetStatusPrintOut()
        }
    }
    
    func packetStatusPrintOut() {
        print("Triggered Reset status Check...")
       
        let filteredQuestions = user.selectedQuizPackage?.questions.filter { !$0.questionAudio.isEmpty }
        let answeredQuestions = filteredQuestions?.filter {!$0.selectedOption.isEmptyOrWhiteSpace}
//        let currentQuestions = filteredQuestions?.count
//        let answeredQuestionsCount = answeredQuestions?.count
        
        print("Reset Status")
        print("Number of Questions: \(String(describing: filteredQuestions))")
        print("Number of Questions answered: \(String(describing: answeredQuestions))")
        print("Number of Questions reset: \(String(describing: filteredQuestions))")
        
    }

    
    func playNow(_ audioQuiz: AudioQuizPackage) {
        isPlaying.toggle()
    }
    
    func setQuizObserverAction(observer state: QuizPlayerState) {
        
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
    
    func loadDefaultCollection() async {
        guard audioQuizCollection.isEmpty else { return }
        
        let collection = DefaultDatabase().getAllExamDetails()
        collection.forEach { examDetail in
            
            let newPackage = AudioQuizPackage(from: examDetail)
            
            modelContext.insert(newPackage)
            
            try! modelContext.save()
        }
    }
    
    
//    func loadVoiceFeedBackMessages() async {
//        guard voiceFeedbackMessages.isEmpty else { return }
//        let contentBuilder = ContentBuilder(networkService: NetworkService.shared)
//        let container = VoiceFeedbackContainer(
//            id: UUID(),
//            quizStartMessage: "Starting a new quiz now.",
//            quizEndingMessage: "Great job! This quiz is now complete.",
//            correctAnswerCallout: "That's the correct Answer!",
//            skipQuestionMessage: "Thats an invalid response. Skipping this question for now.",
//            errorTranscriptionMessage: "Error transcribing your response. Skipping this question for now",
//            finalScoreMessage: "Final score calculated.",
//            quizStartAudioUrl: "",
//            quizEndingAudioUrl: "",
//            correctAnswerCalloutUrl: "",
//            skipQuestionAudioUrl: "",
//            errorTranscriptionAudioUrl: "",
//            finalScoreAudioUrl: ""
//        )
//        
//        let messageData = await contentBuilder.downloadAllFeedbackAudio(for: container)
//        let newVoiceMessages = VoiceFeedbackMessages(from: messageData)
//        print("Downloaded new voice feedback messages with id \(newVoiceMessages.id.uuidString) and testing file path start quiz is printing: \(newVoiceMessages.quizEndingAudioUrl)")
//        
//        modelContext.insert(newVoiceMessages)
//        
//        try! modelContext.save()
//        
//    }
    
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
            UserDefaults.standard.set(true, forKey: "hasSelectedAudioQuiz")
            self.interactionState = .idle
        }
    }
}





