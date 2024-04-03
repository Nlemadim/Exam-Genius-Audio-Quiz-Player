//
//  CustomLogo.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 3/28/24.
//

import SwiftUI

struct CustomLogo: View {
    var body: some View {
        HStack(spacing: 5){
            Image("Logo")
                .resizable()
                .frame(width: 35, height: 35)
            Text("Exam Genius")
                .font(.headline)
                .fontWeight(.black)
                .foregroundStyle(.teal)
           
        }
    }
}

#Preview {
    CustomLogo()
        .preferredColorScheme(.dark)
}
