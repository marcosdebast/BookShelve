//
//  ReadingSessionEntity.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 18/04/24.
//

import CoreData

final class ReadingSessionEntity: NSManagedObject, CoreDataEntity {
    static let schema = "ReadingSessionEntity"
    
    @NSManaged var id: UUID
    @NSManaged var bookId: String
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date?
    @NSManaged var startPage: NSNumber
    @NSManaged var endPage: NSNumber?
    
    convenience init(id: UUID, bookId: String, startDate: Date, endDate: Date? = nil, startPage: NSNumber, endPage: NSNumber? = nil) {
        self.init(context: CoreDataStack.shared.persistentContainer.viewContext)
        self.id = id
        self.bookId = bookId
        self.startDate = startDate
        self.endDate = endDate
        self.startPage = startPage
        self.endPage = endPage
    }
    
    func toClass() -> ReadingSession {
        return ReadingSession(
            id: id,
            bookId: bookId,
            startDate: startDate,
            endDate: endDate,
            startPage: startPage.intValue,
            endPage: endPage?.intValue
        )
    }
}
