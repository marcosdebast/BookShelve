//
//  Annotation.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import SwiftUI

struct Annotation: Identifiable, Hashable, CoreDataObject, Sendable {
    
    var id = UUID()
    var text: String
    var date: Date
    var page: Int
    var color: Color
    var fontStyle: FontStyle
    var bookId: String
    
    @discardableResult func toEntity() -> AnnotationEntity {
        return AnnotationEntity(
            id: id,
            text: text,
            date: date,
            page: page.numberValue,
            bookId: bookId,
            color: UIColor(color),
            fontStyle: fontStyle.rawValue.numberValue
        )
    }
}
