//
//  CoreDataEntity+CoreDataObject.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 25/04/24.
//

import CoreData

protocol CoreDataEntity: NSManagedObject {
    associatedtype T
    func toClass() -> T
}

protocol CoreDataObject {
    associatedtype T
    @discardableResult func toEntity() -> T
}
