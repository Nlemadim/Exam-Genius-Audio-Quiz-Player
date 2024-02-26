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
    @EnvironmentObject var user: User
    
    let configuration = QuizPlayer.shared.controlConfiguration
    var animation: Namespace.ID
    var nameSpaceText: String?
    @State var quizImage: String = "IconImage"
    @State var quizAcronym: String = "Not Playing"
    @State var themeColor: Color = .themePurple
    
    var body: some View {
        HStack {
            ZStack {
                if !expandSheet {
                    GeometryReader { geometry in
                        Image(quizImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                    }
                }
            }
            .frame(width: 45, height: 45)
            .padding(.horizontal, 5)
            
            Text(quizAcronym)
                .font(.callout)
                .lineLimit(2, reservesSpace: false)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onReceive(user.$audioQuizPackage) { _ in
                    updateView()
                }
                
            HStack(spacing: 20) {
                Button(action: {
                    configuration.selectReplay()
                }) {
                    Image(systemName: "memories")
                        .font(.title2)
                }
                
                Button(action: {
                    configuration.selectPlay()
                    tappedPlay.toggle()
                }) {
                    Image(systemName: tappedPlay ? "pause.fill" : "play.fill")
                        .font(.title2)
                }
                
                Button(action: {
                    configuration.selectNext()
                }) {
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
            LinearGradient(gradient: Gradient(colors: [themeColor, .black]), startPoint: .top, endPoint: .bottom)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
        // Optionally, listen for changes to the audioQuizPlaylist if needed.
        .onReceive(user.$audioQuizPlaylist) { _ in
            // This block will execute every time audioQuizPlaylist changes.
            // Add any additional logic here if needed.
        }
    }
    
    func updateView() {
        if let quiz = user.audioQuizPackage {
            let imageName = quiz.imageUrl
            self.quizImage = imageName
            self.quizAcronym = quiz.acronym
            generator.updateAllColors(fromImageNamed: imageName)
            self.themeColor = generator.dominantLightToneColor
        }
    }
}

//struct AudioQuizPlayer: View {
//    @Binding var expandSheet: Bool
//    @State private var fillAmount: CGFloat = 0.0
//    @State private var showProgressRing: Bool = false
//    @State private var tappedPlay: Bool = false
//    @StateObject private var generator = ColorGenerator()
//    
//    
//    @EnvironmentObject var user: User
//    var recordAction: () -> Void
//    var playPauseAction: () -> Void
//    var nextAction: () -> Void
//    var repeatAction: () -> Void
//    var animation: Namespace.ID
//    var nameSpaceText: String?
//    
//    var body: some View {
//        
//        
//        HStack {
//            ZStack {
//                if !expandSheet {
//                    GeometryReader { [self] geometry in
//                        Image(imageName)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
//                    }
//                }
//            }
//            .frame(width: 45, height: 45)
//            .padding(.horizontal, 5)
//            
//            Text(user.audioQuizPackage?.acronym ?? "Not Playing")
//                .font(.callout)
//                .lineLimit(2, reservesSpace: false)
//                .foregroundStyle(.white)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                
//            
//            HStack(spacing: 20) {
//                // Repeat Button
//                Button(action: repeatAction) {
//                    Image(systemName: "memories")
//                        .font(.title2)
//                }
//                
//                // Play/Pause Button
//                Button(action: {
//                    playPauseAction()
//                    tappedPlay.toggle()
//                    
//                }) {
//                    Image(systemName: tappedPlay ? "pause.fill" : "play.fill")
//                        .font(.title2)
//                }
//                
//                // Next Button
//                Button(action: nextAction) {
//                    Image(systemName: "forward.end.fill")
//                        .font(.title2)
//                }
//            }
//            .foregroundStyle(.white)
//            .padding(.horizontal)
//        }
//        .padding(.horizontal)
//        .padding(.bottom, 12)
//        .frame(height: 70)
//        .contentShape(Rectangle())
//        .background(
//            LinearGradient(gradient: Gradient(colors: [.themePurple, .black]), startPoint: .top, endPoint: .bottom)
//        )
//        .onTapGesture {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                expandSheet = true
//            }
//        }
//    }
//    
//    func updateView() {
//        
//    }
//    
//    var imageName: String {
//        if let name = user.audioQuizPackage?.imageUrl {
//          return name
//        }
//        
//        return "IconImage"
//    }
//}


#Preview {
    let user = User()
    @Namespace var animation
    return AudioQuizPlayer(expandSheet: .constant(false), animation: animation)
        .environmentObject(user)
        .preferredColorScheme(.dark)
}
