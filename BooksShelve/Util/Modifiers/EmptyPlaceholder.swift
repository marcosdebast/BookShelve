//
//  EmptyPlaceholder.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI

struct CustomContentUnavailableView: View {
    let label: String
    let image: String
    let text: String
    
    var body: some View {
        ContentUnavailableView {
            Label(label.localized, systemImage: image)
        } description: {
            Text(text.localized)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyPlaceholderModifier<Items: Collection>: ViewModifier {
    let items: Items
    let placeholder: AnyView
    
    @ViewBuilder func body(content: Content) -> some View {
        if !items.isEmpty {
            content
        } else {
            placeholder
        }
    }
}

extension View {
    func emptyPlaceholder<Items: Collection, PlaceholderView: View>(_ items: Items, _ placeholder: @escaping () -> PlaceholderView) -> some View {
        modifier(EmptyPlaceholderModifier(items: items, placeholder: AnyView(placeholder())))
    }
}
