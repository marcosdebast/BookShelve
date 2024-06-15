//
//  FinishedBooksView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 27/04/24.
//

import SwiftUI

struct FinishedBooksView: View {
    @Environment(BooksViewModel.self) private var viewModel
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        let books = viewModel.getBooks(by: .finished)
        CustomSection("Finished") {
            LazyVGrid(columns: adaptiveColumns, spacing: 25) {
                ForEach(books, id: \.self) { book in
                    NavigationLink(value: book) {
                        //TODO: Componentize this - DRY Principles
                        BookRectangleView(book: book)
                            .contextMenu {
                                Button {
                                    withAnimation(.easeOut) {
                                        deleteBook(book: book)
                                    }
                                } label: {
                                    Label("RemoveFromLibrary", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
        .emptyPlaceholder(books) {
            CustomContentUnavailableView(label: "Ops...",
                                         image: "doc.richtext.fill",
                                         text: "ThereAreNotFinishedBooks")
        }
    }
    
    private func deleteBook(book: Book) {
        do {
            try viewModel.bookDataCoreData.removeFromStorage(book)
        } catch {
            // TODO: Create error handling logic
        }
    }
}

#Preview {
    FinishedBooksView()
}
