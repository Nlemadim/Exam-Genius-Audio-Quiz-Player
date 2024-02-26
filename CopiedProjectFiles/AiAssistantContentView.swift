//
//  AiAssistantContentView.swift
//  ExamGenius
//
//  Created by Tony Nlemadim on 12/29/23.
//

import SwiftUI

struct AiAssistantContentView: View {
    let profileImage: Image
    let content: Content
    let isProcessing: Bool
    @State private var displayedText: String = ""
    @State private var messageIndex: Int = 0
    @State private var timer: Timer?

    enum Content {
        case text(String)
        case image(Image)
        case url(URL)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            profileImage
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            contentBody()
                .padding()
                .background(RoundedRectangle(cornerRadius: 10))
        }
        .onAppear {
            startTypingAnimationIfNeeded()
        }
    }

    @ViewBuilder
    private func contentBody() -> some View {
        if isProcessing {
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
        } else {
            switch content {
            case .text(let fullText):
                Text(displayedText)
                    .foregroundStyle(.white)
                    .onAppear {
                        startTypingAnimation(for: fullText)
                    }
            case .image(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .url(let url):
                Text(url.absoluteString) // or a custom view to represent the URL
            }
        }
    }

    private func startTypingAnimation(for text: String) {
        displayedText = ""
        messageIndex = 0
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if self.messageIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: self.messageIndex)
                self.displayedText += String(text[index])
                self.messageIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }


    private func startTypingAnimationIfNeeded() {
        if case .text(let fullText) = content {
            startTypingAnimation(for: fullText)
        }
    }
}


#Preview {
    AiAssistantContentView(profileImage: Image("VigilHeadshot"), content: .text("Hello User! vvvvvHello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!Hello User!vvv\nNice to meet you!"), isProcessing: false)
}
