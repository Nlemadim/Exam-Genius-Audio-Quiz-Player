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
            VStack(spacing: 10) {
                Image(systemName: "arrow.down.circle")
                    .font(.title2)
                Text("Build")
                    .font(.subheadline)
            }
            .padding(5)
        })
        .foregroundStyle(.primary)
       
    }
    
}
