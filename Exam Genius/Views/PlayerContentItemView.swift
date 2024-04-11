//
//  PlayerContentItemView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import SwiftUI

struct PlayerContentItemView: View {
    let content: PlayerContent
    var playContent: () -> Void
    @Binding var interactionState: InteractionState
    @Binding var isDownloaded: Bool

    var body: some View {
        switch content {
        case .audioQuiz(let audioQuiz):
            LibraryItemView(title: audioQuiz.title, titleImage: audioQuiz.titleImage, audioCollection: audioQuiz.audioCollection, playAction: { playContent() }, interactionState: $interactionState, isDownlaoded: $isDownloaded)
        case .topic(let topicOverview):
            LibraryItemView(title: topicOverview.title, titleImage: topicOverview.titleImage, audioFile: topicOverview.audiofile, playAction: { playContent() }, interactionState: $interactionState, isDownlaoded: $isDownloaded)
        }
    }
}
