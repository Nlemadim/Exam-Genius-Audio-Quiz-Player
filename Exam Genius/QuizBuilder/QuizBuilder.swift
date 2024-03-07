//
//  QuizBuilder.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/27/24.
//

import Foundation
import SwiftUI
import SwiftData

extension AudioQuizPlaylistView {
    @Observable
    class QuizBuilder: ObservableObject {
        private let networkService: NetworkService = NetworkService.shared
        var modelContext: ModelContext? = nil
        var questionNumber: Int = 0
        
        func fetchTopicNames(context: String) async throws -> [String] {
            var topics = [String]()
            do {
                topics = try await networkService.fetchTopics(context: context)
                
            } catch {
                print("Error Fetching Topics: Desc; \(error.localizedDescription)")
                
            }
            return topics
        }
        
        func fetchPackageQuestions(examName: String, topics: [String], number: Int) async throws -> [QuestionResponse] {
            return try await networkService.fetchQuestions(examName: examName, topics: topics, number: number)
        }
        
        
        func buildSampleContent(examName: AudioQuizPackage) async -> AudioQuizContent {
            var content = AudioQuizContent(name: examName.name, topics: [], questions: [])
            var topicsCollection = [String]()

            do {
                topicsCollection = try await networkService.fetchTopics(context: examName.name)
                print("ContentBuilder has created: \(topicsCollection.count) Topics")
                
            } catch {
                print(error.localizedDescription)
                
            }
            
            
            content.topics.append(contentsOf: topicsCollection)
            
            var randomTopics: [String] = []

            if topicsCollection.count >= 5 {
                // If there are 5 or more topics, randomly select 5 unique topics
                randomTopics = topicsCollection.shuffled().prefix(3).map { $0 }
            } else {
                // If there are less than 5 topics, just shuffle and use as many as available
                randomTopics = topicsCollection.shuffled()
            }

            
            let promptContent = questionContentPrompt(examName: examName.name, topics: randomTopics, numberOfQuestions: 3)
            let questionsString = await networkService.fetchQuestionsLocally(prompt: promptContent, currentRole: questionRolePrompt)
            var formattedQuestion = parseQuizText(questionsString)
            
            // Fetch and assign audio URLs for each question
            for i in 0..<formattedQuestion.count {
                questionNumber += 1
                var question = formattedQuestion[i]
                let options = question.options.map { $0.option }
                let audioReadout = formatQuestionForReadOut(questionContent: question.question, options: options)
                //let audioReadout = formatQuestionForReadOut3(questionContent: question.question, options: options)
                
                // Await the downloadReadOut function to complete and then mutate
                let audioFileUrl = await downloadReadOut(readOut: audioReadout)
                question.questionAudio = audioFileUrl
                
                formattedQuestion[i] = question // Update the question with the audio URL
                print("Succesfully downloaded question:\(questionNumber) audiofile")
            }
            
            content.questions.append(contentsOf: formattedQuestion)
            
            print("ContentBuilder fetched: \(content.topics.count) Topics")
            print("ContentBuilder built: \(content.questions.count) Questions")
            
            formattedQuestion.forEach { question in
                print(question.topic)
                print(question)
            }
            
            return content
        }

        
        private func downloadReadOut(readOut: String) async -> String? {
            var fileUrl: String = ""
            do {
                let audioFile = try await networkService.fetchAudioData(content: readOut)
                let urlString = saveAudioDataToFile(audioFile)
                fileUrl = urlString?.path ?? ""
                print(fileUrl)
                
            } catch {
                print(error.localizedDescription) //MARK: TODO: Modify for retry
            }
            
            return fileUrl
        }
        
        private func saveAudioDataToFile(_ data: Data) -> URL? {
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let fileName = UUID().uuidString + ".mp3"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            print("ContentBuilder has saved audioFile Url path")
            
            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("Error saving audio file:", error)
                return nil // or handle the error appropriately
            }
        }
        
        private func formatQuestionForReadOut(questionContent: String, options: [String]) -> String {
            // Starting point for ASCII character 'A'
            let asciiOffset = Int("A".unicodeScalars.first!.value)
            
            var optionsText = ""
            for (index, option) in options.enumerated() {
                // Convert 0 -> A, 1 -> B, etc.
                if let asciiCode = UnicodeScalar(asciiOffset + index), let _ = Character(asciiCode).asciiValue {
                    
                    optionsText += "\(option)\n"
                }
            }
            
            let readOut = """
                          Question:
                          \(questionContent)
                          Options:
                          \(optionsText)
                          """
            
            print("Read out: \(readOut)")
            
            return readOut
        }
        
        private func formatQuestionForReadOut2(questionContent: String, options: [String]) -> String {
            let intro = "Here's your question: "
            let questionIntro = "\(questionContent)"
            
            var optionsText = "Your options are: "
            options.enumerated().forEach { index, option in
                let label = "\(Character(UnicodeScalar(Int("A".unicodeScalars.first!.value) + index)!))"
                optionsText += "\(label), \(option). "
            }
            
            let readOut = "\(intro)\(questionIntro) \(optionsText)"
            print(readOut)
            
            return readOut
        }

        
        private func formatQuestionForReadOut3(questionContent: String, options: [String]) -> String {
            return """
                   Question:\(questionNumber)
                   
                   \(questionContent)
                   
                   Options:
                   
                   A: \(options[0])
                   B: \(options[1])
                   C: \(options[2])
                   D: \(options[3])
                   
                   """
        }
        
        
        func updateQuestionGroup(package: [Question]) async -> [Question]  {
            guard !package.isEmpty else { return [] }
            var voicedQuestions: [Question] = []
            
            for question in package {
                questionNumber += 1
                await self.generateAudioQuestion(question: question)
                voicedQuestions.append(question)
            }
            
            return voicedQuestions
        }
        
        
        
