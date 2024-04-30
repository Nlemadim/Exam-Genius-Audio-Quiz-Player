//
//  QuestionCountVisualizer.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 4/24/24.
//

import SwiftUI

//struct QuestionCountVisualizer: View {
//    var index: Int
//    var count: Int
//    var fillColor: Color
//    let maxWidth: CGFloat = 380  // Maximum width for the visualizer
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            ZStack(alignment: .leading) {
//                Capsule()
//                    .fill(Color.black.opacity(0.3))  // Background color for the unfilled part
//                    .frame(height: 8)
//
//                Capsule()
//                    .fill(fillColor)  // Dynamic fill color
//                    .frame(width: CGFloat(index) / CGFloat(count) * maxWidth, height: 8)
//                    .animation(.linear, value: index)
//            }
//            .frame(width: maxWidth, height: 8)  // Ensure the ZStack does not exceed maxWidth
//
//            Text("Question \(index)/\(count)")
//                .font(.caption)
//                .foregroundStyle(fillColor.dynamicTextColor())
//                .padding(.top, 2)
//        }
//    }
//}


struct TestViewer: View {
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Spacer()
            
            CustomProgressBarView(progress: .constant( CGFloat(1) / CGFloat(15)), fillColor: .teal)
                          .padding()
            
//            QuestionCountVisualizer(index: 6, count: 43, fillColor: .teal)
//                .frame(maxWidth: .infinity)
                
           
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}




#Preview {
    TestViewer()
        
}


struct CustomProgressBarView: View {
    @Binding var progress: CGFloat
    var fillColor: Color
    let maxWidth: CGFloat = 380  // Maximum width for the visualizer

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.3))  // Background color for the unfilled part
                    .frame(height: 8)

                Capsule()
                    .fill(fillColor)  // Dynamic fill color
                    .frame(width: progress * maxWidth, height: 8)
//                    .animation(.easeInOut(duration: 0.5))
            }
            .frame(width: maxWidth, height: 8)  // Ensure the ZStack does not exceed maxWidth

            Text("Progress")
                .font(.caption)
                .foregroundStyle(fillColor.dynamicTextColor())
                .padding(.top, 2)
        }
    }
}
