//
//  BookSquareView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/04/24.
//

import SwiftUI

struct BookSquareView: View {
    @State var book: Book
    @State var size: CGFloat
    
    var body: some View {
        VStack(spacing: 3) {
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
                .clipShape(.rect(cornerRadius: size/5))
                .frame(width: size, height: size)
            VStack {
                Text(book.title)
                    .foregroundStyle(.accent)
                    .opacity(0.5)
                    .font(.caption)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 40)
        }
        .frame(maxWidth: size)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 25
    }
}
