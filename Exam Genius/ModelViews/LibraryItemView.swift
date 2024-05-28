//
//  LibraryItemView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/5/24.
//

import SwiftUI

struct LibraryItemView: View {
    let title: String
    let titleImage: String
    var audioFile: String?
    var audioCollection: [String]?
    var playAction: () -> Void
    @Binding var interactionState: InteractionState
    @Binding var isDownlaoded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                VStack{
                    Button(action: {
                        playAction()
                    }, label: {
                        Image(titleImage)
                            .resizable()
                            .frame(width: 74, height: 74)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(4)
                            .padding(.leading)
                    })
                }
                
                VStack(spacing: 8.0) {
                    Text(title)
                        .font(.footnote)
                        .fontWeight(.light)
                        .lineLimit(2, reservesSpace: false)
                        .hAlign(.leading)
                        .activeGlow(.white, radius: 0.4)
                    
                    if let collection = audioCollection, !collection.isEmpty {
                        Text("\(collection.count) QUESTIONS")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fontWeight(.light)
                            .hAlign(.leading)
                    }
                    
                    HStack {
                        Button(interactionState == .isNowPlaying ? "Now playing" : "Ready to play" ) {
                            playAction()
                        }
                        .disabled(interactionState == .isNowPlaying)
                        .font(.footnote)
                        .hAlign(.leading)
                        
//                        VUMeterView(interactionState: interactionState)
//                            .font(.footnote)
//                            .foregroundStyle(.secondary)
//                            .opacity(interactionState == .isNowPlaying ? 1 : 0)
                    }
                    .onChange(of: interactionState) { _, interactionState in
                        updateButtonState(interactionState)
                    }
                }
                .padding(8.0)
            }
        }
        .frame(height: 75)
        .background(.clear)
        .foregroundColor(.white)
        .cornerRadius(5)
    }
    
    private func updateButtonState(_ interactionState: InteractionState) {
        if interactionState == .isNowPlaying {
            DispatchQueue.main.async {
                self.interactionState = interactionState
            }
        }
    }
}

#Preview {
    LibraryItemView(title: "Web Application Vulnerabilities", titleImage: "COMPTIA-Security-Exam-Basic", playAction: {}, interactionState: .constant(.idle), isDownlaoded: .constant(false))
        .preferredColorScheme(.dark)
}
