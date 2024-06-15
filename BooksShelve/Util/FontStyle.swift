//
//  FontStyle.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import SwiftUI

enum FontStyle: Int, CaseIterable {
    case regular
    case bold
    case italic
    case underline
    
    var title: String {
        switch self {
        case .regular:
            "R"
        case .bold:
            "B"
        case .italic:
            "I"
        case .underline:
            "U"
        }
    }
    
    var description: String {
        switch self {
        case .regular:
            "Regular"
        case .bold:
            "Bold"
        case .italic:
            "Italic"
        case .underline:
            "Underline"
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .regular:
                .regular
        case .bold:
                .bold
        case .italic:
                .regular
        case .underline:
                .regular
        }
    }
    
    func design(content: any View) -> any View {
        switch self {
        case .regular:
            return content
        case .bold:
            return content.bold()
        case .italic:
            return content.italic()
        case .underline:
            return content.underline()
        }
    }
}
