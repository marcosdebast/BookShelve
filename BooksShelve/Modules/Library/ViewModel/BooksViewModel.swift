//
//  BooksViewModel.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/04/24.
//

import SwiftUI
import CoreData

protocol BookDataUpdater {
    func setTitle(_ title: String)
    func setDescriptionText(_ descriptionText: String)
    func setAuthors(_ authors: [String])
    func setPages(_ pages: String)
    func setCurrentPage(_ currentPage: String)
    func setAddedDate(_ addedDate: Date)
    func setStartedDate(_ startedDate: Date)
    func setEndedDate(_ endedDate: Date)
    func setBookSelected(_ book: Book)
}

protocol BookDataFetcher {
    func getBooks(by type: FetchType) -> [Book]
    func fetchQuery(_ query: String) async -> [Book]
    func fetchISBN(_ isbn: String) async -> Book?
    func refreshData()
}

@Observable
final class BooksViewModel {
    private let service: BooksServiceProtocol

    private(set) var queriedBooks: [Book] = []
    private(set) var fetchStatus: FetchStatus = .loading

    //MARK: Books list
    private var allBooks: [Book] = []
    private var inProgressBooks: [Book] = []
    private var finishedBooks: [Book] = []
    private var recentlyAddedBooks: [Book] = []
    
    //MARK: Core data providers
    @ObservationIgnored
    lazy var bookDataCoreData = BookCoreDataProvider(viewModel: self)
    @ObservationIgnored
    lazy var readingSessionCoreData = ReadingSessionCoreDataProvider(viewModel: self)
    
    //MARK: - Sessions
    var ongoingSession: ReadingSession?
    
    //MARK: Book selected
    //TODO: - Figure out a way to remove this variable. -
    private(set) var bookSelected: Book! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self, (bookSelected?.id != oldValue?.id || bookSelected?.readingSessions == nil) else {
                    return
                }
                bookSelected.readingSessions = readingSessionCoreData.fetchFromStorage()
            }
        }
    }
    
    init(service: BooksServiceProtocol = BooksService()) {
        self.service = service
        refreshData()
    }
    
    /*func removeBook(_ book: Book) {
        //TODO: Refactor later
        
        ongoingBooks = ongoingBooks.filter({$0.title != book.title})
        allBooks = allBooks.filter(\.title != book.title)
        removeFromStorage(book)
    }*/
    
    func setQueriedBooks(_ queriedBooks: [Book]) {
        self.queriedBooks = queriedBooks
    }
    
    func userLibraryContainsBook(_ book: Book) -> Bool {
        return allBooks.first(where: \.id == book.id) != nil
    }

    func createSession() {
        guard var book = bookSelected,
              let bookId = book.id
        else {
            return
        }
        if (!book.started) {
            book.started = true
            book.startedDate = Date()
            do {
                try bookDataCoreData.updateOnStorage(book)
            } catch {
                // TODO: Create error handling logic
            }
        }
        readingSessionCoreData.saveToStorage(ReadingSession(bookId: bookId, startDate: Date(), startPage: book.currentPage))
    }
    
    func endSession(page: Int) {
        guard var ongoingSession else {
            return
        }
        ongoingSession.endDate = Date()
        ongoingSession.endPage = page
        readingSessionCoreData.updateOnStorage(ongoingSession)
        self.ongoingSession = nil
    }
}

extension BooksViewModel: BookDataUpdater {
    func setTitle(_ title: String) {
        bookSelected.title = title
    }
    
    func setDescriptionText(_ descriptionText: String) {
        bookSelected.descriptionText = descriptionText
    }
    
    func setAuthors(_ authors: [String]) {
        bookSelected.authors = authors
    }
    
    func setPages(_ pages: String) {
        if let intPages = Int(pages) {
            bookSelected.pages = intPages
        }
    }
    
    func setCurrentPage(_ currentPage: String) {
        if let intCurrentPage = Int(currentPage) {
            bookSelected.currentPage = intCurrentPage
        }
    }
    
    func setAddedDate(_ addedDate: Date) {
        bookSelected.addedDate = addedDate
    }
    
    func setStartedDate(_ startedDate: Date) {
        bookSelected.startedDate = startedDate
    }
    
    func setEndedDate(_ endedDate: Date) {
        bookSelected.endedDate = endedDate
    }
    
    func setBookSelected(_ book: Book) {
        bookSelected = book
    }
}

extension BooksViewModel: BookDataFetcher {
    func getBooks(by type: FetchType) -> [Book] {
        switch type {
        case .all:
            allBooks
        case .inProgress:
            inProgressBooks
        case .finished:
            finishedBooks
        case .recentlyAdded:
            recentlyAddedBooks
        }
    }
    
    func fetchQuery(_ query: String) async -> [Book] {
        do {
            let books = try await service.getBooks(query: query)
                .items.compactMap({ item -> Book in
                    item.book.id = item.id
                    return item.book
                }).filter({$0.imageLinks != nil && $0.id != nil})
            setQueriedBooks(queriedBooks)
            return books
        } catch {
            return []
        }
    }
    
    func fetchISBN(_ isbn: String) async -> Book? {
        do {
            guard !isbn.isEmpty else {
                return nil
            }
            let book = try await service.getBook(isbn: isbn)
                .items.compactMap({$0.book}).first
            setQueriedBooks(queriedBooks)
            return book
        } catch {
            return nil
        }
    }
    
    //TODO: Need refactoring. Probably add a throws? Or handle errors?
    func refreshData() {
        if let storedBooks = bookDataCoreData.fetchFromStorage(.all) {
            allBooks = storedBooks
        }
        if let storedBooks = bookDataCoreData.fetchFromStorage(.inProgress) {
            inProgressBooks = storedBooks
        }
        if let storedBooks = bookDataCoreData.fetchFromStorage(.finished) {
            finishedBooks = storedBooks
        }
        if let storedBooks = bookDataCoreData.fetchFromStorage(.recentlyAdded) {
            recentlyAddedBooks = storedBooks
        }
        if bookSelected != nil, let book = allBooks.first(where: \.id == bookSelected.id) {
            bookSelected = book
            bookSelected.readingSessions = readingSessionCoreData.fetchFromStorage()
        }
        fetchStatus = .success
    }
}
