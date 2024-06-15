//
//  Impact.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 22/04/24.
//

import UIKit

class Impact {
    static func generateImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.impactOccurred()
    }
}