        private func generateAudioQuestion(question: Question) async {
            let readOut = formatQuestionForReadOut(questionContent: question.questionContent, options: question.options)
            
            do {
                let audioFile = try await networkService.fetchAudioData(content: readOut)
                
                if let fileUrl = saveAudioDataToFile(audioFile) {
                    updateQuestionAudioContent(question: question, audioFilePath: fileUrl.path)
                }
                
            } catch {
                print(error.localizedDescription) //MARK: TODO: Modify for retry
            }
        }
        
        private func updateQuestionAudioContent(question: Question, audioFilePath: String) {
            question.questionAudio = audioFilePath
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
        
        func parseQuizText(_ text: String) -> [QuestionResponse] {
            // Split the entire text by double newlines which might denote new sections
            let sections = text.components(separatedBy: "\n\n").filter { !$0.isEmpty }
            var questions: [QuestionResponse] = []
            
            var currentTopic = ""
            var currentQuestion = ""
            var currentOptions: [QuestionResponse.Option] = []
            var currentCorrectOption = ""
            var currentOverview: String?
            
            for section in sections {
                if section.starts(with: "Topic") {
                    currentTopic = section.replacingOccurrences(of: "Topic\n", with: "")
                } else if section.starts(with: "Question") {
                    // Remove the prefix and any leading numbering
                    let questionText = section.replacingOccurrences(of: "Question\n", with: "")
                    currentQuestion = questionText.trimmingCharacters(in: .whitespaces).removingLeadingNumber()
                } else if section.starts(with: "Options") {
                    let optionsText = section.replacingOccurrences(of: "Options\n", with: "")
                    let optionsLines = optionsText.split(separator: "\n").map(String.init)
                    if optionsLines.count == 4 { // Ensure exactly 4 options
                        currentOptions = optionsLines.map { QuestionResponse.Option(option: $0) }
                        print("QuestionParser has formatted \(currentOptions.count) Answer Options")
                    } else {
                        print("Error: Question does not have 4 options")
                        continue // Skip this question or handle error appropriately
                    }
                } else if section.starts(with: "Correct Option") {
                    currentCorrectOption = section.replacingOccurrences(of: "Correct Option\n", with: "")
                } else if section.starts(with: "Overview") {
                    currentOverview = section.replacingOccurrences(of: "Overview\n", with: "")
                    
                    // At this point, we have collected all parts of a question, add it to the list
                    let question = QuestionResponse(topic: currentTopic, question: currentQuestion, options: currentOptions, correctOption: currentCorrectOption, overview: currentOverview)
                    questions.append(question)
                    
                    // Reset for the next question
                    currentQuestion = ""
                    currentOptions = []
                    currentCorrectOption = ""
                    currentOverview = nil
                }
            }
            
            return questions
        }

        
//        func parseQuizText(_ text: String) -> [QuestionResponse] {
//            // Split the entire text by double newlines which might denote new sections
//            let sections = text.components(separatedBy: "\n\n").filter { !$0.isEmpty }
//            var questions: [QuestionResponse] = []
//            
//            var currentTopic = ""
//            var currentQuestion = ""
//            var currentOptions: [QuestionResponse.Option] = []
//            var currentCorrectOption = ""
//            var currentOverview: String?
//            
//            for section in sections {
//                if section.starts(with: "Topic") {
//                    currentTopic = section.replacingOccurrences(of: "Topic\n", with: "")
//                } else if section.starts(with: "Question") {
//                    currentQuestion = section.replacingOccurrences(of: "Question\n", with: "")
//                } else if section.starts(with: "Options") {
//                    let optionsText = section.replacingOccurrences(of: "Options\n", with: "")
//                    let optionsLines = optionsText.split(separator: "\n").map(String.init)
//                    print("QuestionParser has formatted \(currentOptions.count) Answer Options")
//                    currentOptions = optionsLines.map { QuestionResponse.Option(option: $0) }
//                } else if section.starts(with: "Correct Option") {
//                    currentCorrectOption = section.replacingOccurrences(of: "Correct Option\n", with: "")
//                } else if section.starts(with: "Overview") {
//                    currentOverview = section.replacingOccurrences(of: "Overview\n", with: "")
//                    
//                    // At this point, we have collected all parts of a question, including the topic, add it to the list
//                    let question = QuestionResponse(topic: currentTopic, question: currentQuestion, options: currentOptions, correctOption: currentCorrectOption, overview: currentOverview)
//                    questions.append(question)
//                    
//                    // Reset for the next question (if any)
//                    currentQuestion = ""
//                    currentOptions = []
//                    currentCorrectOption = ""
//                    currentOverview = nil
//                }
//            }
//            
//            return questions
//        }

        
        
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
}




//let topicsPrompt = topicsContentPrompt(examName: examName.name, numberOfTopics: 3)
//            let topicsString = await networkService.fetchTopicsLocally(prompt: "Given: \(examName.name) Exam. Generate study topics for a student preparing to take this exam. If any topic has subtopics list as induvidual topic. Example: Maths, Addition, subtraction, division, multiplication, Fractions etc. DO NOT NUMBER TOPICS. FOR EASY PARSING RETURN A SINGLE STRING OF TOPICS SEPARATED BY A COMMA")
