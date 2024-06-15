//
//  View+Extensions.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI

extension View {
    @ViewBuilder func applyIf<ViewOnTrue: View, ViewOnFalse: View>(_ condition: Bool, transformOnTrue: (Self) -> ViewOnTrue, transformOnFalse: (Self) -> ViewOnFalse) ->  some View {
        
        if condition {
            transformOnTrue(self)
        } else {
            transformOnFalse(self)
        }
    }
}
