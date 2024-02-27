//
//  NetworkService.swift
//  SwiftDataComponent
//
//  Created by Tony Nlemadim on 1/12/24.
//

import Foundation
import SwiftUI
import AVFoundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    var updateNetworkStatus: ((NetworkStatus) -> Void)?
    
    func fetchAudioData(content: String) async throws -> Data {
        // Construct the URL with query parameters for the API call
        var components = URLComponents(string: Config.audioRequestURL)
        components?.queryItems = [
            URLQueryItem(name: "content", value: content)
        ]
        
        guard let apiURL = components?.url else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Fetch the response from your API
        let (data, response) = try await URLSession.shared.data(for: request)
                
        // Check the HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse, userInfo: ["Description": "Invalid HTTP response"])
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse, userInfo: ["Description": "Server returned status code \(httpResponse.statusCode)"])
        }
        
        // Decode the base64 string to Data
        guard let decodedData = Data(base64Encoded: data) else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
        }
        
        return decodedData
    }
    
    func fetchTopics(context: String) async throws -> [String] {
            // Indicate that fetching topics has started
            updateNetworkStatus?(.fetchingTopics)

            // Your base URL
            let baseUrl = Config.topicRequestURL 
            guard var urlComponents = URLComponents(string: baseUrl) else {
                updateNetworkStatus?(.errorDownloadingContent("Invalid URL"))
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }

            urlComponents.queryItems = [URLQueryItem(name: "context", value: context)]

            guard let url = urlComponents.url else {
                updateNetworkStatus?(.errorDownloadingContent("Failed to construct URL"))
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL"])
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, let rawResponse = String(data: data, encoding: .utf8) {
                    print("Response HTTP Status code: \(httpResponse.statusCode)")
                    print("Raw server response: \(rawResponse)")
                }

                let jsonResponse = try JSONDecoder().decode([String: [String]].self, from: data)
                guard let topics = jsonResponse["topics"] else {
                    updateNetworkStatus?(.errorDownloadingContent("Key 'topics' not found in response"))
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Key 'topics' not found in response"])
                }

                // Indicate that fetching topics has finished
                updateNetworkStatus?(.downloaded) // Consider adding a new case for successful completion if needed

                return topics
            } catch {
                updateNetworkStatus?(.errorDownloadingContent(error.localizedDescription))
                throw error
            }
        }
    
//    func fetchTopics(context: String) async throws -> [String] {
//       
//         //Base URL
//        let baseUrl = Config.topicRequestURL
//        // Append query parameter
//        guard var urlComponents = URLComponents(string: baseUrl) else {
//            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//        }
//
//        urlComponents.queryItems = [URLQueryItem(name: "context", value: context)]
//
//        // Check if URL is valid
//        guard let url = urlComponents.url else {
//            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL"])
//        }
//
//        // Create a URLRequest
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        // URLSession data task
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        // Log the raw server response
//        if let httpResponse = response as? HTTPURLResponse, let rawResponse = String(data: data, encoding: .utf8) {
//            print("Response HTTP Status code: \(httpResponse.statusCode)")
//            print("Raw server response: \(rawResponse)")
//        }
//
//        // Decode JSON
//        let jsonResponse = try JSONDecoder().decode([String: [String]].self, from: data)
//        guard let topics = jsonResponse["topics"] else {
//            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Key 'topics' not found in response"])
//        }
//
//        return topics
//    }
    
    func fetchImage(for quizName: String, retryCount: Int = 0) async throws -> String {
        print("Calling Network")
        var components = URLComponents(string: Config.imageRequestURL)
        components?.queryItems = [URLQueryItem(name: "examName", value: quizName)]
        
        guard let apiURL = components?.url else {
            throw NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                throw NSError(domain: "NetworkService", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch image with status code \(statusCode)"])
            }
            
            guard let imageB64 = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "NetworkService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
            }
            
            return imageB64
        } catch let error as NSError {
            if error.code == 429, retryCount < 3 { // Example retry logic for HTTP 429 errors
                let retryDelay = pow(2.0, Double(retryCount)) // Exponential backoff
                print("Retrying in \(retryDelay) seconds...")
                try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
                return try await fetchImage(for: quizName, retryCount: retryCount + 1)
            } else {
                throw error
            }
        }
    }
    
    
    //MARK: ENTRY POINT
    func fetchSampleAudioQuiz()  async throws {}
}


enum NetworkStatus {
    case fetchingQuestions
    case fetchingTopics
    case buildingQuizPackage
    case fecthingAudioFiles
    case downloaded
    case errorDownloadingContent(String)
   // Includes an associated value for error description
    
    var description: String {
        switch self {
        case .fetchingQuestions:
            return "Fetching questions..."
        case .fetchingTopics:
            return "Fetching topics..."
        case .buildingQuizPackage:
            return "Building quiz package..."
        case .errorDownloadingContent(let errorMessage):
            return "Error downloading content: \(errorMessage)"
        case .fecthingAudioFiles:
            return "Downloading audio files"
        case .downloaded:
            return "Downloaded"
        }
    }
    
    static func ==(lhs: NetworkStatus, rhs: NetworkStatus) -> Bool {
        switch (lhs, rhs) {
        case (.fetchingQuestions, .fetchingQuestions),
            (.fetchingTopics, .fetchingTopics),
            (.buildingQuizPackage, .buildingQuizPackage),
            (.fecthingAudioFiles, .fecthingAudioFiles):
            return true
        case (.errorDownloadingContent(let a), .errorDownloadingContent(let b)):
            return a == b
        default:
            return false
        }
    }
}

//struct IdentifiableNetworkStatus: Identifiable {
//    let status: NetworkStatus
//    var id: String {
//        switch status {
//        case .fetchingQuestions, .fetchingTopics, .buildingQuizPackage, .fecthingAudioFiles:
//            return "\(status)"
//        case .errorDownloadingContent(let errorMessage):
//            return "error:\(errorMessage)"
//        
//        }
//    }
//}


