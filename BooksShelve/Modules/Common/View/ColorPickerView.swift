//
//  ColorPickerView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color

    private let colors: [Color] = [.white,
                           .red,
                           .green,
                           .blue,
                           .yellow,
                           .mint]
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Circle().fill()
                        .foregroundColor(color)
                        .padding(2)
                    Circle()
                        .strokeBorder(selectedColor.accessibilityName == color.accessibilityName ? .gray: .clear, lineWidth: 4)
                        .scaleEffect(CGSize(width: 1.2, height: 1.2))
                }.onTapGesture {
                    selectedColor = color
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.white))
}

extension Color {
    var accessibilityName: String {
        get {
            return UIColor(self).accessibilityName
        }
    }
}
