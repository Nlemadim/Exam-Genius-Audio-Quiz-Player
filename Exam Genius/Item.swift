//
//  Item.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/21/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
