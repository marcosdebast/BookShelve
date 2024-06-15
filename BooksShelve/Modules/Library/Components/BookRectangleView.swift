//
//  BookRectangleView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/04/24.
//

import SwiftUI

struct BookRectangleView: View {
    var book: Book
    let height: CGFloat = 175
    
    var body: some View {
        Rectangle()
            .fill(.gray.opacity(0.5))
            .overlay {
                if let imageURL = book.imageLinks?.thumbnail, !imageURL.isEmpty, let url = URL(string: imageURL) {
                    SmoothAsyncImage(url: url, shouldResize: false) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Color.clear
                        }
                    }
                }
            }
            .frame(height: height)
            .clipShape(.rect(cornerRadius: 15))
            .clipped()
            .opacity(book.active ? 1 : 0)
    }
}
