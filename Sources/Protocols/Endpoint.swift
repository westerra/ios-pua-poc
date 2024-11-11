//
//  Endpoint.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

protocol Endpoint {
    static var domain: String { get }

    var type: EndpointType { get }
    var path: String { get set }

    init(_ endpoint: String)
}

extension Endpoint {
    var request: URLRequest? {
        guard let urlRequest = URLRequest(for: self) else {
            return nil
        }

        return urlRequest
    }

    var url: URL? {
        guard let url = URLRequest.url(for: self) else {
            return nil
        }

        return url
    }

    var urlComponents: URLComponents? {
        URLComponents(string: self.path)
    }

    /// Returns page address with authentication token
    /// - Parameters:
    ///   - endpoint: Page address
    ///   - token: Authentication token
    /// - Returns: Full endpoint for navigation
    func authenticate(with token: String) -> Endpoint {
        var endpoint = self
        endpoint.path += token
        return endpoint
    }
}
