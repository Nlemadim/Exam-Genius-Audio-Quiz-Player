//
//  PlayerBackgroundView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import Foundation
import SwiftUI

struct PlayerBackgroundView: View {
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 30)
                .blur(radius: 70)
            Spacer()
        }
    }
}
