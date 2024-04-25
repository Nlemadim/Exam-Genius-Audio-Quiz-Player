//
//  QuestionCountVisualizer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/24/24.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct QuestionCountVisualizer: View {
    var index: Int
    var count: Int
    var fillColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.3))  // Background color for the unfilled part
                    .frame(height: 8)
                
                Capsule()
                    .fill(fillColor)  // Dynamic fill color
                    .frame(width: CGFloat(index) / CGFloat(count) * UIScreen.main.bounds.width, height: 8)
                    .animation(.linear, value: index)
            }
            .frame(height: 8)
           

            Text("Question \(index)/\(count)")
                .font(.caption)
                .foregroundStyle(fillColor)
                .padding(.top, 2)
        }
        .frame(maxWidth: 380)
        
    }
}


struct TestViewer: View {
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Spacer()
            
            QuestionCountVisualizer(index: 6, count: 43, fillColor: .teal)
                .frame(maxWidth: .infinity)
                
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    TestViewer()
        
}
