//
//  PlayerContentInfo.swift
//  Exam Genius Audio Quiz Player
//
//  Created by Tony Nlemadim on 1/15/24.
//

import Foundation
import SwiftUI

struct PlayerContentInfo: View {
    var animation: Namespace.ID
    @Binding var expandSheet: Bool
    var body: some View {
        HStack  {
            MiniPlayer(expandSheet: $expandSheet, animation: animation)
        }
        .foregroundStyle(.teal)
        .padding(.horizontal)
        .padding(.bottom, 12)
        .frame(height: 70)
        .contentShape(Rectangle())
        
    }
}
