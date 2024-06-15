//
//  Book.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 03/04/24.
//

import CoreData

struct Book: Identifiable, Decodable, Hashable, CoreDataObject {
    
    var id: String?
    var title: String
    var descriptionText: String?
    var authors: [String]
    var authorsDescription: String {
        return authors.joined(separator: ", ")
    }
    var publishedDate: Date?
    var addedDate: Date?
    var startedDate: Date?
    var endedDate: Date?
    var industryIdentifiers : [ISBNIdentifier]?
    var pages: Int?
    var currentPage: Int = 1
    var imageLinks: ImageLink?
    var language: String
    var progress: Float? {
        get {
            guard let pages else {
                return nil
            }
            let progress = Float(Float(currentPage)/Float(pages))
            return progress > 1 ? 1 : progress
        }
    }
    var active: Bool = true
    var started: Bool = false
    var readingSessions: [ReadingSession]?
    
    var isFinished: Bool {
        currentPage == pages
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case descriptionText = "description"
        case authors
        case publishedDate
        case industryIdentifiers
        case pages = "pageCount"
        case printedPageCount
        case imageLinks
        case language
    }
    
    init(id: String? = nil, title: String, descriptionText: String? = nil, authors: [String], publishedDate: Date? = nil, addedDate: Date? = nil, startedDate: Date? = nil, endedDate: Date? = nil, industryIdentifiers: [ISBNIdentifier]? = nil, pages: Int? = nil, currentPage: Int, imageLinks: ImageLink? = nil, language: String, active: Bool = true, started: Bool) {
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.authors = authors
        self.publishedDate = publishedDate
        self.addedDate = addedDate
        self.startedDate = startedDate
        self.endedDate = endedDate
        self.industryIdentifiers = industryIdentifiers
        self.pages = pages
        self.currentPage = currentPage
        self.imageLinks = imageLinks
        self.language = language
        self.active = active
        self.started = started
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        self.authors = try container.decodeIfPresent([String].self, forKey: .authors) ?? []
        self.publishedDate = try? container.decodeIfPresent(Date.self, forKey: .publishedDate)
        self.industryIdentifiers = try container.decodeIfPresent([ISBNIdentifier].self, forKey: .industryIdentifiers)
        self.pages = try container.decodeIfPresent(Int.self, forKey: .pages)
        self.imageLinks = try container.decodeIfPresent(ImageLink.self, forKey: .imageLinks)
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
    }
    
    @discardableResult func toEntity() -> BookEntity {
        return BookEntity(
            id: id,
            title: title,
            descriptionText: descriptionText,
            authors: authors,
            language: language,
            pages: pages?.numberValue,
            imageLink: imageLinks?.thumbnail,
            publishedDate: publishedDate,
            addedDate: addedDate ?? Date(),
            startedDate: startedDate,
            endedDate: endedDate,
            started: started,
            currentPage: currentPage.numberValue
        )
    }
}
