//
//  ActionButton.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 18/04/24.
//

import SwiftUI

struct ActionButton: View {
    var textColor: Color = .black
    var fillColor: Color = .accentColor

    let action: () -> Void
    let label: String
    
        
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(label.localized)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            .frame(height: 40)
            .background(
                RoundedRectangle(
                    cornerRadius: 40/2,
                    style: .continuous
                )
                .fill(fillColor)
            )
            .padding(.bottom)
        }
    }
}
