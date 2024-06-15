//
//  ActionItemView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import SwiftUI

struct ActionItemView: View {
    let text: String
    let image: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 25))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        Text(text.localized)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                Spacer()
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.medium)
                    .frame(height: 18)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}
