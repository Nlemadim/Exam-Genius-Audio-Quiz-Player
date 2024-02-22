//
//  BuildButton.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation
import SwiftUI

struct BuildButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            VStack(spacing: 10) {
                Image(systemName: "arrow.down.circle")
                    .font(.title)
                Text("Build")
                    .font(.subheadline)
            }
        })
        .foregroundStyle(.primary)
    }
}
