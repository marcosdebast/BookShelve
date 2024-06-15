//
//  BooksEndpoint.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import Foundation

enum BooksEndpoint {
    case getBooks(query: String)
    case getBook(isbn: String)
}

extension BooksEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getBooks, .getBook:
            return "volumes"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBooks, .getBook:
            return .get
        }
    }
    
    var queryParams: [URLQueryItem] {
        switch self {
        case .getBooks(let query):
            return [
                URLQueryItem(name: "q", value: "\(query)"),
                URLQueryItem(name: "printType", value: "books")
            ]
        case .getBook(let isbn):
            return [
                URLQueryItem(name: "q", value: "\("isbn:\(isbn)")")
            ]
        }
    }
}
