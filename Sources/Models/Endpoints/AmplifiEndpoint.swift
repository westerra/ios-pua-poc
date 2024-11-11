//
//  AmplifiEndpoint.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import Backbase
import Foundation

struct AmplifiEndpoint: Endpoint {
    // Note: full URL for Amplifi Rewards is retrieved from the API
    static var domain: String { "" }

    var type: EndpointType = .amplifi
    var path: String

    init(_ endpoint: String = "") {
        self.path = endpoint
    }
}
