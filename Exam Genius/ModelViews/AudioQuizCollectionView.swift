//
//  AudioQuizCollectionView.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/20/24.
//

import SwiftUI

struct AudioQuizCollectionView: View {
    var quiz: AudioQuizPackage
    
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

#Preview {
    let container = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "COMPTIA-APlus-Exam")
   
    let playListItemFromContainer = MyPlaylistItem(from: container)
    return AudioQuizCollectionViewV2(quiz: playListItemFromContainer)
        .preferredColorScheme(.dark)
}

//#Preview {
//    let container = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "COMPTIA-APlus-Exam")
//   
//    let playListItemFromContainer = MyPlaylistItem(from: container)
//    return AudioQuizCollectionViewV3(quiz: playListItemFromContainer)
//        .preferredColorScheme(.dark)
//}

#Preview {
    let container = DownloadedAudioQuizContainer(name: "California Bar (MBE) California California (MBE) (MBE)", quizImage: "COMPTIA-APlus-Exam")
   
    let playListItemFromContainer = MyPlaylistItem(from: container)
    return AudQuizCardViewMid(quiz: playListItemFromContainer)
        .preferredColorScheme(.dark)
}

struct AudioQuizCollectionViewV2: View {
    let quiz: PlaylistItem
    @StateObject var generator = ColorGenerator()

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(quiz.titleImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 180)
                    .cornerRadius(10)
            }

            Text(quiz.title)
                .font(.caption)
//                .font(.system(size: 16))
                .lineLimit(3, reservesSpace: true)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .padding(.bottom)
                
        }
        .padding(.vertical, 8)
        .frame(width: 160)
        .background(RoundedRectangle(cornerRadius: 10).fill(generator.dominantBackgroundColor))
        .onAppear {
            generator.updateAllColors(fromImageNamed: quiz.titleImage)
        }
    }
}

struct AudioQuizCollectionViewV3: View {
    let quiz: PlaylistItem
    @StateObject var generator = ColorGenerator()

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(quiz.titleImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300) // Adjusted to represent a square aspect ratio
                    .cornerRadius(10)
            }

            Text(quiz.title)
                .font(.system(size: 16))
                .lineLimit(3, reservesSpace: true)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .padding(.bottom)
                
        }
        .padding(.vertical, 8)
        .frame(width: 300) // Adjusted to match the width of the image
        .background(RoundedRectangle(cornerRadius: 10).fill(generator.dominantBackgroundColor))
        .onAppear {
            generator.updateAllColors(fromImageNamed: quiz.titleImage)
        }
    }
}


struct AudQuizCardViewMid: View {
    let quiz: PlaylistItem
    @StateObject var generator = ColorGenerator()

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(quiz.titleImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .cornerRadius(10.0)
            }

            Text(quiz.title)
                .font(.system(size: 16))
                .lineLimit(3, reservesSpace: true)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .padding(.bottom)
                
        }
        .frame(width: 180)
        .cornerRadius(10.0)
        .background(RoundedRectangle(cornerRadius: 10).fill(.black))
        .onAppear {
            generator.updateAllColors(fromImageNamed: quiz.titleImage)
        }
    }
        
}

