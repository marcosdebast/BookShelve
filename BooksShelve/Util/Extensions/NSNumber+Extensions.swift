//
//  NSNumber+Extensions.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 17/04/24.
//

import Foundation

extension NSNumber {
    convenience init?(int: Int?) {
        guard let int else {
            return nil
        }
        self.init(integerLiteral: int)
    }
}

extension Int {
    var numberValue: NSNumber {
        NSNumber(integerLiteral: self)
    }
}
