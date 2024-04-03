//
//  MyLibrary.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import SwiftUI
import SwiftData

struct MyLibrary: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @State var playlist: [String] = ["Yellow", "Red", "Blue", "Green", "Orange", "Black", "Teal"]
    
    var body: some View {
        ZStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 30)
                    .blur(radius: 70)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 10) {
                    /// Exam Icon Image
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        /// Long Name
                        HStack {
                            Text("Audio Quiz Player")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2, reservesSpace: false)
                                .fontWeight(.semibold)
                            Image(systemName: "headphones")
                            
                            Spacer()
                            
                            Button("", systemImage: "ellipsis") {
                                
                            }
                        }
                        .foregroundStyle(.white)
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12.0) {
                    LabeledContent("Total Questions", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
                    LabeledContent("Questions Answered", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
                    LabeledContent("Quizzes Completed", value: "\(user.selectedQuizPackage?.questions.count ?? 0)")
                    LabeledContent("Current High Score", value: "\(user.selectedQuizPackage?.questions.count ?? 0)%")
                }
                .font(.footnote)
                .padding(.horizontal)
                .padding()
                
                Divider()
                
                HStack {
                    Text("Playlist")
                        .font(.headline)
                    
                    Spacer()
                     
                    Button("", systemImage: "line.3.horizontal") {
                        
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(playlist, id: \.self) { file in
                            LibraryItemView(title: file, titleImage: "Logo")
                            Divider()
                                .padding()
                            
                        }
                    }
                }
                
                Spacer()
            }  
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let user = User()
    let appState = AppState()
    return MyLibrary()
        .environmentObject(user)
        .environmentObject(appState)
       
}
