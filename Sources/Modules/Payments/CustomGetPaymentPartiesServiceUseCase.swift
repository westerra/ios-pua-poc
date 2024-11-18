//
//  PaymentsConfig.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Backbase
import Foundation
import RetailPaymentJourney

class CustomGetPaymentPartiesServiceUseCase: GetPaymentPartiesServiceUseCase {
    
    public func execute(parameters: PaymentPartiesPageRequestParameters, completion: @escaping RetrievePaymentPatiesPageCompletion) {
        if let url = getURL(for: parameters.role) {
            PaymentsClient().getPaymentAccountListings(url: url) { paymentPartyList in
                // There was no pagination in the original implementation. Hence keep it as is by setting nextPageCursor to nil
                completion(.success(PaymentPartiesPage(paymentParties: paymentPartyList, nextPageCursor: nil)))
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
