//
//  InProgressBooks.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 19/04/24.
//

import SwiftUI

struct InProgressBooks: View {
    @Environment(BooksViewModel.self) private var viewModel
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        let books = viewModel.getBooks(by: .inProgress)
        CustomSection("ContinueReading") {
            LazyVGrid(columns: adaptiveColumns, spacing: 25) {
                ForEach(books, id: \.self) { book in
                    NavigationLink(value: book) {
                        BookProgressView(book: book, style: .small)
                    }
                }
            }
        }
        .emptyPlaceholder(books) {
            CustomContentUnavailableView(label: "Ops...",
                                         image: "doc.richtext.fill",
                                         text: "ThereAreNotBooksInProgress")
        }
    }
}

#Preview {
    InProgressBooks()
}
