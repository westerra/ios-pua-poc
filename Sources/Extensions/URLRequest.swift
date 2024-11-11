//
//  URLRequest.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

extension URLRequest {

    /// Create URLRequest from URLComponents
    /// - Parameter components: URLComponents to be used in request
    init?(from components: URLComponents) {
        guard let url = components.url else {
            return nil
        }

        self.init(url: url.absoluteURL)
    }

    /// Create URLRequest for specified path
    /// - Parameter endpoint: Endpoint to be used in request
    init?(for endpoint: Endpoint) {
        guard let url = Self.url(for: endpoint) else {
            return nil
        }

        self.init(url: url)
    }

    /// Create URL object from specified string
    /// - Parameter endpoint: Endpoint to be added to domain
    /// - Returns: URL project for specified path
    static func url(for endpoint: Endpoint) -> URL? {
        // All paths in this file have been verified
        guard let url = URL(string: endpoint.path) else {
            return nil
        }

        return url
    }
}
