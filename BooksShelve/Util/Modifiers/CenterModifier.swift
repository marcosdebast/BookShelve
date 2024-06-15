//
//  CenterModifier.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 18/04/24.
//

import SwiftUI

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

extension View {
    func centerModifier() -> some View {
        modifier(CenterModifier())
    }
}
