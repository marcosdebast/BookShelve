//
//  PercentFormat.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 19/04/24.
//

import Foundation

struct PercentFormat: FormatStyle {
    let decimals: Int
    func format(_ value: Float) -> String {
        value.formatted(.percent.precision(.fractionLength(0...decimals)))
    }
}

extension FormatStyle where Self == PercentFormat {
    static func percent(decimals: Int) -> PercentFormat {
        .init(decimals: decimals)
    }
}

extension Optional where Wrapped == Float {
    func formatted(_ format: PercentFormat) -> String {
        self?.formatted(format) ?? "_"
    }
}
