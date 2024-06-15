//
//  AnnotationViewModel.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 04/06/24.
//

import SwiftUI

protocol AnnotationDataUpdater {
    func editAnnotation(annotation: Annotation) throws
    func deleteAnnotation(annotation: Annotation) throws
}

protocol AnnotationDataFetcher {
    func getSections() -> [AnnotationSection]
    func refreshData()
}

@Observable
final class AnnotationViewModel {
    private(set) var id: UUID = UUID()
    private(set) var book: Book
    private(set) var annotationSelected: Annotation?
    
    private(set) var fetchStatus: FetchStatus = .loading

    private var allAnnotations: [Annotation] = []
    private var sections: [Annotation] = []

    init(book: Book) {
        self.book = book
        refreshData()
    }
    
    //MARK: Core data providers
    @ObservationIgnored
    lazy var annotationDataCoreData = AnnotationCoreDataProvider(viewModel: self)
    
    func refreshData() {
        if let allAnnotations = annotationDataCoreData.fetchFromStorage(), !allAnnotations.isEmpty {
            self.allAnnotations = allAnnotations
        }
        fetchStatus = .success
    }
}

extension AnnotationViewModel: AnnotationDataUpdater {
    func editAnnotation(annotation: Annotation) throws {
        id = .init()
        try annotationDataCoreData.updateOnStorage(annotation)
    }
    
    func deleteAnnotation(annotation: Annotation) throws {
        try annotationDataCoreData.removeFromStorage(annotation)
        allAnnotations.removeAll(where: \.id == annotation.id)
    }
}

extension AnnotationViewModel: AnnotationDataFetcher {
    func getSections() -> [AnnotationSection] {
        guard !allAnnotations.isEmpty else {
            return []
        }
        var sections = [AnnotationSection]()
        for annotation in allAnnotations {
            if let section = sections.first(where: {
                $0.date.formatted(date: .abbreviated, time: .omitted)
                ==
                annotation.date.formatted(date: .abbreviated, time: .omitted)
            }) {
                section.annotations.append(annotation)
            } else {
                let newSection = AnnotationSection(date: annotation.date, annotations: [annotation])
                sections.append(newSection)
            }
        }
        return sections
    }
}
