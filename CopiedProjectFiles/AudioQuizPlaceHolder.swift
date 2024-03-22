//
//  AudioQuizPlaceHolder.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 2/9/24.
//

import Foundation
import SwiftUI

struct AudioQuizPlaceHolder: View {
    var body: some View {
        VStack {
            Image("IconImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 260)
                .cornerRadius(20)
                .overlay(
                    VStack {
                        Spacer()
                        // Encapsulate text within a background
                        VStack {
                            ProgressView()
                                .padding(5) // Adjust padding for text
                        }
                        .frame(width: 200, height: 60) // Fixed size background
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                    }
                )
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
