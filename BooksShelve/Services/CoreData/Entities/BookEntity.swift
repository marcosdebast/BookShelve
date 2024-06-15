//
//  BookEntity.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 17/04/24.
//

import CoreData

class BookEntity: NSManagedObject, CoreDataEntity {
    static let schema = "BookEntity"
    
    @NSManaged var id: String?
    @NSManaged var title: String
    @NSManaged var descriptionText: String?
    @NSManaged var authors: [String]
    @NSManaged var language: String
    @NSManaged var pages: NSNumber?
    @NSManaged var imageLink: String?
    @NSManaged var publishedDate: Date?
    @NSManaged var addedDate: Date
    @NSManaged var startedDate: Date?
    @NSManaged var endedDate: Date?
    @NSManaged var started: Bool
    @NSManaged var currentPage: NSNumber
    
    convenience init(id: String? = nil, title: String, descriptionText: String? = nil, authors: [String], language: String, pages: NSNumber? = nil, imageLink: String? = nil, publishedDate: Date? = nil, addedDate: Date, startedDate: Date? = nil, endedDate: Date? = nil, started: Bool, currentPage: NSNumber) {
        self.init(context: CoreDataStack.shared.persistentContainer.viewContext)
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.authors = authors
        self.language = language
        self.pages = pages
        self.imageLink = imageLink
        self.publishedDate = publishedDate
        self.addedDate = addedDate
        self.startedDate = startedDate
        self.endedDate = endedDate
        self.started = started
        self.currentPage = currentPage
    }
    
    func toClass() -> Book {
        return Book(
            id: id,
            title: title,
            descriptionText: descriptionText,
            authors: authors,
            publishedDate: publishedDate,
            addedDate: addedDate,
            startedDate: startedDate,
            endedDate: endedDate,
            industryIdentifiers: [],
            pages: pages?.intValue,
            currentPage: self.currentPage.intValue,
            imageLinks: ImageLink(thumbnail: imageLink),
            language: language,
            started: started
        )
    }
}
