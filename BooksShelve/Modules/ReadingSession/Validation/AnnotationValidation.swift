//
//  AnnotationValidation.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 04/06/24.
//

import Foundation

struct AnnotationValidation {
    enum Message: String {
        case pleaseTypePage = "PleaseInformPage"
        case pleaseInformValidPage = "PleaseInformValidPage"
        case pleaseTypeAnnotation = "PleaseTypeAnnotation"
    }
}

extension AnnotationValidation {
    struct Save {
        static func validate(page: String, text: String, book: Book) -> (message: String, validated: Bool) {
            guard !page.trimmingCharacters(in: .whitespaces).isEmpty else {
                return (Message.pleaseTypePage.rawValue, false)
            }
            
            guard let intPage = try? page.toInt(),
                  intPage > 0,
                  let bookPages = book.pages,
                  bookPages >= intPage
            else {
                return (Message.pleaseInformValidPage.rawValue, false)
            }

            guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return (Message.pleaseTypeAnnotation.rawValue, false)
            }
            
            return (.emptyString, true)
        }
    }
    
    struct Edit {
        static func validate(date: Date, page: String, text: String, book: Book) -> (message: String, validated: Bool) {
            guard !page.trimmingCharacters(in: .whitespaces).isEmpty else {
                return (Message.pleaseTypePage.rawValue, false)
            }
            
            guard let intPage = try? page.toInt(),
                  intPage > 0,
                  let bookPages = book.pages,
                  bookPages >= intPage
            else {
                return (Message.pleaseInformValidPage.rawValue, false)
            }
           
            guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return (Message.pleaseTypeAnnotation.rawValue, false)
            }
            
            return (.emptyString, true)
        }
    }
}
