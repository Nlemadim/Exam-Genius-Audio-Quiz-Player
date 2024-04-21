//
//  AudioQuizDownloadPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/19/24.
//

import Foundation
import SwiftUI

struct AudioQuizDownloadPage: View {
    @State var audioQuizLabel = "Audio Quiz"
    var body: some View {
        ZStack {
            titleImageView()
            
            VStack(alignment: .leading, spacing: 8.0 ) {
                Spacer()
                
                Text("Audio Quiz Name "+audioQuizLabel)
                    .font(.title2)
                    .fontWeight(.black)
                    .offset(y: 120)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("This quiz packet contains at least 1346 unique questions covering 235 topics. This is just some random text to fill up the space where A.I will use its overflow of words and expressions to explain just how awesome this quiz is and how much a user stands to learn by practicing it. it will explain how once a question is answered the question will never be asked again.")
                    
                    voiceSelector()
                }
                //.padding(.top, 10)
                
                //Spacer()
                //Mark: Download Meter Bar
                VStack(spacing: 16.0) {
                    
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(.teal)
                        .frame(height: 10)
                        .frame(maxWidth: .infinity)
                    
                    PlainClearButton(color: .clear, label: "Download Now") {
                        
                    }
                    
                    Text("cancel")
                        .foregroundStyle(.red)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
            }
            .padding(10)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { /*  shareAction() */}, label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20.0)
                })
            }
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func titleImageView() -> some View {
        VStack {
            Image("ELA-Exam")
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
                .frame(height: 200)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func voiceSelector() -> some View {
        
        Text("Select Voice")
            .padding(5)
            .contextMenu {
                Button {
                    print("Chosen Sidney's voice")
                } label: {
                    Text("Sidney")
                }
                
                Button {
                    print("Chosen Shady's voice")
                } label: {
                    Text("Shady")
                }
                
                Button {
                    print("Chosen Draus's voice")
                } label: {
                    Text("Draus")
                }
                
                
                Button {
                    print("Chosen Kal's voice")
                } label: {
                    Text("Kal")
                }
                
            }
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(lineWidth: 1.0)
                    
            )
    }
}


#Preview {
    AudioQuizDownloadPage()
        .preferredColorScheme(.dark)
}
