//
//  SettingsPage.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/5/24.
//

import SwiftUI

struct SettingsPage: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 5) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        SettingsItemView(mainLabel: "Answer with Mic", labelImage: "mic.fill", controlSwitch: true)
                        
                        SettingsItemView(mainLabel: "Answer with Buttons", labelImage: "textformat.abc.dottedunderline", controlSwitch: true)
                        
                        SettingsItemView(mainLabel: "Learning Mode", labelImage: "book.fill", controlSwitch: true)
                        
                        SettingsItemView(mainLabel: "Response Timer", labelImage: "alarm.fill", controlSwitch: true)
                        
                        SettingsItemView(mainLabel: "Auto Quiz Refresh", labelImage: "arrow.clockwise", controlSwitch: true)
                        
                        SettingsItemView(mainLabel: "Repeat Question", labelImage: "memories", controlSwitch: true)
                        
                        SettingsItemView(mainLabel: "Use Microphone", labelImage: "mic.fill", controlSwitch: true)
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .background(.clear)
                        
                        Spacer()
                    }
                }
                .scrollBounceBehavior(.automatic)
                
                Text("Privacy")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .hAlign(.center)
                Text("Terms and Conditions")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .hAlign(.center)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image("Logo")
                    .blur(radius: 70, opaque: false)
                    .offset(y: -100)
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    SettingsPage()
}
