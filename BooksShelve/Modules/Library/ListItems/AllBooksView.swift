//
//  AllBooksView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 27/04/24.
//

import SwiftUI

struct AllBooksView: View {
    @Environment(BooksViewModel.self) private var viewModel
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        let recentlyAddedBooks = viewModel.getBooks(by: .recentlyAdded)
        if !recentlyAddedBooks.isEmpty {
            //RecentlyAddedBooksView()
        }
        let allBooks = viewModel.getBooks(by: .all)
        CustomSection("Library") {
            LazyVGrid(columns: adaptiveColumns, spacing: 25) {
                ForEach(allBooks, id: \.self) { book in
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
        .emptyPlaceholder(allBooks) {
            CustomContentUnavailableView(label: "NoBooksInYourLibrary",
                                         image: "doc.richtext.fill",
                                         text: "TapPlusToAdd.")
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
    AllBooksView()
}
