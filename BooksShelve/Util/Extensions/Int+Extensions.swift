//
//  Int+Extensions.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/06/24.
//

import Foundation

extension Int {
    
    func toString() throws -> String {
        let string = String(self)
        guard !string.isEmpty else {
            throw CastError.stringError
        }
        return string
    }
}
