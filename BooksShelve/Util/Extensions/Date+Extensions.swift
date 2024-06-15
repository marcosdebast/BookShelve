//
//  Date+Extensions.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/04/24.
//

import Foundation

extension Date {
    static func year(_ year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        let calendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    static func dateBySetting(year: Int, month: Int = 1, day: Int = 1) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents)
    }
    
    func minusDays(_ daysToRemove: Int) -> Date {
        guard let date = NSCalendar.current.date(byAdding: .day, value: daysToRemove * -1, to: self) else {
            return Date()
        }
        return date
    }
}
