//
//  AudioQuizPlaylistView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/26/24.
//

import SwiftUI
import SwiftData
import Foundation

struct AudioQuizPlaylistView: View {
    @EnvironmentObject var user: User
    @Environment(\.dismiss) private var dismiss
    let audioQuiz: AudioQuizPackage
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottomTrailing) {
                Image(audioQuiz.imageUrl)
                    .resizable()
                    .scaledToFit()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(audioQuiz.name)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .lineLimit(3)
                        .bold()
                        .primaryTextStyleForeground()
                    Spacer()
                    
                }
                
                Text(audioQuiz.about)
                    .font(.footnote)
                    .lineLimit(5, reservesSpace: false)
                    .foregroundStyle(.primary)
                
                HStack {
                    if audioQuiz.questions.isEmpty {
                        LoadingButtonView()
                    } else {
                        StartAudioQuizButton(startPressed: {
                            
                        })
                    }
                }
            }
            .padding(.leading)
            .padding(.top)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Text("Questions:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(audioQuiz.questions.isEmpty ? "" : "\(audioQuiz.questions.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        ProgressView()
                            .scaleEffect(0.7)
                            .padding(.horizontal)
                            .opacity(audioQuiz.questions.isEmpty ? 1 : 0)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Audio Quizzes:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(audioQuiz.questions.isEmpty ? "" : "\(audioQuiz.questions.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        ProgressView()
                            .scaleEffect(0.7)
                            .padding(.horizontal)
                            .opacity(audioQuiz.questions.isEmpty ? 1 : 0)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Topics:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(audioQuiz.topics.isEmpty ? "" : "\(audioQuiz.topics.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        if audioQuiz.questions.isEmpty {
                            ProgressView()
                                .scaleEffect(0.7)
                                .padding(.horizontal)
                        } else {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    VStack {
                        Image(systemName: "xmark.circle")
                        Text("Dismiss")
                            .padding(5)
                    }
                })
            }
            .foregroundStyle(.white)
            .padding(25)
        }
        .navigationTitle(audioQuiz.acronym + " Audio Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .scrollTargetBehavior(.viewAligned)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AudioQuizPackage.self, configurations: config)
        let package = AudioQuizPackage(id: UUID(), name: "California Bar", imageUrl: "BarExam-Exam")
        return AudioQuizPlaylistView(audioQuiz: package)
            .modelContainer(container)
    } catch {
        return Text("Failed to create Preview: \(error.localizedDescription)")
    }
}


struct LoadingButtonView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Downloading")
                .font(.subheadline)
                .foregroundStyle(.primary)
            ProgressView()
                .scaleEffect(1)
                .padding(.horizontal)
        }
    }
}

struct StartAudioQuizButton: View {
    var startPressed: () -> Void
    var body: some View {
        Button(action: startPressed, label: {
            HStack(spacing: 10) {
                Image(systemName: "play.fill")
                    .foregroundStyle(.black)
                    .font(.title)
                    .padding(10)
                    .background(Circle()
                    .fill(Color.teal))
                    .mask(Circle())
                Text("Start")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    
            }
        })
        .foregroundStyle(.white)
    }
}
