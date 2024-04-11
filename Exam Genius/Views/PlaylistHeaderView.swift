//
//  PlaylistHeaderView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import Foundation
import SwiftUI

struct PlaylistHeaderView: View {
    var body: some View {
        HStack {
            Text("Playlist")
                .font(.headline)
            
            Spacer()
             
            Button("", systemImage: "line.3.horizontal") { }
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
    }
}


