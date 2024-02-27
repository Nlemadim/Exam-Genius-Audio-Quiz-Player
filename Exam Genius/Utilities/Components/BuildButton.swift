//
//  BuildButton.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation
import SwiftUI

struct BuildButton: View {
    @State private var didTapButton = false
    let action: () -> Void

    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            VStack(spacing: 5) {
                Image(systemName: "wand.and.stars.inverse")
                    .font(.body)
                    .foregroundColor(.teal)
                Text("Build")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(2)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.teal.opacity(0.6))
                    
                    )
            }
            .padding(5)
        })
        .foregroundStyle(.primary)
       
    }
    
}

#Preview {
    BuildButton(action: {})
}
