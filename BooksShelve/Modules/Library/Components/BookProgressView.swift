//
//  BookProgressView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 22/04/24.
//

import SwiftUI

enum Style {
    case small
    case big
}

struct BookProgressView: View {
    @State var book: Book
    
    let style: Style
    
    /*init(book: Book, style: Style) {
        self.book = book
        self.style = style
    }*/
    
    var body: some View {
        switch style {
        case .small:
            SmallBookProgressView(book: book)
        case .big:
            BigBookProgressView(book: book)
        }
    }
}

struct SmallBookProgressView: View {
    @State var book: Book
    
    var body: some View {
        VStack {
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
                .clipShape(.rect(cornerRadius: Constants.imageSize/5))
                .frame(width: Constants.imageSize, height: Constants.imageSize)
            
            Group {
                Text(book.title)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.4)
                    .frame(height: 18)
                Text(book.authorsDescription)
                    .font(.system(size: 12, weight: .light))
            }
            .foregroundStyle(.accent)
            .multilineTextAlignment(.leading)
            HStack {
                let progress = book.progress ?? 0
                ProgressView(value: progress)
                    .tint(.white)
                    .background(.clear)
                    .layoutPriority(0)
                Text(progress, format: .percent(decimals: 0))
                    .font(.system(size: 12, weight: .heavy))
                    .layoutPriority(1)
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: Constants.imageSize/5))
        .frame(maxWidth: Constants.widthSize, maxHeight: Constants.heightSize)
    }
    
    private struct Constants {
        static let imageSize: CGFloat = 100
        
        static let widthSize: CGFloat = 150
        static let heightSize: CGFloat = 200
    }
}

struct BigBookProgressView: View {
    @State var book: Book
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
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
                    .clipShape(.rect(cornerRadius: Constants.imageSize/5))
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                VStack {
                    Group {
                        Text(book.title)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.4)
                            .frame(height: 20)
                        Text(book.authorsDescription)
                            .font(.system(size: 16, weight: .light))
                    }
                    .foregroundStyle(.accent)
                    .multilineTextAlignment(.leading)
                    HStack {
                        let progress = book.progress ?? 0
                        ProgressView(value: progress)
                            .tint(.white)
                            .background(.clear)
                            .layoutPriority(0)
                        Text(progress, format: .percent(decimals: 0))
                            .font(.system(size: 12, weight: .heavy))
                            .layoutPriority(1)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: Constants.imageSize/5))
        }
        .padding(.horizontal)
    }
    
    private struct Constants {
        static let imageSize: CGFloat = 150
    }
}
