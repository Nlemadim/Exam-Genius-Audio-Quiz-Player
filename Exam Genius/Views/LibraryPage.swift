//
//  LibraryPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/3/24.
//

import SwiftUI
import SwiftData

struct LibraryPage: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    @State var selectedQuizPackage: AudioQuizPackage?
    
    @Query(sort: \AudioQuizPackage.name) var audioQuizCollection: [AudioQuizPackage]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(audioQuizCollection.filter { !$0.questions.isEmpty }, id: \.self) { audioQuiz in
                        MyLibraryItems(audioQuiz: audioQuiz)
                        Divider().padding()
                    }
                }
                .padding()
                .padding(.bottom, 150)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
        }
    }
    
    @ViewBuilder
    func MyLibraryItems(audioQuiz: AudioQuizPackage) -> some View {
        HStack(spacing: 12) {
            Image(audioQuiz.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(audioQuiz.name)
                    .fontWeight(.semibold)
                
                Label {
                    Text("10 Quizzes Completed")
                    
                } icon: {
                    
                    Image(systemName: "beats.headphones")
                        .foregroundStyle(.white)
                }
                .foregroundStyle(.gray)
                .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                user.selectedQuizPackage = audioQuiz
                //TODO: Go to Player Page
                
            } label: {
                Image(systemName: user.selectedQuizPackage?.name == audioQuiz.name ? "star.fill" : "star")
                    .foregroundStyle(user.selectedQuizPackage?.name == audioQuiz.name ? .yellow : .white)
            }
            
            Button {
                //TODO: Go to detail Page
            } label: {
                Image(systemName: "ellipsis")
                
            }
        }
        
    }
}


#Preview {
    let user = User()
    let appState = AppState()
    let observer = QuizPlayerObserver()
    return LibraryPage()
        .environmentObject(user)
        .environmentObject(appState)
        .environmentObject(observer)
       
}

