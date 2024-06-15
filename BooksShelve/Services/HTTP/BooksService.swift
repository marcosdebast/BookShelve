//
//  BooksService.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 02/05/24.
//

import Foundation

protocol BooksServiceProtocol {
    func getBooks(query: String) async throws -> DataCodable<[Item]>
    func getBook(isbn: String) async throws -> DataCodable<[Item]>
}

final class BooksService: BooksServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }
    
    func getBooks(query: String) async throws -> DataCodable<[Item]> {
        return try await httpClient.request(endpoint: BooksEndpoint.getBooks(query: query), model: DataCodable<[Item]>.self)
    }
    
    func getBook(isbn: String) async throws -> DataCodable<[Item]> {
        return try await httpClient.request(endpoint: BooksEndpoint.getBook(isbn: isbn), model: DataCodable<[Item]>.self)
    }
}
