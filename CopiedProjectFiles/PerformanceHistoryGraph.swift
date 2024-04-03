//
//  PerformanceHistoryGraph.swift
//  ExamGenius
//
//  Created by Tony Nlemadim on 12/25/23.
//

import SwiftUI

struct PerformanceHistoryGraph: View {
    var history: [PerformanceModel2] = []
    
    var body: some View {
        HStack {
            Text("Performance History")
                .font(.title3)
                .fontWeight(.semibold)
            
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
                
                GraphView()
                
            }
        }
        .frame(minHeight: 190)
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
                                .foregroundStyle(.gray)
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: -15)
                    }
                }
                
                HStack {
//                    ForEach(history) { performance in
//                        VStack(spacing: 0) {
//                            VStack(spacing: 5) {
//                                Capsule()
//                                    .fill(.teal) // Replace with your color
//                                
//                                Capsule()
//                                    .fill(.themePurple) // Replace with your color
//                            }
//                            .frame(width: 8)
//                            .frame(height: getBarHeight(point: performance.score, size: proxy.size))
//                            
//                            Text(formatDate(performance.date))
//                                .font(.caption)
//                                .foregroundStyle(.quizMain) // Replace with your color
//                                .frame(height: 25, alignment: .bottom)
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//                    }
                }
                .padding(.leading, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            //.frame(minWidth: .infinity)
        }
        .frame(height: 190)
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

#Preview {
    PerformanceHistoryGraph(history: [
        PerformanceModel2(id: UUID(), date: Date(), score: 48),
        PerformanceModel2(id: UUID(), date: Date(), score: 83),
        PerformanceModel2(id: UUID(), date: Date(), score: 39),
        PerformanceModel2(id: UUID(), date: Date(), score: 90),
        PerformanceModel2(id: UUID(), date: Date(), score: 35),
        PerformanceModel2(id: UUID(), date: Date(), score: 25),
        PerformanceModel2(id: UUID(), date: Date(), score: 75)
    ])
}


struct PerformanceModel2: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var score: CGFloat
    
    init(id: UUID, date: Date, score: CGFloat) {
        self.id = id
        self.date = date
        self.score = score
    }
}
