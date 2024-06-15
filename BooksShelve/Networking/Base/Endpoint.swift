//
//  Endpoint.swift
//  
//
//  Created by Marcos Debastiani on 3/22/24.
//

import Foundation

enum Headers: String {
    case apiKey = "X-Api-Key"
    case authorization = "Authorization"
    
    var value: String {
        switch self {
        case .apiKey:
            return "Your-Api-Key"
        default: 
            return ""
        }
    }
}

protocol Endpoint {
    var path: String { get }
    var body: Codable? { get }
    var headers: [Headers] { get }
    var method: HTTPMethod { get }
    var timeout: TimeInterval { get }
    var queryParams: [URLQueryItem] { get }
    var url: URL? { get }
}

extension Endpoint {
    var body: Codable? {
        return nil
    }

    var headers: [Headers] {
        return [
            .apiKey
        ]
    }

    var timeout: TimeInterval {
        return 30
    }

    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "www.googleapis.com"
        urlComponents.port = nil
        urlComponents.path = "/books/v1/\(self.path)"
        urlComponents.queryItems = queryParams
        return urlComponents.url
    }
}
