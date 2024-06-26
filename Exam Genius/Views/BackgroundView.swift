//
//  BackgroundView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/11/24.
//

import SwiftUI

struct BackgroundView: View {
    var backgroundImage: String
    var color: Color
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 300)
            .background(
                LinearGradient(gradient: Gradient(colors: [color, .black]), startPoint: .top, endPoint: .bottom)
            )
            .overlay {
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            .frame(height: 300)
            .blur(radius: 100)
    }
}

