//
//  Models.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error, LocalizedError {
    case apiError
    case apiErrorWith(String)
    case malformedUrl
    case dataParsing
    case noInternet
    case httpStatus(Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .apiError:
            return "API error"

        case .apiErrorWith(let errorMessage):
            return errorMessage

        case .malformedUrl:
            return "Malformed URL"

        case .dataParsing:
            return "Error parsing data"

        case .noInternet:
            return "No Internet"

        case .httpStatus(let code):
            return "HTTP status code: \(code)"

        case .unknown(let error):
            return "Error: \(error)"
        }
    }
}
