//
//  ImageAndTitleView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import SwiftUI

struct ImageAndTitleView: View {
    var title: String
    var titleImage: String
    let tapAction: (AudioQuizPackage) -> Void
    var quiz: AudioQuizPackage // Assume this is passed to the view

    var body: some View {
        VStack {
            Image(titleImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .cornerRadius(10.0)
            Text(title)
                .font(.system(size: 13))
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
                .frame(width: 140)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .onTapGesture {
            tapAction(quiz)
        }
    }
}


//struct PerformanceView: View {
//    var body: some View {
//        VStack {
//            Text("Performance")
//                .fontWeight(.bold)
//                .foregroundStyle(.primary)
//                .hAlign(.leading)
//            
//            Rectangle()
//                .fill(Material.ultraThin)
//                .frame(height: 220)
//                .cornerRadius(20)
//                .overlay {
//                    ZStack {
//                        Image(systemName: "chart.bar.xaxis.ascending")
//                            .resizable()
//                            .frame(width: 280, height: 200)
//                            .opacity(0.05)
//                        VStack {
//                            Spacer()
//                            Text("No performance history yet")
//                            Spacer()
//                        }
//                    }
//                }
//        }
//        .padding()
//    }
//}
