//
//  LibraryPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/3/24.
//

import SwiftUI
import SwiftData

//struct LibraryPage: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject var user: User
//    @EnvironmentObject var appState: AppState
//    @State var selectedQuizPackage: AudioQuizPackage?
//    
//    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                MyLibraryItems()
//            }
//            .navigationTitle("Library")
//            .navigationBarTitleDisplayMode(.large)
//            .preferredColorScheme(.dark)
//        }
//    }
//    
//    @ViewBuilder
//    func MyLibraryItems() -> some View {
//        VStack(spacing: 25){
//            ForEach(audioQuizCollection) { audioQuiz in
//                
//                HStack(spacing: 12) {
//                    Image(audioQuiz.imageUrl)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 55, height: 55)
//                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text(audioQuiz.name)
//                            .fontWeight(.semibold)
//                        
//                        Label {
//                            Text("10 Quizzes Completed")
//                            
//                        } icon: {
//                            
//                            Image(systemName: "ellipsis")
//                                .foregroundStyle(.white)
//                            
//                        }
//                        .foregroundStyle(.gray)
//                        .font(.caption)
//                        
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Button {
//                        user.selectedQuizPackage = audioQuiz
//                        
//                    } label: {
//                        Image(systemName: user.selectedQuizPackage?.name == audioQuiz.name ? "star.fill" : "star")
//                            .font(.title3)
//                            .foregroundStyle(user.selectedQuizPackage?.name == audioQuiz.name ? .yellow : .white)
//                    }
//                    
//                    Button {
//                        
//                        
//                    } label: {
//                        Image(systemName: user.selectedQuizPackage?.name == audioQuiz.name ? "star.fill" : "star")
//                            .font(.title3)
//                            .foregroundStyle(user.selectedQuizPackage?.name == audioQuiz.name ? .yellow : .white)
//                    }
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .padding()
//        .padding(.top, 25)
//        .padding(.bottom, 150)
//    }
//}
//
//
//#Preview {
//    let user = User()
//    let appState = AppState()
//    let observer = QuizPlayerObserver()
//    return LibraryPage(interactionState: .constant(.idle))
//        .environmentObject(user)
//        .environmentObject(appState)
//        .environmentObject(observer)
//       
//}
//
