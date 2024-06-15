//
//  DateFormat.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 25/04/24.
//

import Foundation

extension DateFormatter {
    static var slashFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
    
    static let noTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
