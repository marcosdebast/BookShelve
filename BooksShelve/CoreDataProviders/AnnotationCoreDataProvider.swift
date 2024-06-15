//
//  AnnotationCoreDataProvider.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 03/06/24.
//

import CoreData
import UIKit

struct AnnotationCoreDataProvider: CoreDataProvider {
    private let viewContext = CoreDataStack.shared.persistentContainer.viewContext
    private unowned var viewModel: AnnotationViewModel
    
    init(viewModel: AnnotationViewModel) {
        self.viewModel = viewModel
    }
    
    func fetchFromStorage() -> [Annotation]? {
        guard let bookId = viewModel.book.id
        else {
            return nil
        }
        let fetchRequest = NSFetchRequest<AnnotationEntity>(entityName: AnnotationEntity.schema)
        fetchRequest.predicate = \AnnotationEntity.bookId == bookId
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let annotations = try viewContext.fetch(fetchRequest)
            return annotations.compactMap({$0.toClass()})
        } catch let error {
            print(error.localizedDescription)
            //TODO: Create error handling logic
            return nil
        }
    }
    
    func saveToStorage(_ annotation: Annotation) {
        do {
            annotation.toEntity()
            try viewContext.save()
        } catch {
            fatalError()
        }
        viewModel.refreshData()
    }
    
    func removeFromStorage(_ annotation: Annotation) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AnnotationEntity.schema)
        fetchRequest.predicate = \AnnotationEntity.id == annotation.id
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try viewContext.execute(request)
        viewModel.refreshData()
    }
    
    func updateOnStorage(_ annotation: Annotation) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AnnotationEntity.schema)
        fetchRequest.predicate = \AnnotationEntity.id == annotation.id
        
        guard let existingAnnotation = try viewContext.fetch(fetchRequest).first as? AnnotationEntity else {
            throw CoreDataError.fetchError
        }
        existingAnnotation.text = annotation.text
        existingAnnotation.date = annotation.date
        existingAnnotation.page = annotation.page.numberValue
        existingAnnotation.color = UIColor(annotation.color)
        existingAnnotation.fontStyle = annotation.fontStyle.rawValue.numberValue
        existingAnnotation.page = annotation.page.numberValue
        try viewContext.save()

        viewModel.updateListID()
        viewModel.refreshData()
    }
}
