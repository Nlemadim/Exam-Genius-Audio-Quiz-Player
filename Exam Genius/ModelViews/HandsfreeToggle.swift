//
//  HandsfreeToggle.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/20/24.
//

import SwiftUI

struct HandsfreeToggle: View {
    @Binding var isMicrophoneOn: Bool
    
    var body: some View {
        VStack {
            Text("Handsfree")
                .font(.headline)
            HStack {
                VStack {
                    Image(systemName: "mic.fill")
                    Text("Mic")
                }
                .foregroundColor(isMicrophoneOn ? .blue : .primary)
                
                Spacer()
                
                Toggle(isOn: $isMicrophoneOn) {
                    EmptyView()
                }
                .labelsHidden()
                .onChange(of: isMicrophoneOn) {_, newValue in
                    //UserDefaultsManager.setMicrophoneOn(newValue)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "abc.circle")
                    Text("Option Buttons")
                }
                .foregroundColor(!isMicrophoneOn ? .blue : .primary)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}


#Preview {
    HandsfreeToggle(isMicrophoneOn: .constant(true))
}
