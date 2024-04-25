//
//  PerformanceHistoryGraph.swift
//  ExamGenius
//
//  Created by Tony Nlemadim on 12/25/23.
//

import SwiftUI

struct PerformanceHistoryGraph: View {
    var history = [Performance]()
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
                
                GraphView()
                    
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
                            
                            Text(formatDate(performance.date))
                                .font(.caption)
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
        Performance(id: UUID(), date: Date(), score: 40),
        Performance(id: UUID(), date: Date(), score: 80),
        Performance(id: UUID(), date: Date(), score: 30),
        Performance(id: UUID(), date: Date(), score: 90),
        Performance(id: UUID(), date: Date(), score: 30),
        Performance(id: UUID(), date: Date(), score: 20),
        Performance(id: UUID(), date: Date(), score: 70)
    ], mainColor: .teal, subColor: .themePurpleLight)
}

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
