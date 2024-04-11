//
//  Test.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/24/24.
//

import SwiftUI
import SwiftData

struct UserHomePage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @StateObject private var generator = ColorGenerator()
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    @State private var path = [AudioQuizPackage]()
    @State private var expandSheet: Bool = false
    @State private var bottomSheetOffset = -UIScreen.main.bounds.width
    @State private var selectedTab = 0
    @State private var selectedQuizPackage: AudioQuizPackage? {
        didSet {
            // Automatically present and expand the bottom sheet when a quiz package is selected
            if selectedQuizPackage != nil {
                withAnimation {
                    expandSheet = true
                }
            }
        }
    }
    @State var selectedCategory: ExamCategory? {
        didSet {
            print("Category selected: \(selectedCategory?.rawValue ?? "None")")
        }
    }
    
    @Namespace private var animation
    
    let categories = ExamCategory.allCases
    
    var filteredAudioQuizCollection: [AudioQuizPackage] {
        audioQuizCollection.filter { quiz in
            guard let selectedCat = selectedCategory else {
                return true // Show all quizzes if no category is selected
            }
            return quiz.category.contains { $0.rawValue == selectedCat.rawValue }
        }
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                pageContent()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                ExploreAudioQuizView()
                    .tabItem {
                        Label("Explore", systemImage: "globe")
                    }
                    .tag(1)
                
                // Add more tabs as needed
            }
            .zIndex(0) // Ensures tab content is layered below the custom nav bar
            
            
            
//            if expandSheet {
//                bottomSheetView()
//                    .offset(x: bottomSheetOffset, y: 0) // Apply the horizontal offset
//                    .onAppear {
//                        withAnimation(.easeOut(duration: 0.5)) {
//                            bottomSheetOffset = 0 // Move to center
//                        }
//                    }
//                    .onDisappear {
//                        bottomSheetOffset = -UIScreen.main.bounds.width // Reset when disappearing
//                    }
//            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.black
        }
    }
    
    @ViewBuilder
    private func pageContent() -> some View {
        NavigationStack(path: $path) {
            VStack(spacing: 5) {
                customNavigationBar()
                
                
                TabView {
                    ForEach(filteredAudioQuizCollection, id: \.self) { quiz in
                        AudioQuizPackageView(quiz: quiz) 
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // Page style without index display
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                //.frame(width: 350, height: 400)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                await loadDefaultCollection()
            }
            .background(
                Image("Logo")
                    .blur(radius: 2.0, opaque: false)
                    .offset(x: 130)
            )
        }
    }
    
    @ViewBuilder
    private func customNavigationBar() -> some View {
        CustomNavigationBar2(categories: categories, selectedCategory: $selectedCategory)
        //.offset(y: -70)
    }
    
//    @ViewBuilder
//    private func bottomSheetView() -> some View {
//        // Full implementation of your bottom sheet, including logic for minimizing and expanding
//        ZStack {
//            if expandSheet {
//                FullScreenQuizPlayer(expandSheet: $expandSheet, animation: animation)
//                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 1000)))
//            } else {
//                BottomMiniPlayer()
//                    .onTapGesture {
//                        withAnimation {
//                            expandSheet = true
//                        }
//                    }
//            }
//        }
//        .animation(.default, value: expandSheet)
//        .transition(.slide)
//    }
    
    @ViewBuilder
    private func BottomMiniPlayer() -> some View {
        // Implement the minimized version of the bottom sheet here
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.6))
                .frame(height: 70)
                .overlay {
                    // Content of the BottomMiniPlayer
                }
            // Add any additional overlays or components as needed
        }
    }
    
    func loadDefaultCollection() async {
        guard audioQuizCollection.isEmpty else { return }
        
        let collection = DefaultDatabase().getAllExamDetails()
        collection.forEach { examDetail in
            
            let newPackage = AudioQuizPackage(from: examDetail)
            //print(newPackage.category)
            
            modelContext.insert(newPackage)
            try! modelContext.save()
        }
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    return  UserHomePage()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, PerformanceModel.self], inMemory: true)
    
}


