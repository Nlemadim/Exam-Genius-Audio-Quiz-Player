//
//  ContentBuilder.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/8/24.
//

import Foundation

struct Container {
    var id: UUID
    var topics: [Topic]
    var questions: [Question]
    
    init(id: UUID) {
        self.id = id
        self.topics = []
        self.questions = []
    }
}

class ContentBuilder {
    var readOut: String = ""
    var audioUrl: String = ""
    var context: String = ""
    var container = Container(id: UUID())
    
    var temporaryQuestionContent = [Question]()
    
    private let networkService: NetworkService // Assuming this is your networking layer
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func buildForProd(for examName: String) async throws -> Container {
        print("Building test Content")
        try await buildTopics(examName: examName)
        try await buildQuestionsProdEnv(examName: examName)
        await buildAudioQuestionsV2()

        return container
    }
    
    private func buildTopics(examName: String) async throws {
        //MARK: Create Topics for Content
        let topics = try await networkService.fetchTopics(context: examName)
        
        guard topics.count >= 3 else {
            throw NSError(domain: "ContentBuilder", code: 1, userInfo: [NSLocalizedDescriptionKey: "Not enough topics returned from the server."])
        }
        
        topics.forEach { topic in
            let containerTopic = Topic(name: topic)
            container.topics.append(containerTopic)
            
        }
    }

    
    
    private func buildQuestionsProdEnv(examName: String) async throws {
        guard self.container.topics.count >= 3 else {
            throw NSError(domain: "ContentBuilder", code: 1, userInfo: [NSLocalizedDescriptionKey: "Not enough topics returned from the server."])
        }
        //MARK: Using RandonmTopics for example Quiz demo
        let randomTopics = container.topics.shuffled().prefix(1)
        let questionTopics = randomTopics.map{ $0.name }
        
        let questionDataObject = try await networkService.fetchQuestionData(examName: examName, topics: questionTopics, number: 1)
        print("Content Builder Data recieved from network Service: \(questionDataObject)")
        
        questionDataObject.forEach { questionDataObject in
            questionDataObject.questions.forEach { questionData in
                let optionsArray = [questionData.options.a, questionData.options.b, questionData.options.c, questionData.options.d]
                
                let newContainerQuestion = Question(id: UUID())
                newContainerQuestion.questionContent = questionData.question
                newContainerQuestion.options = optionsArray
                newContainerQuestion.correctOption = questionData.correctOption
                newContainerQuestion.questionNote = questionData.overview
                
                temporaryQuestionContent.append(newContainerQuestion)
            }
        }
    }
    
    private func buildAudioQuestionsV2() async {
        await withTaskGroup(of: Void.self) { group in
            for (index, question) in temporaryQuestionContent.enumerated() {
                group.addTask {
                    let context = self.determineContext(for: index, totalCount: self.temporaryQuestionContent.count)
                    let readOut = self.formatQuestionForReadOut(questionContent: question.questionContent, options: question.options, context: context)
                    let overViewReadOut = self.formatOverviewForReadout(overviewString: question.questionNote)
                    
                    let audioUrl = await self.downloadReadOut(readOut: readOut) ?? ""
                    let questionNoteAudioUrl = await self.downloadReadOut(readOut: overViewReadOut) ?? ""
                    
                    let finishedQuestion = Question(id: UUID())
                    finishedQuestion.questionContent = question.questionContent
                    finishedQuestion.topic = question.topic
                    finishedQuestion.options = question.options
                    finishedQuestion.correctOption = question.correctOption
                    finishedQuestion.questionAudio = audioUrl
                    finishedQuestion.questionNoteAudio = questionNoteAudioUrl
                    
                    // Safely append to builtQuestions
                    self.container.questions.append(finishedQuestion)
                    print("Content Builder processed: \(self.container.questions.count) Questions with audio files")
                }
            }
        }
    }
    
    private func determineContext(for index: Int, totalCount: Int) -> String {
        if index == 0 {
            return "New Question"
        } else if index == totalCount - 1 {
            return "New Question"
        } else {
            return "New Question"
        }
    }
   
    private func formatQuestionForReadOut(questionContent: String, options: [String], context: String) -> String {
        return """
               \(context):
               
               \(questionContent)
               
               Options:
               
               A: \(options[0])
               B: \(options[1])
               C: \(options[2])
               D: \(options[3])
               
               """
    }
    
    private func formatOverviewForReadout(overviewString: String) -> String {
        let headers = ["That is Incorrect", "Incorrect", "That is the Wrong Answer", "That is not the right Answer"]
        // Select a random header from the headers array.
        let header = headers.randomElement() ?? "Incorrect"

        return """
        
        \(header)
        
        \(overviewString)
        
        """
    }

    
    func downloadReadOut(readOut: String) async -> String? {
        var fileName: String? = nil
        do {
            let audioData = try await networkService.fetchAudioData(content: readOut)
            if let savedFileName = saveAudioDataToFile(audioData) {
                fileName = savedFileName
                print("Downloaded and saved audio file name: \(savedFileName)")
            } else {
                print("Failed to save the audio file.")
            }
        } catch {
            print("Failed to download audio file: \(error.localizedDescription)")
        }
        
        return fileName
    }
    
    
    private func saveAudioDataToFile(_ data: Data) -> String? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".mp3"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving audio file: \(error)")
            return nil
        }
    }
    
    private func downloadVoiceFeedBack() {
        
    }
}


