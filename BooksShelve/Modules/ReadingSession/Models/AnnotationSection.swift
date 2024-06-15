//
//  AnnotationSection.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 04/06/24.
//

import Foundation

class AnnotationSection {
    
    var date: Date
    var annotations: [Annotation]
    
    init(date: Date, annotations: [Annotation]) {
        self.date = date
        self.annotations = annotations
    }
}
