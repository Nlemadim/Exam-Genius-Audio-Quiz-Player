//
//  TestData.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/15/24.
//

import Foundation

extension NetworkService {
    
    func testTopics() async throws -> [String] {
        print("Starting to fetch mock topic data...")

        updateNetworkStatus?(.fetchingTopics)
        
        // Path to the MockTopics.json file in your project bundle
        guard let path = Bundle.main.path(forResource: "MockTopics", ofType: "json") else {
            print("Mock file not found in bundle.")
            updateNetworkStatus?(.errorDownloadingContent("Mock file not found"))
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock file not found"])
        }
        
        do {
            print("Found mock data file at path: \(path)")
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            print("Successfully loaded mock data. Attempting to decode...")
            
            let topicsContainer = try JSONDecoder().decode(TopicsContainer.self, from: data)
            
            print("Decoding successful. Topics found: \(topicsContainer.topics)")
            updateNetworkStatus?(.downloaded)
            return topicsContainer.topics
        } catch {
            print("Error loading or decoding mock data: \(error)")
            updateNetworkStatus?(.errorDownloadingContent(error.localizedDescription))
            throw error
        }
    }

    func testQuestionData() async throws -> QuestionDataObject {
        print("NetworkService Started fetching mock question data from local JSON file")

        // Assuming your JSON file is named "MockQuestions.json" and it's added to the project's bundle
        guard let path = Bundle.main.path(forResource: "MockQuestions", ofType: "json") else {
            print("MockQuestions.json file not found in bundle.")
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "MockQuestions.json file not found"])
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            print("Successfully loaded mock question data. Attempting to decode...")
            print(data)

            // Decode the mock data to your QuestionDataObject model, adjusted for single object
            let decodedData = try JSONDecoder().decode(QuestionDataObject.self, from: data)
            print("Decoding successful. Number of questions decoded: \(decodedData.questions.count)")
            print(decodedData)

            // Return the decoded QuestionDataObject
            return decodedData
        } catch {
            print("Error loading or decoding mock question data: \(error)")
            throw error
        }
    }
}


struct TopicsContainer: Decodable {
    let topics: [String]
}
