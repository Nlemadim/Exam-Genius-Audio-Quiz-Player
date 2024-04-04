//
//  PlaylistHeaderView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import Foundation
import SwiftUI

struct PlaylistHeaderView: View {
    var body: some View {
        HStack {
            Text("Playlist")
                .font(.headline)
            
            Spacer()
             
            Button("", systemImage: "line.3.horizontal") { }
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
    }
}

struct PlayerContentItemView: View {
    let content: PlayerContent
    @Binding var interactionState: InteractionState
    @Binding var isDownloaded: Bool

    var body: some View {
        switch content {
        case .audioQuiz(let audioQuiz):
            LibraryItemView(title: audioQuiz.title, titleImage: audioQuiz.titleImage, audioCollection: audioQuiz.audioCollection, interactionState: $interactionState, isDownlaoded: $isDownloaded)
        case .topic(let topicOverview):
            LibraryItemView(title: topicOverview.title, titleImage: topicOverview.titleImage, audioFile: topicOverview.audiofile, interactionState: $interactionState, isDownlaoded: $isDownloaded)
        }
    }
}

