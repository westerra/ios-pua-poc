//
//  ServerEndpoint.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Backbase
import Foundation

struct ServerEndpoint: Endpoint {
    static var domain: String {
        guard let serverUrl = Backbase.configuration().backbase.serverURL else {
            return ""
        }
        return serverUrl
    }

    var type: EndpointType = .server
    var path: String

    private let missingSsoToken = SSOToken(ssourl: "")

    init(_ endpoint: String) {
        self.path = ServerEndpoint.domain + endpoint
    }
}

// MARK: Endpoints
extension ServerEndpoint {
    // App Domain
    static var arrangementManager = ServerEndpoint("/api/arrangement-manager/client-api/v2/productsummary/context/arrangements")
    static var contactList = ServerEndpoint("/api/contact-manager/client-api/v2/contacts")
    static var paymentOrders = ServerEndpoint("/api/payment-order-service/client-api/v2/payment-orders")
    static var ssoAmplifi = ServerEndpoint("/api/sso/client-api/v1/applications?name=amplify&program=cashback")
    static var ssoPayveris = ServerEndpoint("/api/sso/client-api/v1/applications?name=payveris&autoenroll=true")
    static var statementCategories = ServerEndpoint("/api/account-statement/client-api/v2/account/statements/categories")
    static var statementDownload = ServerEndpoint("/api/account-statement/client-api/v2/account/statements/download")
    static var statements = ServerEndpoint("/api/account-statement/client-api/v2/account/statements")

    /* Accounts & Transactions */
    static var accounts = ServerEndpoint("/api/arrangement-manager")
    static var transactions = ServerEndpoint("/api/transaction-manager")

    /// Endpoint to retrieve progress status for payment order
    /// - Parameter orderId: ID for payment order we are requesting progress status for
    /// - Returns: String representation of the payment orders progress status endpoint
    static func paymentOrdersProgressStatus(for orderId: String) -> ServerEndpoint {
        var paymentOrders = paymentOrders

        paymentOrders.path += orderId + "/progress-status"

        return paymentOrders
    }

    /// Endpoint to DMI mortgage SSO token
    /// - Parameter mortgageId: ID for mortgage account
    /// - Returns: String representation of DMI mortgage SSO endpoint
    static func getDmiMortgageEndpoint(with mortgageId: String) -> ServerEndpoint {
        ServerEndpoint("/api/sso/client-api/v1/applications?name=dmi&internalArrangementId=\(mortgageId)")
    }
}

// MARK: SSO Helpers
extension ServerEndpoint {

    /// Retrieve SSO Token from server
    /// - Parameter completion: Handle error or decode token returned from the server
    func getSSOToken(completion: @escaping (SSOToken) -> Void) {
        guard let url = self.url else {
            completion(missingSsoToken)
            return
        }

        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            if let error = error {
                print(
                    """
                    Error: \(error.localizedDescription)
                    URLResponse: \(String(describing: urlResponse))
                    """
                )
                return
            }

            if let data = data, let ssoToken = try? JSONDecoder().decode(SSOToken.self, from: data) {
                completion(ssoToken)
                return
            }

            completion(missingSsoToken)
        }
        .resume()
    }
}
