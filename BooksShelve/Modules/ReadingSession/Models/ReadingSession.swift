//
//  ReadingSession.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 18/04/24.
//

import CoreData

extension ReadingSession {
    static func generateDummyData() -> [ReadingSession] {
        let startDate = Date()
        let durationInDays = 10
        let bookId = "book_id"

        var sessions: [ReadingSession] = []
        
        let pageRange = 50...200
        
        var currentDate = startDate
        let calendar = Calendar.current
        
        for _ in 1...durationInDays {
            let endDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            let startPage = Int.random(in: pageRange)
            let endPage = Int.random(in: startPage...pageRange.upperBound)
            
            let session = ReadingSession(bookId: bookId, startDate: currentDate, endDate: endDate, startPage: startPage, endPage: endPage)
            sessions.append(session)
            
            currentDate = endDate
        }
        
        return sessions.sorted(by: {$0.endDate! < $1.endDate!})
    }
}

struct ReadingSession: Identifiable, Hashable, CoreDataObject, Sendable {

    var id = UUID()
    var bookId: String
    var startDate: Date
    var endDate: Date?
    var startPage: Int
    var endPage: Int?
    
    var isInProgress: Bool {
        return endDate == nil
    }

    init(id: UUID = UUID(), bookId: String, startDate: Date, endDate: Date? = nil, startPage: Int, endPage: Int? = nil) {
        self.id = id
        self.bookId = bookId
        self.startDate = startDate
        self.endDate = endDate
        self.startPage = startPage
        self.endPage = endPage
    }
 
    @discardableResult func toEntity() -> ReadingSessionEntity {
        return ReadingSessionEntity(
            id: id,
            bookId: bookId,
            startDate: startDate,
            endDate: endDate,
            startPage: startPage.numberValue,
            endPage: endPage?.numberValue
        )   
    }
}
