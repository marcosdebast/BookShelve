//
//  FetchStatus+FetchType.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 02/05/24.
//

import Foundation

enum FetchStatus {
    case success
    case loading
    case error(Error)
}

enum FetchType {
    case all
    case inProgress
    case finished
    case recentlyAdded
    
    var description: String {
        switch self {
        case .all:
            "All"
        case .inProgress:
            "InProgress"
        case .finished:
            "Finished"
        case .recentlyAdded:
            "RecentlyAdded"
        }
    }
    
    static var allCases: [FetchType] {
        return [
            .all,
            .inProgress,
            .finished
        ]
    }
}
