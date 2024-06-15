//
//  HTTPClient.swift
//  
//
//  Created by Marcos Debastiani on 3/22/24.
//

import Foundation

protocol HTTPClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint, model: T.Type) async throws -> T
}

final class HTTPClient: HTTPClientProtocol {
    static let shared = HTTPClient()
    
    private init() {}

    func request<T: Decodable>(endpoint: Endpoint, model: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw ErrorHandler.invalidURL
        }

        var request = URLRequest(url: url)
        for header in endpoint.headers {
            request.addValue(header.value, forHTTPHeaderField: header.rawValue)
        }
        
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeout

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        print(url.absoluteString)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw ErrorHandler.noResponse
        }
        
        switch response.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = DateFormatter.noTime.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                    }
                }
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw ErrorHandler.decode
            }
        case 400:
            throw ErrorHandler.badRequest
        case 401:
            throw ErrorHandler.unauthorized
        case 404:
            throw ErrorHandler.notFound
        case 500:
            throw ErrorHandler.serverError
        default:
            throw ErrorHandler.unexpectedStatusCode
        }
    }
}
