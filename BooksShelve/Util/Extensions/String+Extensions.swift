//
//  String+Extensions.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI

extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? .emptyString
    }
}

extension String {
    static var emptyString: String {
        return ""
    }
    static var newLine: String {
        return "\n"
    }
    static var newParagraph: String {
        return "\n\n"
    }
    var localized: LocalizedStringKey {
        return LocalizedStringKey(self)
    }
    
    func toInt() throws -> Int {
        guard let int = Int(self) else {
            throw CastError.intError
        }
        return int
    }
}
