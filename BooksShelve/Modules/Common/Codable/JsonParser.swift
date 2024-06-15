//
//  ItemsCodable.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import Foundation

class DataCodable<T: Decodable>: Decodable {
    var items: T
}

class Item: Decodable {
    var id: String
    var book: Book
    
    enum CodingKeys: String, CodingKey {
        case id
        case book = "volumeInfo"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.book = try container.decode(Book.self, forKey: .book)
    }
}