extension ContentBuilder {
    
    func buildQuestionsOnly(examName: String) async throws -> Container {
        try await fetchAndStoreAllTopics(examName: examName)
        let selectedTopics = selectRandomTopics(limit: 3)
        await downloadQuestionsForTopics(selectedTopics, examName: examName)
        return container
    }
    
    private func fetchAndStoreAllTopics(examName: String) async throws {
        let allTopics = try await networkService.fetchTopics(context: examName)
        container.topics = allTopics.map { Topic(name: $0) }
        print("Fetched and stored all topics")
    }
    
    private func selectRandomTopics(limit: Int) -> [Topic] {
        guard container.topics.count >= limit else {
            return container.topics
        }
        return container.topics.shuffled().prefix(limit).map { $0 }
    }
    
    private func downloadQuestionsForTopics(_ topics: [Topic], examName: String) async {
        await withTaskGroup(of: Void.self) { group in
            for topic in topics {
                group.addTask {
                    do {
                        let questionDataArray = try await self.networkService.fetchQuestionData(examName: examName, topics: [topic.name], number: 1)
                        // Processing each question data object
                        questionDataArray.forEach { questionDataObject in
                            let questions = questionDataObject.questions.map { questionData in
                                Question(
                                    id: UUID(),
                                    topic: topic.name,
                                    questionContent: questionData.question,
                                    options: [questionData.options.a, questionData.options.b, questionData.options.c, questionData.options.d],
                                    correctOption: questionData.correctOption,
                                    questionNote: questionData.overview
                                )
                            }
                            
                            DispatchQueue.main.async {
                                // Append directly to the container questions
                                self.container.questions.append(contentsOf: questions)
                                print("Downloaded questions for topic: \(topic.name)")
                            }
                        }
                    } catch {
                        print("Failed to download questions for topic: \(topic.name), error: \(error)")
                    }
                }
            }
        }
    }
    
    
    func downloadAllFeedbackAudio(for voiceFeedback: VoiceFeedbackContainer) async -> VoiceFeedbackContainer {
        var updatedFeedback = voiceFeedback
        let messagesAndPaths: [(message: String, keyPath: WritableKeyPath<VoiceFeedbackContainer, String>)] = [
            (voiceFeedback.quizStartMessage, \VoiceFeedbackContainer.quizStartAudioUrl),
            (voiceFeedback.quizEndingMessage, \VoiceFeedbackContainer.quizEndingAudioUrl),
            (voiceFeedback.correctAnswerCallout, \VoiceFeedbackContainer.correctAnswerCalloutUrl),
            (voiceFeedback.skipQuestionMessage, \VoiceFeedbackContainer.skipQuestionAudioUrl),
            (voiceFeedback.errorTranscriptionMessage, \VoiceFeedbackContainer.errorTranscriptionAudioUrl),
            (voiceFeedback.finalScoreMessage, \VoiceFeedbackContainer.finalScoreAudioUrl)
        ]
        
        await withTaskGroup(of: (WritableKeyPath<VoiceFeedbackContainer, String>, String?).self) { group in
            for (message, keyPath) in messagesAndPaths {
                group.addTask {
                    let audioUrl = await self.downloadReadOut(readOut: message)
                    return (keyPath, audioUrl)
                }
            }
            for await (keyPath, audioUrl) in group {
                if let url = audioUrl {
                    updatedFeedback[keyPath: keyPath] = url
                }
            }
        }
        
        return updatedFeedback
    }
    
    private func buildAudioQuestionsV3(_ questions: [Question]) async {
        await withTaskGroup(of: Void.self) { group in
            for question in questions {
                group.addTask {
                    let context = "New Question!"
                    let readOut = self.formatQuestionForReadOut(questionContent: question.questionContent, options: question.options, context: context)
                    let overViewReadOut = self.formatOverviewForReadout(overviewString: question.questionNote)
                    
                    // Concurrent downloads for both audios
                    async let questionAudioUrl: String = self.downloadReadOut(readOut: readOut) ?? ""
                    async let questionNoteAudioUrl: String = self.downloadReadOut(readOut: overViewReadOut) ?? ""
                    
                    // Awaiting both tasks to complete
                    question.questionAudio = await questionAudioUrl
                    question.questionNoteAudio = await questionNoteAudioUrl
                }
            }
        }
    }
    
    
    func downloadAudioQuestions(for items: [DownloadableQuiz]) async {
        var updatedItems = [(DownloadableQuiz, String, String)]()
        // Perform all downloads concurrently, collect results in an array
        await withTaskGroup(of: (DownloadableQuiz, String, String).self) { group in
            for item in items {
                group.addTask {
                    let contentAudio: String = await self.downloadReadOut(readOut: item.contentReadOut) ?? ""
                    let noteAudio: String = await self.downloadReadOut(readOut: item.noteReadOut) ?? ""
                    return (item, contentAudio, noteAudio)
                }
            }
            
            // Collect all updates safely
            for await (item, contentAudio, noteAudio) in group {
                updatedItems.append((item, contentAudio, noteAudio))
            }
        }
        
        // Apply the updates in a non-concurrent context
        for (var item, contentAudio, noteAudio) in updatedItems {
            item.contentAudioURL = contentAudio
            item.noteAudioURL = noteAudio
        }
    }
    
}



