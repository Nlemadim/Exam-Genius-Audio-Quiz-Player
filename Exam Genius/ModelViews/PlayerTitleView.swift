//
//  PlayerTitleView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/29/24.
//

import SwiftUI

struct PlayerTitleView: View {
    var titleImage: String
    var title: String
    var titleDetailsAction: () -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(titleImage)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(20)
                .padding()
            
                Text(title)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .lineLimit(3, reservesSpace: false)
//            Button("", systemImage: "square.fill.text.grid.1x2") {
//                titleDetailsAction()
//            }
//            .foregroundStyle(.white)
            
        }
    }
}

#Preview {
    PlayerTitleView(titleImage: "Kotlin", title: "National Counselor Examination for Licensure and Certification Course", titleDetailsAction: {})
        .preferredColorScheme(.dark)
}
