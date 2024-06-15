//
//  BookCoreDataProvider.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 25/04/24.
//

import CoreData

struct BookCoreDataProvider: CoreDataProvider {
    private let viewContext = CoreDataStack.shared.persistentContainer.viewContext
    private unowned var viewModel: BooksViewModel
    
    init(viewModel: BooksViewModel) {
        self.viewModel = viewModel
    }
    
    func fetchFromStorage(_ fetchType: FetchType) -> [Book]? {
        let fetchRequest = NSFetchRequest<BookEntity>(entityName: BookEntity.schema)
        fetchRequest.relationshipKeyPathsForPrefetching = ["readingSessions"]
        
        do {
            switch fetchType {
            case .all:
                let books = try viewContext.fetch(fetchRequest)
                return books.compactMap({$0.toClass()})
            case .inProgress:
                fetchRequest.predicate = \BookEntity.started == true
                let books = try viewContext.fetch(fetchRequest)
                return books.compactMap({$0.toClass()}).filter(!\.isFinished)
            case .finished:
                fetchRequest.predicate = \BookEntity.started == true
                let books = try viewContext.fetch(fetchRequest)
                return books.compactMap({$0.toClass()}).filter(\.isFinished)
            case .recentlyAdded:
                let books = try viewContext.fetch(fetchRequest).filter({$0.addedDate > Date().minusDays(1)})
                return books.compactMap({$0.toClass()})
            }
        } catch let error {
            print(error.localizedDescription)
            //TODO: Create error handling logic
            return nil
        }
    }
    
    func saveToStorage(_ book: Book) throws {
        book.toEntity()
        try viewContext.save()
        viewModel.refreshData()
    }
    
    func removeFromStorage(_ book: Book) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: BookEntity.schema)
        
        if let bookId = book.id {
            fetchRequest.predicate = \BookEntity.id == bookId
        } else {
            fetchRequest.predicate = \BookEntity.title == book.title
        }
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try viewContext.execute(request)
        viewModel.refreshData()
    }
    
    func updateOnStorage(_ book: Book) throws {
        guard let bookId = book.id else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: BookEntity.schema)
        fetchRequest.predicate = \BookEntity.id == bookId
        
        guard let existingBook = try viewContext.fetch(fetchRequest).first as? BookEntity else {
            throw CoreDataError.fetchError
        }
        
        existingBook.title = book.title
        existingBook.descriptionText = (book.descriptionText?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) > 0 ? book.descriptionText?.trimmingCharacters(in: .whitespacesAndNewlines) : nil
        existingBook.authors = book.authors.filter({!$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty}).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        existingBook.pages = book.pages?.numberValue
        existingBook.started = book.started
        existingBook.startedDate = book.startedDate
        existingBook.endedDate = book.endedDate
        existingBook.currentPage = book.currentPage.numberValue
        try viewContext.save()
        
        viewModel.refreshData()
    }
}
