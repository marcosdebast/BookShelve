//
//  ReadingSessionChart.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 22/04/24.
//

import SwiftUI
import Charts

struct ReadingSessionChart: View {
    let readingSessions: [ReadingSession]
    
    var items: [(date: String, totalPagesRead: Int)] {
        return joinSessionsByEndDate()
    }
    
    private var itemSize: CGFloat {
        return 60
    }
    
    private var chartWidth: CGFloat {
        return CGFloat(items.count) * itemSize
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { value in
                        Chart {
                            ForEach(items, id: \.0) { item in
                                LineMark(
                                    x: .value("Date", item.date),
                                    y: .value("Pages", item.totalPagesRead)
                                )
                                .interpolationMethod(.catmullRom)
                                .lineStyle(.init(lineWidth: 2))
                                .symbol {
                                    Circle()
                                        .fill(.yellow)
                                        .frame(width: 5)
                                        .shadow(radius: 2)
                                }
                            }
                        }
                        .frame(width: chartWidth < proxy.size.width ? proxy.size.width : chartWidth)
                        .padding(.leading, 30)
                        .padding(.top)
                        .id(1)
                        .onAppear {
                            value.scrollTo(1, anchor: .trailing)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 150)
    }
    
    private func joinSessionsByEndDate() -> [(date: String, totalPagesRead: Int)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"

        let sessionsByDate = readingSessions.reduce(into: [String: Int]()) { dict, session in
            guard let endDate = session.endDate, let endPage = session.endPage else { return }
            let dateString = dateFormatter.string(from: endDate)
            dict[dateString, default: 0] += (endPage - session.startPage)
        }

        let result = sessionsByDate.sorted(by: { dateFormatter.date(from: $0.key)! < dateFormatter.date(from: $1.key)! }).map { (date: $0.key, totalPagesRead: $0.value) }
        return result
    }
}
