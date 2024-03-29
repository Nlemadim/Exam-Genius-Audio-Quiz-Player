//
//  ContentBuilder.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/8/24.
//

import Foundation

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
        await buildAudioQuestions()

        return container
    }
    
    func alternateBuildTestContent(for examName: String) async throws -> Container {
        print("Building test Content")
        try await buildTestTopics(examName: examName)
        try await buildTestQuestions(examName: examName)
        await buildAudioQuestions()
        
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
    
    private func buildTestTopics(examName: String) async throws {
        
        let topics = try await networkService.testTopics()
        
        topics.forEach { topic in
            let containerTopic = Topic(name: topic)
            container.topics.append(containerTopic)
        }
    }
    
    private func buildTestQuestions(examName: String) async throws {
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
    
    private func buildQuestionsProdEnv(examName: String) async throws {
        guard self.container.topics.count >= 3 else {
            throw NSError(domain: "ContentBuilder", code: 1, userInfo: [NSLocalizedDescriptionKey: "Not enough topics returned from the server."])
        }
        //MARK: Using RandonmTopics for example Quiz demo
        let randomTopics = container.topics.shuffled().prefix(1)
        let questionTopics = randomTopics.map{ $0.name }
        
        let questionDataObject = try await networkService.fetchQuestionData(examName: examName, topics: questionTopics, number: 3)
        print("Content Builder Data recieved from network Service: \(questionDataObject)")
        
        questionDataObject.forEach { questionDataObject in
            questionDataObject.questions.forEach { questionData in
                let optionsArray = [questionData.options.a, questionData.options.b, questionData.options.c, questionData.options.d]
                
                let newContainerQuestion = Question(id: UUID())
                newContainerQuestion.questionContent = questionData.question
                newContainerQuestion.options = optionsArray
                newContainerQuestion.correctOption = questionData.correctOption
                
                temporaryQuestionContent.append(newContainerQuestion)
            }
        }
    }

    private func buildAudioQuestions() async {
        await withTaskGroup(of: Void.self) { group in
            for (index, question) in temporaryQuestionContent.enumerated() {
                group.addTask {
                    let context = self.determineContext(for: index, totalCount: self.temporaryQuestionContent.count)
                    let readOut = self.formatQuestionForReadOut(questionContent: question.questionContent, options: question.options, context: context)
                    let audioUrl = await self.downloadReadOut(readOut: readOut) ?? ""
                   
                    let finishedQuestion = Question(id: UUID())
                    finishedQuestion.questionContent = question.questionContent
                    finishedQuestion.topic = question.topic
                    finishedQuestion.options = question.options
                    finishedQuestion.correctOption = question.correctOption
                    finishedQuestion.questionAudio = audioUrl
                    
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
            return "Next Question"
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
    
    private func downloadReadOut(readOut: String) async -> String? {
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
    
    private func saveAudioDataToFile2(_ data: Data) -> String? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".mp3"  // This is what you'll save and use later
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            // Return just the file name instead of the full URL
            return fileName
        } catch {
            print("Error saving audio file: \(error)")
            return nil
        }
    }

    
    private func questionContentPrompt(examName: String, topics: [String], numberOfQuestions: Int) -> String {
        return """
               \(examName)
               \(topics.joined(separator: ","))
               \(numberOfQuestions)
               
               """
    }
    
    private func topicsContentPrompt(examName: String, numberOfTopics: Int? = nil) -> String {
        if let numberOfQuestions = numberOfTopics {
            return """
                   \(examName)
                   \(numberOfQuestions)
                   
                   """
        } else {
            return """
                   \(examName)
                   """
        }
    }
    
    private var topicsRolePrompt: String {
        return """
            
               You are a helpful Assistant specializing in Professional Exam STUDY Topics
               Your Job is to help users identify relevant educational topics relevant for study in order to pass the exam.
            
               Given an exam name
               Given a Number of Topics
               GENERATE GIVEN NUMBER TOPICS
               
               Given ONLY an Exam
               GENERATE TOPICS VERY EXTENSIVELY
               

               The context will usually take the form of a professional standard or non-standard exam.
               Gleaming from context generate very relevant educational topics for study to pass this exam.
                

               Return your output as a single collection of strings separated by: ,
            
               Example
               Given: ACT Exam
               Given: 3 Topics
            
               OUTPUT ONLY TOPICS
               Advanced Algebra","Coordinate Geometry","Plane Geometry"
            
               DO NOT RETURN ANYTHING BUT A LIST OF TOPICS RELEVANT TO PASS THIS EXAM
            
            """
    }
    
    private var questionRolePrompt: String {
        
        return """
               You are a helpful Assistant generating practice multiple-choice exam questions.
               
               Given an exam name;
               Given a topic or a list of topics related to the exam;
               Given a number of questions;
               
               Generate GIVEN NUMBER of professional practice exam questions
               

               Your question should efficiently test the depth of knowledge of the user as it relates to that topic.
               Please ensure that the questions are challenging, substantial and expressive, using real life scenarios to give the question more depth, context and relevance to the exam and the knowledge it seeks to test.
               
               Multi Choice Options
               - Add multi choice Answers to your Questions NOT EXCEEDING A - D (Four Options)
               - Make the options engaging and complex without being intuitive or easy to guess. 
               
               Answer: 
               - Provide the correct answer among the options: A or B or C or D
               
               Overview:
               - EXTENSIVELY EDUCATE on the subject matter, Topic or Question relative to the correct answer.
               - TEACH a User ALL they need to know about the Specific Question and Topic.
               - Make your overview engaging, creative, expressive and professional ensuring to pass along the most important information regarding the question and or topic.
               
               RETURN ONLY NUMBER OF QUESTIONS REQUESTED 
               
               DO NOT NUMBER THE QUESTIONS
               
               FOR EASY PARSING PLEASE RETURN WITH SEPERATE HEADERS
               
               DO NOT USE ANY SPECIAL CHARACTERS BEFORE OR AFTER HEADERS
               
                Topic
                Question
                Options
                CorrectOption
                Overview
               
               EXAMPLE FORMAT
               Topic
               Maths
               
               Question
               One plus One
               
               Options
               A: 1
               B: 7
               C: 10
               D: 2
               
               CorrectOption
               D
               
               Overview
               Because one plus one is two
               
               IF MULTIPLE QUESTIONS, ADD A LINE OF SPACE BETWEEN QUESTIONS
               
               """
    }
    
}

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
