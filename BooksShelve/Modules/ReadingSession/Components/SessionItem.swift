//
//  SessionItem.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 22/04/24.
//

import SwiftUI

struct SessionItem: View {
    
    //MARK: Attributes
    @State var readingSession: ReadingSession
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 25))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        if (calendar.isDateInToday(readingSession.startDate)) {
                            Text("Start:")
                                .font(.system(size: 16, weight: .medium))
                            +
                            Text("Today \(readingSession.startDate.formatted(date: .omitted, time: .shortened))")
                        } else if (calendar.isDateInYesterday(readingSession.startDate)) {
                            Text("Start:")
                                .font(.system(size: 16, weight: .medium))
                            +
                            Text("Yesterday \(readingSession.startDate.formatted(date: .omitted, time: .shortened))")
                        } else {
                            Text("Start:")
                                .font(.system(size: 16, weight: .medium))
                            +
                            Text(readingSession.startDate.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                    if let endDate = readingSession.endDate {
                        Group {
                            Text("End:")
                                .font(.system(size: 16, weight: .medium))
                            +
                            Text(endDate.formatted(date: .abbreviated, time: .shortened))
                        }
                        if let endPage = readingSession.endPage {
                            Group {
                                Text("PagesRead:")
                                    .font(.system(size: 16, weight: .medium))
                                +
                                Text("\(endPage-readingSession.startPage) pages")
                            }
                        }
                    } else {
                        Text("InProgress...")
                            .foregroundStyle(.green)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}
