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
            
//            CustomProgressBarView(progress: .constant( CGFloat(1) / CGFloat(15)), fillColor: .teal)
//                          .padding()
//            
//            CustomProgressBarView2(progress: .constant( CGFloat(14) / CGFloat(15)), fillColor: .teal)
//                          .padding()
                
           
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

struct CustomProgressBarView2: View {
    @Binding var progress: CGFloat  // Progress in range [0, 1]
    var fillColor: Color
    var questionCount: Int
    var questionIndex: Int

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.3))  // Background color for the unfilled part
                        .frame(height: 8)

                    Capsule()
                        .fill(fillColor)  // Dynamic fill color
                        .frame(width: progress * geometry.size.width, height: 8)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
                .frame(width: geometry.size.width, height: 8)  // Ensure the ZStack does not exceed the width of GeometryReader

                HStack {
                    Text("Question:\(questionIndex)/ \(questionCount)")
                        .font(.caption)
                        .padding(.top, 2)
                    
                    Spacer()
                    
                    Text("Completion: \(Int(progress * 100))%")
                        .font(.caption)
                        .padding(.top, 2)
                }
                .foregroundStyle(fillColor.dynamicTextColor())
            }
        }
    }
}

struct CustomProgressBarView3: View {
    @Binding var progress: CGFloat  // Progress in range [0, 1]
    var fillColor: Color

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.3))  // Background color for the unfilled part
                        .frame(height: 8)

                    Capsule()
                        .fill(fillColor)  // Dynamic fill color
                        .frame(width: min(progress * 4, 1) * geometry.size.width, height: 8)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
                .frame(width: geometry.size.width, height: 8)  // Ensure the ZStack does not exceed the width of GeometryReader

                Text("Progress: \(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(fillColor)
                    .padding(.top, 2)
            }
        }
    }
}
