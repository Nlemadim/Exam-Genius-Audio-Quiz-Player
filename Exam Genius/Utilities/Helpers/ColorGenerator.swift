//
//  ColorGenerator.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation
import SwiftUI

class ColorGenerator: ObservableObject {
    @Published var dominantBackgroundColor: Color = .black // Default color

    func updateDominantColor(fromImageNamed imageName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let image = UIImage(named: imageName),
                  let dominantColor = image.dominantColor() else { return }

            DispatchQueue.main.async {
                self.dominantBackgroundColor = Color(dominantColor)
            }
        }
    }
}
