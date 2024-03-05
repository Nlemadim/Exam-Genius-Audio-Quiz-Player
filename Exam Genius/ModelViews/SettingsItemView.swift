//
//  SettingsItemView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/5/24.
//

import SwiftUI

struct SettingsItemView: View {
    var mainLabel: String
    var labelImage: String?
    var subLabel: String?
    var controlSwitch: Bool = false
    var slider: UISlider?
    var stepper: Bool = false
    @State var switcherValue: Bool = false
    @State var defaultStepperValue: Double = 5
    @State var usingMic: Bool = false
    @State var usingButtons: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            if let labelImage = labelImage {
                HStack {
                    Image(systemName: labelImage)
                        .foregroundStyle(.yellow)
                }
                .frame(width: 30)
                
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(mainLabel)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                if let subLabel = subLabel {
                    Text(subLabel)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            if controlSwitch  {
                Toggle("", isOn: $usingMic)
                    .scaleEffect(0.8)
            }
            
            if usingButtons  {
                Toggle("", isOn: $usingButtons)
                    .scaleEffect(0.8)
            }
            
            if stepper {
                Stepper("", value: $defaultStepperValue)
            }
        }
        .padding(.all, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .cornerRadius(25)
        .background(
            Rectangle()
                .fill( Material.ultraThin)
                .cornerRadius(15)
            
        )
    }
}


#Preview {
    SettingsItemView(mainLabel: "Use Mic")
}
