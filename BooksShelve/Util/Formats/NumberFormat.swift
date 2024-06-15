//
//  NumberFormat.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/04/24.
//

import Foundation

struct NumberFormat: FormatStyle {
    let decimals: Int
    func format(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...decimals)))
    }
}

extension FormatStyle where Self == NumberFormat {
    static func number(decimals: Int) -> NumberFormat {
        .init(decimals: decimals)
    }
}

extension Optional where Wrapped == Double {
    func formatted(_ format: NumberFormat) -> String {
        self?.formatted(format) ?? "_"
    }
}
