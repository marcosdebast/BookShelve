//
//  BookValidation.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 27/04/24.
//

import Foundation

struct BookValidation {
    enum Message: String {
        case pleaseTypeBookTitle = "PleaseTypeBookTitle"
        case pleaseTypePage = "PleaseTypePage"
        case pleaseTypeAValidCurrentPage = "PleaseTypeCurrentPage"
        case numberOfPagesMustBeGreaterThanOrEqualCurrentPage = "NumberOfPagesMustBeGreaterThanOrEqualCurrentPage"
    }
}

extension BookValidation {
    struct Update {
        static func validate(title: String, pages: String, currentPage: String) -> (message: String, validated: Bool) {
            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
                return (Message.pleaseTypeBookTitle.rawValue, false)
            }
            guard !pages.trimmingCharacters(in: .whitespaces).isEmpty else {
                return (Message.pleaseTypePage.rawValue, false)
            }
            guard !currentPage.trimmingCharacters(in: .whitespaces).isEmpty else {
                return (Message.pleaseTypeAValidCurrentPage.rawValue, false)
            }
            guard let intPages = Int(pages),
                  let intCurrentPage = Int(currentPage),
                  intPages >= intCurrentPage
            else {
                return (Message.numberOfPagesMustBeGreaterThanOrEqualCurrentPage.rawValue, false)
            }
            
            return (.emptyString, true)
        }
    }
}
