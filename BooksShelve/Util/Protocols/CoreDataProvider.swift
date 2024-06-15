//
//  CoreDataProvider.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 25/04/24.
//

import Foundation

protocol CoreDataProvider {
    associatedtype T
    func fetchFromStorage() -> [T]?
    func fetchFromStorage(_ fetchType: FetchType) -> [T]?
    func saveToStorage(_ item: T) throws
    func removeFromStorage(_ item: T) throws
    func updateOnStorage(_ item: T) throws
}

extension CoreDataProvider {
    func fetchFromStorage() -> [T]? {
        fatalError("provide logic")
    }
    func fetchFromStorage(_ fetchType: FetchType) -> [T]? {
        fatalError("provide logic")
    }
}
