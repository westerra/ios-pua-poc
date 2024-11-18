//
//  PaymentsConfig.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Backbase
import Foundation
import RetailPaymentJourney

class CustomGetPaymentPartiesServiceUseCase: GetPaymentPartiesServiceUseCase {

    func execute(with parameters: PaymentPartiesPageRequestParameters, completion: @escaping OnResult<[PaymentParty], ServiceError>) {

        if let url = getURL(for: parameters.role) {
            PaymentsClient().getPaymentAccountListings(url: url) { paymentPartyList in
                completion(.success(paymentPartyList))
            }
        }
    }
}

private extension CustomGetPaymentPartiesServiceUseCase {

    func getURL(for role: PaymentPartyRole) -> URL? {

        guard var urlComponents = ServerEndpoint.arrangementManager.urlComponents else { return nil }

        let roleStringParam = (role == .credit ? "creditAccount" : "debitAccount")
        let queryItems = [
            URLQueryItem(name: "resourceName", value: "Payments"),
            URLQueryItem(name: "businessFunction", value: "A2A Transfer"),
            URLQueryItem(name: "privilege", value: "create"),
            URLQueryItem(name: roleStringParam, value: "true"),
            URLQueryItem(name: "size", value: "100"),
            URLQueryItem(name: "maskIndicator", value: "true")
        ]

        urlComponents.queryItems = queryItems

        return urlComponents.url
    }
}
