//
//  ReadingSessionCoreDataProvider.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 25/04/24.
//

import CoreData

struct ReadingSessionCoreDataProvider: CoreDataProvider {
    private let viewContext = CoreDataStack.shared.persistentContainer.viewContext
    private unowned var viewModel: BooksViewModel
    
    init(viewModel: BooksViewModel) {
        self.viewModel = viewModel
    }
    
    func fetchFromStorage() -> [ReadingSession]? {
        guard let book = viewModel.bookSelected,
              let bookId = book.id
        else {
            return nil
        }
        let fetchRequest = NSFetchRequest<ReadingSessionEntity>(entityName: ReadingSessionEntity.schema)
        fetchRequest.predicate = \ReadingSessionEntity.bookId == bookId
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        do {
            let readingSessions = try viewContext.fetch(fetchRequest)
            viewModel.ongoingSession = readingSessions.first(where: \.endDate == nil)?.toClass()
            return readingSessions.compactMap({$0.toClass()})
        } catch let error {
            print(error.localizedDescription)
            //TODO: Create error handling logic
            return nil
        }
    }
    
    func saveToStorage(_ readingSession: ReadingSession) {
        do {
            readingSession.toEntity()
            try viewContext.save()
        } catch {
            fatalError()
        }
        viewModel.ongoingSession = readingSession
        viewModel.refreshData()
    }
    
    func removeFromStorage(_ readingSession: ReadingSession) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ReadingSessionEntity.schema)
        fetchRequest.predicate = \ReadingSessionEntity.id == readingSession.id
        do {
            let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try viewContext.execute(request)
        } catch {
        //TODO: Create error handling logic
        }
        viewModel.refreshData()
    }
    
    func updateOnStorage(_ readingSession: ReadingSession) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ReadingSessionEntity.schema)
        fetchRequest.predicate = \ReadingSessionEntity.id == readingSession.id
        do {
            if let fetchedReadingSession = try viewContext.fetch(fetchRequest).first as? ReadingSessionEntity {
                fetchedReadingSession.endDate = readingSession.endDate
                fetchedReadingSession.endPage = readingSession.endPage?.numberValue
                try viewContext.save()
            }
        } catch {
            // TODO: Create error handling logic
        }
        //viewModel.refreshData()
    }
}
