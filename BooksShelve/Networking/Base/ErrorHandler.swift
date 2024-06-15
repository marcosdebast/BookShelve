//
//  ErrorHandler.swift
//  
//
//  Created by Marcos Debastiani on 3/22/24.
//

import Foundation

enum ErrorHandler: Error {
    case decode
    case invalidURL
    case invalidData
    case noResponse
    case unauthorized
    case notFound
    case unexpectedStatusCode
    case badRequest
    case serverError
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "There is an issue with decoding the data. Please try again later."
        case .invalidURL:
            return "The URL you are attempting to access is invalid. Please check the URL and try again."
        case .invalidData:
            return "An invalid response was received from the server."
        case .noResponse:
            return "There is no response from the server. Please check your internet connection and try again."
        case .badRequest:
            return "The server encountered a bad request. Please ensure that you have provided correct information."
        case .unauthorized:
            return "You are not authorized to access this resource. Please verify your credentials and try again."
        case .notFound:
            return "The requested resource could not be found (404). Please check the URL and try again."
        case .serverError:
            return "There is an internal server error (500). Please try again later."
        case .unexpectedStatusCode:
            return "An unexpected status code was received from the server. Please contact support for assistance."
        default:
            return "An unknown error occurred."
        }
    }
}