extension ContentBuilder {
    
    func buildQuestionContent(for examName: String) async throws -> Container {
        print("Building test Content")
        try await buildTopics(examName: examName)
        try await buildQuestionsProdEnv(examName: examName)
        await buildQuestionReadout()

        return container
    }
    
    func alternateBuildTestContent(for examName: String) async throws -> Container {
        print("Building test Content")
        try await buildTestTopics(examName: examName)
        try await buildTestQuestions(examName: examName)
        await buildAudioQuestions()
        
        return container
    }
    
    
    func buildTestTopics(examName: String) async throws {
        
        let topics = try await networkService.testTopics()
        
        topics.forEach { topic in
            let containerTopic = Topic(name: topic)
            container.topics.append(containerTopic)
        }
    }
    
    func buildTestQuestions(examName: String) async throws {
        // Fetch the single QuestionDataObject
        let questionDataObject = try await networkService.testQuestionData()
        print("Content Builder Data recieved from network Service: \(questionDataObject)")
        
        // Iterate over the questions array within the QuestionDataObject
        questionDataObject.questions.forEach { questionData in
            // Map the options from the QuestionData.options struct to an array of strings
            let optionsArray = [questionData.options.a, questionData.options.b, questionData.options.c, questionData.options.d]
            
            let newContainerQuestion = Question(id: UUID())
            newContainerQuestion.questionContent = questionData.question
            newContainerQuestion.options = optionsArray
            newContainerQuestion.correctOption = questionData.correctOption
            
            // Assuming `contentQuestions` is an array you're appending to
            temporaryQuestionContent.append(newContainerQuestion)
           
        }
    }
    
    func buildAudioQuestions() async {
        await withTaskGroup(of: Void.self) { group in
            for (index, question) in temporaryQuestionContent.enumerated() {
                group.addTask {
                    let context = self.determineContext(for: index, totalCount: self.temporaryQuestionContent.count)
                    let readOut = self.formatQuestionForReadOut(questionContent: question.questionContent, options: question.options, context: context)
                    let overViewReadOut = self.formatOverviewForReadout(overviewString: question.questionNote)
                    
                    let audioUrl = await self.downloadReadOut(readOut: readOut) ?? ""
                    let questionNoteAudioUrl = await self.downloadReadOut(readOut: overViewReadOut)
                   
                    let finishedQuestion = Question(id: UUID())
                    finishedQuestion.questionContent = question.questionContent
                    finishedQuestion.topic = question.topic
                    finishedQuestion.options = question.options
                    finishedQuestion.correctOption = question.correctOption
                    finishedQuestion.questionAudio = audioUrl
                    finishedQuestion.questionNoteAudio = questionNoteAudioUrl ?? ""
                    
                    // Safely append to builtQuestions
                    self.container.questions.append(finishedQuestion)
                    print("Content Builder processed: \(self.container.questions.count) Questions with audio files")
                }
            }
        }
    }
    
    func buildQuestionReadout() async {
        await withTaskGroup(of: Void.self) { group in
            for (index, question) in temporaryQuestionContent.enumerated() {
                group.addTask {
                    let context = self.determineContext(for: index, totalCount: self.temporaryQuestionContent.count)
                    let readOut = self.formatQuestionForReadOut(questionContent: question.questionContent, options: question.options, context: context)
                    
                    
                    let finishedQuestion = Question(id: UUID())
                    finishedQuestion.questionContent = question.questionContent
                    finishedQuestion.topic = question.topic
                    finishedQuestion.options = question.options
                    finishedQuestion.correctOption = question.correctOption
                    finishedQuestion.questionNote = readOut
                    
                    // Safely append to builtQuestions
                    self.container.questions.append(finishedQuestion)
                    print("Content Builder processed: \(self.container.questions.count) Questions with audio files")
                }
            }
        }
    }
}


protocol DownloadableQuiz {
    var contentReadOut: String { get }
    var noteReadOut: String { get }
    var contentAudioURL: String { get set }
    var noteAudioURL: String { get set }
}