/** message.badge.waveform
 message.badge.waveform.fill
 bubble.right.fill
 bubble.fill
 waveform
 play.desktopcomputer
 desktopcomputer.trianglebadge.exclamationmark
 desktopcomputer
 
     
     ContentUnavailableView(
         "You Haven't built a Quiz yet",
         systemImage: "book.and.wrench.fill",
         description: Text("You need to buld a quiz to see the questions")
     )
 
 
 //MARK: Question Content View
 Text("\(questionModel.questionContent)")
     .font(.title3)
     .fontWeight(.semibold)
     .foregroundStyle(!isAnswered ? .black : .gray)
     .lineLimit(6, reservesSpace: true)
     .frame(maxWidth: .infinity, alignment: .topLeading)
     .padding(.horizontal, 5)
     .onChange(of: questionModel.questionContent, initial: isAnswered) { oldValue,_ in
         updateView()
     }
 
 ForEach(questionModel.options, id: \.self) { option in
     optionButton(questionModel: questionModel, option: option)
         .padding(.horizontal, 5)
 }
    
 
 Spacer()
 
 
 **/


struct QuizViewTest: View {
    @Binding var expandSheet: Bool
    @State private var offsetY: CGFloat = 0
    @State private var animateContent: Bool = false
    @State var isAnswered: Bool = false
    @State private var viewUpdateID = UUID()
    var animation: Namespace.ID
    var user: User
    
    var body: some View {
            
            GeometryReader {
                let size = $0.size
                let safeArea = $0.safeAreaInsets
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                        .fill(.teal)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                                .fill(.teal.gradient)
                                .opacity(animateContent ? 1 : 0)
                        })
                    
                        
                        VStack(spacing: 10) {
                            VStack(spacing: 5) {
                                Image(user.audioQuizPackage?.imageUrl ?? "Logo")
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .cornerRadius(20)
                                    .padding()
                                
                                Text(user.audioQuizPackage?.name ?? "Select an audio quiz")
                                    .lineLimit(2, reservesSpace: true)
                                    .multilineTextAlignment(.center)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .hAlign(.center)
                                    .padding()
                            }
                            .frame(height: 300)
                            .padding()
                            .padding(.horizontal, 40)
                            .hAlign(.center)
                            .overlay(alignment: .top) {
                                PlayerContentInfo(animation: animation, expandSheet: $expandSheet)
                                    .allowsHitTesting(false)
                                    .opacity(animateContent ? 0 : 1)
                            }
                            .matchedGeometryEffect(id: "ICONIMAGE", in: animation)
                            .padding(.horizontal, 5)
                            
                            //MARK: Quiz Visualizer
                            HStack {
                                Text("Question: 5 of 15".uppercased())
                                    .font(.callout)
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 5)
                            
                        }
                        .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                        .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .clipped()
                    
                    
                }
                .contentShape(Rectangle())
                .offset(y: offsetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let translationY = value.translation.height
                            offsetY = (translationY > 0 ? translationY : 0)
                        }).onEnded({ value in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if offsetY > size.height * 0.3 {
                                    expandSheet = false
                                    animateContent = false
                                } else {
                                    offsetY = .zero
                                }
                            }
                        })
                )
                .ignoresSafeArea(.container, edges: .all)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.35)) {
                    animateContent = true
                }
            }
    }
    
    private func updateView() {
        isAnswered.toggle()
    }
    
    @ViewBuilder
    private func optionButton(questionModel: Question, option: String) -> some View {
        let optionColor = colorForOption(option: option, correctOption: questionModel.correctOption, userAnswer: "\(questionModel.selectedOption)")
        
        Button(action: {
            questionModel.selectedOption = option
            isAnswered.toggle()
            //quizPlayer.saveAnswer(for: questionModel.id, answer: questionModel.selectedOption)
        }) {
            Text(option)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(optionColor.opacity(0.15)))
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(optionColor.opacity(optionColor == .black ? 0.15 : 1), lineWidth: 2)
                }
        }
        .disabled(isAnswered && option != questionModel.selectedOption)
    }
    
    private func colorForOption(option: String, correctOption: String, userAnswer: String) -> Color {
        
        if userAnswer.isEmpty {
            return .black
        } else if option == correctOption {
            return .green
        } else if option == userAnswer {
            return .red
        } else {
            return .black
        }
    }
}
