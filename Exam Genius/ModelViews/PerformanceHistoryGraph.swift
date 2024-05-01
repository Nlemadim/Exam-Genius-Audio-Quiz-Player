//
//  PerformanceHistoryGraph.swift
//  ExamGenius
//
//  Created by Tony Nlemadim on 12/25/23.
//

import SwiftUI

struct PerformanceHistoryGraph: View {
    var history = [PerformanceModel]()
    var mainColor: Color
    var subColor: Color
    
    var body: some View {
        HStack {
            Text("Performance History")
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Spacer(minLength: 0)
        }
        .padding()
        .hAlign(.leading)
        
        VStack {
            
            if history.isEmpty {
                
                Text("No Performance History Data Yet")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            } else {
                
                GraphView2()
                    
            }
        }
        .frame(minHeight: 190)
        .padding(.horizontal)
        .padding()
        .background(Color.gray.opacity(0.06))
        .cornerRadius(15)
    }
    
    @ViewBuilder
    private func GraphView() -> some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ForEach(getGraphLines(), id: \.self) { line in
                        HStack(spacing: 8) {
                            Text("\(Int(line))%")
                                .font(.caption)
                                .foregroundColor(.primary)  // Change from .foregroundStyle to .foregroundColor
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: -15)
                    }
                }
                
                HStack {
                    ForEach(history, id: \.self) { performance in
                        VStack(spacing: 0) {
                            VStack(spacing: 5) {
                                Capsule()
                                    .fill(mainColor) // Assuming mainColor is defined elsewhere as a Color
                                
                                Capsule()
                                    .fill(subColor) // Assuming subColor is defined elsewhere as a Color
                            }
                            .frame(width: 8)
                            .frame(height: getBarHeight(point: performance.score, size: proxy.size))
                            
                            Text("Q:\(performance.numberOfQuestions)")
                                .font(.footnote)
                                .foregroundColor(.primary) // Assuming you want the color used here
                                .frame(height: 25, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding(.leading, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 190)
    }
    
    @ViewBuilder
    private func GraphView2() -> some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ForEach(getGraphLines2(), id: \.self) { line in
                        HStack(spacing: 8) {
                            Text("\(Int(line))%")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: -15)
                    }
                }
                
                HStack {
                    ForEach(history, id: \.self) { performance in
                        VStack(spacing: 0) {
                            VStack(spacing: 5) {
                                Capsule()
                                    .fill(mainColor)
                                    .frame(width: 8, height: getBarHeight2(point: performance.score, size: proxy.size) * 0.5) // Assuming you want half-height for main color
                                
                                Capsule()
                                    .fill(subColor)
                                    .frame(width: 8, height: getBarHeight2(point: performance.score, size: proxy.size) * 0.5) // Assuming you want half-height for sub color
                            }
                            .frame(width: 8)
                            .frame(height: getBarHeight2(point: performance.score, size: proxy.size))
                            
                            Text("Q:\(performance.numberOfQuestions)")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .frame(height: 25, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding(.leading, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 190)
    }
    
    func getGraphLines2() -> [CGFloat] {
        // Always use a maximum of 100 for the graph lines
        var _: CGFloat = 100
        var lines: [CGFloat] = []
        for index in 0...4 {
            lines.append(CGFloat(100 - 25 * index)) // Adding lines for 100%, 75%, 50%, 25%, and 0%
        }
        return lines
    }

    private func getMax2() -> CGFloat {
        // Use static 100 as the max for bar height calculations
        return 100
    }

    func getBarHeight2(point: CGFloat, size: CGSize) -> CGFloat {
        let maximumScore = getMax2()  // Clearly named to indicate this is a value, not a function
        let height = (point / maximumScore) * (size.height - 37)  // Use the maximumScore to adjust the height
        return max(0, height)  // Correctly use the max function to ensure height is not negative
    }


    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "h a"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) && calendar.isDate(date, equalTo: now, toGranularity: .year) {
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            dateFormatter.dateFormat = "MMM"
            return dateFormatter.string(from: date)
        } else {
            return "Earlier"
        }
    }
    
    func getGraphLines() -> [CGFloat] {
        let max = getMax()
        var lines: [CGFloat] = []
        lines.append(max)
        for index in 1...4 {
            let progress = max / 4
            lines.append(max - (progress * CGFloat(index)))
        }
        return lines
    }
    
    private func getMax() -> CGFloat {
        let max = history.max { first, second in
            return second.score > first.score
        }?.score ?? 0
        return max
    }
    
    func getBarHeight(point: CGFloat, size: CGSize) -> CGFloat {
        let max = getMax()
        let height = (point / max) * (size.height) - 37
        return height
    }
}

//#Preview {
//    PerformanceHistoryGraph(history: [
//        PerformanceHistory(id: UUID(), date: Date(), score: 40, numberOfQuestions: 10),
//        PerformanceHistory(id: UUID(), date: Date(), score: 80, numberOfQuestions: 10),
//        PerformanceHistory(id: UUID(), date: Date(), score: 30, numberOfQuestions: 10),
//        PerformanceHistory(id: UUID(), date: Date(), score: 90, numberOfQuestions: 10),
//        PerformanceHistory(id: UUID(), date: Date(), score: 30, numberOfQuestions: 20),
//        PerformanceHistory(id: UUID(), date: Date(), score: 20, numberOfQuestions: 10),
//        PerformanceHistory(id: UUID(), date: Date(), score: 70, numberOfQuestions: 10)
//    ], mainColor: .teal, subColor: .themePurpleLight)
//}

struct Performance: Identifiable, Hashable, Equatable {
    let id: UUID
    var date: Date
    var score: CGFloat
    
    init(id: UUID, date: Date, score: CGFloat) {
        self.id = id
        self.date = date
        self.score = score
    }
}

struct PerformanceHistory: Identifiable, Hashable, Equatable {
    let id: UUID
    var date: Date
    var score: CGFloat
    var numberOfQuestions: Int
    
    init(id: UUID, date: Date, score: CGFloat, numberOfQuestions: Int) {
        self.id = id
        self.date = date
        self.score = score
        self.numberOfQuestions = numberOfQuestions
    }
}

