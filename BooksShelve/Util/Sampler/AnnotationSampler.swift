//
//  AnnotationSampler.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/06/24.
//

import Foundation

struct AnnotationSampler {
    
    static private(set) var one: Annotation = Annotation(id: .init(), text: "My annotation", date: .now, page: 1, color: .red, fontStyle: .bold, bookId: "")
    
}
