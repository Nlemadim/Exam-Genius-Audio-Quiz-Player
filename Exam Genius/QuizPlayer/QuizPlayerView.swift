//
//  QuizPlayerView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/18/24.
//

import SwiftUI
import SwiftData
import Combine
import AVKit


struct QuizPlayerView: View {
    @EnvironmentObject var quizPlayerObserver: QuizPlayerObserver
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @StateObject private var generator = ColorGenerator()
    
    @State private var currentQuestion: Question?
    @State var interactionState: InteractionState = .idle
    @State private var selectedQuizPackage: DownloadedAudioQuizContainer?
    @State var configuration: QuizViewConfiguration?
    @Binding var audioQuiz: DownloadedAudioQuizContainer
    @State var downloadedQuiz: DownloadedAudioQuizContainer?
    
    @State private var expandSheet: Bool = false
    @State var isDownloading: Bool = false
    @State var isPlaying: Bool = false
    @State private var playTapped: Bool = false
    @State private var nextTapped: Bool = false
    @State private var repeatTapped: Bool = false
    @State private var presentMicModal: Bool = false
    @State var presentConfirmationModal: Bool = false
    
    @State var currentQuestionIndex: Int = 0
    @State var selectedOption: String = ""
    
    @Namespace private var animation
    
    @State var backgroundImage: String = "Logo"
    
    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [generator.dominantBackgroundColor, .black]), startPoint: .top, endPoint: .bottom)
                    )
                
                VStack(alignment: .center) {
                    Image(audioQuiz.quizImage/*selectedQuizPackage?.imageUrl ?? "Logo"*/)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
                .frame(height: 280)
                .blur(radius: 60)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 5) {
                            Image(audioQuiz.quizImage/*selectedQuizPackage?.imageUrl ?? "Logo"*/)
                                .resizable()
                                .frame(width: 250, height: 250)
                                .cornerRadius(20)
                                .padding()
                            
                            Text(audioQuiz.name/*selectedQuizPackage?.name ?? ""*/)
                                .lineLimit(2, reservesSpace: true)
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .padding()
                                .hAlign(.center)
                                .offset(y: -30)
                        }
                        .frame(height: 300)
                        .padding()
                        .padding(.horizontal, 40)
                        .hAlign(.center)
                    }
                    .padding()
                    
                   
                    
                    HStack {
                        Text("Now Playing")
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                        
                    
                    Divider()
                        .foregroundStyle(generator.dominantLightToneColor)
                        .activeGlow(generator.dominantLightToneColor, radius: 1)
                    
                    VStack {
                        
                        NowPlayingView(currentquiz: currentQuiz(), quizPlayerObserver: quizPlayerObserver, questionCount: 25, currentQuestionIndex: 1, color: generator.dominantLightToneColor, interactionState: $interactionState)
                       
                    }
                    .padding()
                    .padding(.horizontal)
                    
                    Divider()
                        .foregroundStyle(generator.dominantLightToneColor)
                        .activeGlow(generator.dominantLightToneColor, radius: 1)
                    
                    
                    
                    Rectangle()
                        .fill(.black)
                        .frame(height: 100)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack(spacing: -20) {
                        Text("Voice")
                        Button(action: { /*  shareAction() */}, label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20.0)
                        })
                    }
                }
            }
        }
    }
    
    func currentQuiz() -> DownloadedAudioQuizContainer {
        let audioQuiz: DownloadedAudioQuizContainer = DownloadedAudioQuizContainer(name: "Quick Math", quizImage: "Math-Exam")
        return audioQuiz
    }
}

struct NowPlayingView: View {
    var currentquiz: DownloadedAudioQuizContainer
    var quizPlayerObserver: QuizPlayerObserver
    var questionCount: Int
    var currentQuestionIndex: Int
    var color: Color
    @Binding var interactionState: InteractionState
    var body: some View {
        
        HStack {
            VStack(spacing: 4) {
                Image(currentquiz.quizImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    
            }
            .frame(height: 150)
            
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(currentquiz.name.uppercased())
                    .font(.title3)
                    .fontWeight(.semibold)
                    
                
                HStack(spacing: 12) {
                    Text("Audio Quiz")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    
                    Image(systemName: "headphones")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                
                Text("Question: \(currentQuestionIndex)/ \(questionCount)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Spacer()
                    CircularPlayButton(interactionState: $interactionState, isDownloading: .constant(false), color: color, playAction: {})
                }
                .padding()
            }
            .padding(.top, 5)
            .frame(height: 150)
            .padding(.horizontal, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}


//
//extension QuizPlayerView {
//    class QuizSetter: ObservableObject, QuizPlayerDelegate {
//        @Published var configuration: QuizViewConfiguration?
//        
//        private var quizPlayer = QuizPlayer.shared
//        private var isFinishedPlaying = false
//        private var isNowPlaying = false
//        
//       init() {
//            self.quizPlayer.delegate = self
//        }
//        
//        func quizPlayerDidFinishPlaying(_ player: QuizPlayer) {
//            self.isFinishedPlaying = true
//        }
//    
//        var playPauseQuiz: (() -> Void)?
//        var nextQuestion: (() -> Void)?
//        var repeatQuestion: (() -> Void)?
//        var endQuiz: (() -> Void)?
//        
//        func setActions(playPauseQuiz: (() -> Void)? = nil,
//                        nextQuestion: (() -> Void)? = nil,
//                        repeatQuestion: (() -> Void)? = nil,
//                        endQuiz: (() -> Void)? = nil) {
//            self.playPauseQuiz = playPauseQuiz
//            self.nextQuestion = nextQuestion
//            self.repeatQuestion = repeatQuestion
//            self.endQuiz = endQuiz
//        }
//        
//        func loadQuizConfiguration(quizPackage: AudioQuizPackage?) {
//            guard let quizPackage = quizPackage else {
//                return
//            }
//            
//            let questions = QuestionVisualizerMaker.createVisualizers(from: quizPackage.questions)
//            let newConfiguration = QuizViewConfiguration(
//                imageUrl: quizPackage.imageUrl,
//                name: quizPackage.name,
//                shortTitle: quizPackage.acronym,
//                questions: questions
//                
//            )
//            
//            self.configuration = newConfiguration
//            print("Quiz Setter has Set Configurations")
//        }
//    }
//}
//        
//
//
#Preview {
    @State var package = DownloadedAudioQuizContainer(name: "Quick Math", quizImage: "Math-Exam")
    let user = User()
    let appState = AppState()
    let observer = QuizPlayerObserver()
    return QuizPlayerView(audioQuiz: $package)
        .environmentObject(user)
        .environmentObject(appState)
        .environmentObject(observer)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self], inMemory: true)
  
}


