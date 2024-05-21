//
//  VoiceSelectionToggle.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct VoiceSelectionToggle: View {
    var label: String
    var imageName: String
    @Binding var selectedVoice: String
    var voice: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(selectedVoice == voice ? .blue : .primary)
            Text(label)
                .foregroundColor(selectedVoice == voice ? .blue : .primary)
            Spacer()
            if selectedVoice == voice {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.selectedVoice = self.voice
            //UserDefaultsManager.setSelectedVoice(self.voice)
        }
        .padding()
        .background(selectedVoice == voice ? Color.blue.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }
}


#Preview {
    VoiceSelectionToggle(label: "Holly", imageName: "person.fill", selectedVoice: .constant("Holly"), voice: "Holly")
}
