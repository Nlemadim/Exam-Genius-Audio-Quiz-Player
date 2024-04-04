//
//  AudioQuizHeaderView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import Foundation
import SwiftUI

struct AudioQuizHeaderView: View {
    var selectedQuizPackage: AudioQuizPackage?
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(selectedQuizPackage?.imageUrl ?? "Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(selectedQuizPackage?.name ?? "No quiz selected")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(2, reservesSpace: true)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button("", systemImage: "ellipsis") { }
                        .offset(y: -14)
                }
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

