//
//  FontModifier.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import SwiftUI

struct FontModifier: ViewModifier {
    let style: FontStyle
    
    func body(content: Content) -> some View {
        return AnyView(content
            .style(style))
    }
}

extension View {
    func applyFontStyle(_ style: FontStyle) -> some View {
        modifier(FontModifier(style: style))
    }
    
    func style(_ style: FontStyle) -> any View {
        style.design(content: self)
    }
}
