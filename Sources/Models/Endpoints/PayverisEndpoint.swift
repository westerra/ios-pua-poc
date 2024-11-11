//
//  PayverisEndpoint.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Backbase
import Foundation

struct PayverisEndpoint: Endpoint {
    static var domain: String {
        guard let payverisDomain = Backbase.configuration().custom["payverisDomain"] as? String else {
            return ""
        }
        return payverisDomain
    }

    var type: EndpointType = .payveris
    var path: String

    init(_ endpoint: String) {
        self.path = PayverisEndpoint.domain + endpoint
    }
}

extension PayverisEndpoint {
    static var oneTimePayment = PayverisEndpoint("/pp/sso/eu/OneTimePayment")
    static var sendMoney = PayverisEndpoint("/pp/sso/eu/SendMoneyDashboard")
    static var showDashboard = PayverisEndpoint("/pp/sso/eu/ShowDashboard")
    static var viewPaymentHistory = PayverisEndpoint("/pp/sso/eu/ViewPaymentHistory")
}
