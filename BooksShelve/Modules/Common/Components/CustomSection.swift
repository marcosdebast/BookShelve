//
//  CustomSection.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/04/24.
//

import SwiftUI

struct CustomSection<Content: View>: View {
    let title: String
    let alignment: Alignment
    let content: () -> Content
    
    init(_ title: String, alignment: Alignment = .leading, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.alignment = alignment
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                Text(title.localized)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.accentColor)
                    .opacity(0.6)
                    .frame(maxWidth: .infinity, alignment: alignment)
                Divider()
                    .padding(.bottom, 4)
                content()
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
    }
}
