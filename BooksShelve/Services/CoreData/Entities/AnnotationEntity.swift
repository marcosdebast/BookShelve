//
//  AnnotationEntity.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import CoreData
import SwiftUI

final class AnnotationEntity: NSManagedObject, CoreDataEntity {
    static let schema = "AnnotationEntity"
    
    @NSManaged var id: UUID
    @NSManaged var text: String
    @NSManaged var date: Date
    @NSManaged var page: NSNumber
    @NSManaged var bookId: String
    @NSManaged var color: UIColor
    @NSManaged var fontStyle: NSNumber
    
    convenience init(id: UUID, text: String, date: Date, page: NSNumber, bookId: String, color: UIColor, fontStyle: NSNumber) {
        self.init(context: CoreDataStack.shared.persistentContainer.viewContext)
        self.id = id
        self.text = text
        self.date = date
        self.page = page
        self.bookId = bookId
        self.color = color
        self.fontStyle = fontStyle
    }

    func toClass() -> Annotation {
        return Annotation(
            id: id,
            text: text,
            date: date,
            page: page.intValue,
            color: Color(uiColor: color),
            fontStyle: FontStyle(rawValue: fontStyle.intValue) ?? .regular,
            bookId: bookId
        )
    }
}
