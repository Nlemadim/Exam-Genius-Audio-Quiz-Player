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

//#Preview {
//    AudioQuizCollectionView(quiz: <#AudioQuizPackage#>)
//}
