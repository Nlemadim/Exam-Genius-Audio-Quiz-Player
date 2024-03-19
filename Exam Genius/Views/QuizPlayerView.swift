//
//  QuizPlayerView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/18/24.
//

import SwiftUI
import SwiftData
import Combine

struct QuizPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    @StateObject private var generator = ColorGenerator()
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State private var isPlaying: Bool = false
    @State private var selectedTab = 0
    @State private var selectedQuizPackage: AudioQuizPackage?
    @State private var path = [AudioQuizPackage]()
    
    var cancellables = Set<AnyCancellable>()
    
    @Namespace private var animation
    
    let quizPlayer = QuizPlayer.shared
    
    @State var backgroundImage: String = "Logo"

    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, user.selectedQuizPackage == nil ? .themePurple: generator.dominantBackgroundColor.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .leading, spacing: 4.0) {
                        VStack(alignment: .leading, spacing: 4.0){
                            Text(user.selectedQuizPackage == nil ? "Not Playing" :"Currently Playing")
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                            HStack {
                                Text(user.selectedQuizPackage?.name.uppercased() ?? "No Quiz Selected!")
                                    .font(.footnote)
                                    .lineLimit(2, reservesSpace: true)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        .padding()
                        
                        TabView {
                            ForEach(0 ..< 5) { item in
                                CurrentQuizViewV2(image: user.selectedQuizPackage?.imageUrl ?? "IconImage",
                                                  buttonLabel: user.hasStartedQuiz ? "Resume" : nil,
                                                  color: !user.hasSelectedAudioQuiz ? .gray : generator.dominantBackgroundColor,
                                                  backgroundImage: "", numberOfQuestions: numberOfQuestions,
                                                  numberOfQuizzes: quizzesCompleted,
                                                  questionsAnswered: questionsAnswered,
                                                  highScore: highestScore,
                                                  numberOfTopics: numberOfTopics,
                                                  isDisabled: nil,
                                                  playButtonAction: { self.expandSheet.toggle(); selectedQuizPackage = user.selectedQuizPackage }
                               )
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 530)
                    }
            }
            
        }
        .fullScreenCover(isPresented: $expandSheet) {
            QuizView()
        }
        .onAppear {
            generator.updateDominantColor(fromImageNamed: backgroundImage)
        }
        .preferredColorScheme(.dark)
        
        var backgroundImage: String {
            return user.selectedQuizPackage?.imageUrl ?? "Logo"
        }

    }
    
    var numberOfTopics: Int {
        if let selectedPackage = user.selectedQuizPackage {
            let numberOfTopics = selectedPackage.topics.count
            return numberOfTopics
        }
        
        return 0
    }
    
    var numberOfQuestions: Int {
        if let selectedPackage = user.selectedQuizPackage {
            let numberOfTopics = selectedPackage.questions.count
            return numberOfTopics
        }
        
        return 0
    }
    
    var questionsAnswered: Int {
        let total = UserDefaultsManager.totalQuestionsAnswered()
        return total
    }
    
    var quizzesCompleted: Int {
        let total = UserDefaultsManager.numberOfQuizSessions()
        return total
    }
    
    var highestScore: Int {
        let total = UserDefaultsManager.userHighScore()
        return total
    }
}


#Preview {
    @State var package = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "USMLESTEP1-Exam")
    let user = User()
    let appState = AppState()
   return QuizPlayerView()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
  
}


