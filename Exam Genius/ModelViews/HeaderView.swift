//
//  HeaderView.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/27/24.
//

import SwiftUI

struct HeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.horizontal)
        .hAlign(.leading)
    }
}

#Preview {
    HeaderView(title: "Summary")
}
