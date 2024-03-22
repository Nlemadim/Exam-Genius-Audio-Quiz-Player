//
//  Extensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/21/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

