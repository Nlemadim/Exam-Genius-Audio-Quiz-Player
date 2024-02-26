//
//  AudioQuizPlayer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/26/24.
//

import SwiftUI
import SwiftData
import Foundation

struct AudioQuizPlayer: View {
    @Binding var expandSheet: Bool
    @State private var fillAmount: CGFloat = 0.0
    @State private var showProgressRing: Bool = false
    @State private var tappedPlay: Bool = false
    @StateObject private var generator = ColorGenerator()
    
    var user: User
    var recordAction: () -> Void
    var playPauseAction: () -> Void
    var nextAction: () -> Void
    var repeatAction: () -> Void
    var animation: Namespace.ID
    var nameSpaceText: String?
    
    var body: some View {
        
        
        HStack {
            ZStack {
                if !expandSheet {
                    GeometryReader { [self] geometry in
                        Image(nameSpaceText ?? "IconImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                        
                    }
                }
            }
            .frame(width: 45, height: 45)
            .padding(.horizontal, 5)
            
            Text(user.selectedQuizPackage?.acronym ?? "Not Playing")
                .font(.callout)
                .lineLimit(2, reservesSpace: false)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                // Repeat Button
                Button(action: repeatAction) {
                    Image(systemName: "memories")
                        .font(.title2)
                }
                
                // Play/Pause Button
                Button(action: {
                    playPauseAction()
                    tappedPlay.toggle()
                    
                }) {
                    Image(systemName: tappedPlay ? "pause.fill" : "play.fill")
                        .font(.title2)
                }
                
                // Next Button
                Button(action: nextAction) {
                    Image(systemName: "forward.end.fill")
                        .font(.title2)
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .padding(.bottom, 12)
        .frame(height: 70)
        .contentShape(Rectangle())
        .background(
            LinearGradient(gradient: Gradient(colors: [.themePurple, .black]), startPoint: .top, endPoint: .bottom)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}


#Preview {
    var user = User()
    @Namespace var animation
    return AudioQuizPlayer(expandSheet: .constant(false), user: user, recordAction: {}, playPauseAction: {}, nextAction: {}, repeatAction: {}, animation: animation)
        .preferredColorScheme(.dark)
}
