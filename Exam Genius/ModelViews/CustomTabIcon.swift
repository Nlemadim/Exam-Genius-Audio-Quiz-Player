//
//  CustomTabIcon.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/3/24.
//

import SwiftUI

struct CustomTabIcon: View {
    var body: some View {
        ZStack {
            
            Image(systemName: "books.vertical.fill")
                .resizable()
                .frame(width: 23, height: 15)
            Image(systemName: "headphones")
                .resizable()
                .frame(width: 45, height: 45)
                .offset(y: 5)
        }
    }
}

#Preview {
    CustomTabIcon()
}
