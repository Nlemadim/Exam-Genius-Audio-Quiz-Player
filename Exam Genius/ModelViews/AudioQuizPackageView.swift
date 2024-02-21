//
//  AudioQuizPackageView.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/20/24.
//

import SwiftUI

struct AudioQuizPackageView: View {
    var quiz: AudioQuizPackage
    var downloadAction: () -> Void
    var startAction: () -> Void
    @State var isReadyToPlay: Bool = false
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 5) {
                if quiz.imageUrl.isEmpty {
                    Image("IconImage") // Ensure this image is in your assets
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(20)
                        .overlay(
                            VStack {
                                Spacer()
                                VStack {
                                    HStack {
                                        Text(quiz.name)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        //.lineLimit(4, reservesSpace: false)
                                            .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(alignment: .leading)
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                        )
                    
                } else {
                    Image(quiz.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(30)
                        .padding(.horizontal, 20)
                        .overlay(
                            VStack {
                                Spacer()
                                VStack {
                                    HStack {
                                        Text(quiz.name)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        //.lineLimit(4, reservesSpace: false)
                                            .foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(alignment: .leading)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 5)
                                
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            downloadAction()
                                        }, label: {
                                            Text( isReadyToPlay ? "Downloaded" : "Download")
                                                .foregroundStyle(.white)
                                            //.font(.caption)
                                                .fontWeight(.semibold)
                                                .frame(width: .widthPer(per: 0.3), height: .heightPer(per: 0.01))
                                                .padding(.vertical)
                                        })
                                        .disabled(isReadyToPlay)
                                        .background(!isReadyToPlay ? .teal.opacity(0.6) : .green)
                                        .cornerRadius(10)
                                        .shadow(radius: 6)
                                        .padding(.horizontal)
                                    }
                                }
                                .padding()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(30)
                                .background(Color.black.opacity(0.7))
                                
                                
                            }
                        )
                }
                
            }
            .padding(.all, 20.0)
            .shadow(radius: 10, x: 0, y: 10)
            .padding(.horizontal, 20)
            
        }
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    LandingPage()
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
}


//#Preview {
//    AudioQuizView(quiz: <#AudioQuizPackage#>, downloadAction: {}, startAction: {}, image: "CCNA-Exam", name: "CCNA (Cisco Certified Network Associate)Exam", isReadyToPlay: false, questions: [])
//}

struct AudioQuizView: View {
    var quiz: AudioQuizPackage
    var downloadAction: () -> Void
    var startAction: () -> Void
    @State var isReadyToPlay: Bool = false
    
    var body: some View {
        ZStack {
            // Determine the image to display based on availability of imageUrl
            if quiz.imageUrl.isEmpty {
                Image("IconImage") // Ensure this image is in your assets
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 260)
                    .cornerRadius(20)
            } else {
                Image(quiz.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 260)
                    .cornerRadius(20)
            }
            
            // Overlay for name or loading indicator
            VStack {
                Spacer()
                if quiz.name.isEmpty {
                    // Display a ProgressView if the name is empty
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    // Display the name if it's available
                    Text(quiz.name)
                        .font(.callout)
                        .lineLimit(3, reservesSpace: true)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.7))
                }
            }
        }
        .frame(width: 180, height: 260)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}



