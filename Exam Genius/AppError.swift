//
//  AppError.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 6/11/24.
//

import Foundation
import SwiftUI

@MainActor
class ErrorManager: ObservableObject {
    @Published var currentError: AppError? = nil
    @Published var connectionError: AppError? = nil
    
    func handleError(_ error: AppError) {
        switch error {
        case .connectionError:
            connectionError = error
        default:
            currentError = error
        }
    }
    
    func clearError() {
        currentError = nil
        connectionError = nil
    }
}

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    
    // Specific Errors
    case quizContentError(description: String)
    case downloadError(description: String)
    case audioPlaybackError(description: String)
    case micTranscriptionError(description: String)
    
    // Generic Errors
    case connectionError(description: String)
    case externalError(description: String)
    
    var localizedDescription: String {
        switch self {
        case .quizContentError(let description):
            return "Quiz Content Error: \(description)"
        case .downloadError(let description):
            return "Download Error: \(description)"
        case .audioPlaybackError(let description):
            return "Audio Playback Error: \(description)"
        case .micTranscriptionError(let description):
            return "Mic Transcription Error: \(description)"
        case .connectionError(let description):
            return "No internet connection: \(description)"
        case .externalError(let description):
            return "External Error: \(description)"
        }
    }
    
    var userActionRequired: Bool {
        switch self {
        case .quizContentError, .connectionError, .externalError:
            return false
        case .downloadError, .audioPlaybackError, .micTranscriptionError:
            return true
        }
    }
    
    var alertTitle: String {
        switch self {
        case .quizContentError:
            return "Quiz Content Issue"
        case .downloadError:
            return "Download Issue"
        case .audioPlaybackError:
            return "Playback Issue"
        case .micTranscriptionError:
            return "Transcription Issue"
        case .connectionError:
            return "Connection Issue"
        case .externalError:
            return "External Issue"
        }
    }
    
    var alertActions: [String] {
        switch self {
        case .quizContentError, .connectionError, .externalError:
            return ["OK"]
        case .downloadError:
            return ["Retry", "Cancel"]
        case .audioPlaybackError:
            return ["Read with Siri", "Redownload Audio"]
        case .micTranscriptionError:
            return ["OK"]
        }
    }
    
    var displayNotification: Bool {
        switch self {
        case .connectionError:
            return true
        default:
            return false
        }
    }
}

struct ConnectionErrorView: View {
    let error: AppError
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}


struct ErrorTestView: View {
    @EnvironmentObject var errorManager: ErrorManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Button("Simulate Quiz Content Error") {
                    errorManager.handleError(.quizContentError(description: "Failed to load quiz content."))
                }
                Button("Simulate Download Error") {
                    errorManager.handleError(.downloadError(description: "Failed to download quiz data."))
                }
                Button("Simulate Audio Playback Error") {
                    errorManager.handleError(.audioPlaybackError(description: "Failed to play audio file."))
                }
                Button("Simulate Mic Transcription Error") {
                    errorManager.handleError(.micTranscriptionError(description: "Failed to transcribe audio."))
                }
                Button("Simulate Connection Error") {
                    errorManager.handleError(.connectionError(description: "No internet connection."))
                }
                Button("Simulate External Error") {
                    errorManager.handleError(.externalError(description: "No subscription available."))
                }
            }
            .navigationTitle("Error Simulation")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if let error = errorManager.connectionError, error.displayNotification {
                        ConnectionErrorView(error: error)
                            .opacity(error.displayNotification ? 1.0 : 0.0)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .alert(item: $errorManager.currentError) { error in
            Alert(
                title: Text(error.alertTitle),
                message: Text(error.localizedDescription),
                primaryButton: .default(Text(error.alertActions.first ?? "OK")) {
                    handleAlertAction(for: error, action: error.alertActions.first)
                },
                secondaryButton: error.alertActions.count > 1 ? .default(Text(error.alertActions[1])) {
                    handleAlertAction(for: error, action: error.alertActions[1])
                } : .cancel()
            )
        }
    }
    
    func handleAlertAction(for error: AppError, action: String?) {
        switch (error, action) {
        case (.downloadError, "Retry"):
            // Handle retry download
            print("Retrying download...")
        case (.downloadError, "Cancel"):
            // Handle cancel download
            print("Cancelling download...")
        case (.audioPlaybackError, "Read with Siri"):
            // Handle read with Siri
            print("Reading with Siri...")
        case (.audioPlaybackError, "Redownload Audio"):
            // Handle redownload audio
            print("Redownloading audio...")
        default:
            // Handle default action
            break
        }
        errorManager.clearError()
    }
}

#Preview {
    let errorManager = ErrorManager()
    
    return ErrorTestView()
        .environmentObject(errorManager)
}
