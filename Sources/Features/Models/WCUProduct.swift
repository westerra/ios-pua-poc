//
//  WCUProduct.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

struct WCUProduct: Identifiable, Codable {
    var id: Int
    var type: String
    var category: String
    var productUrl: String
    var externalUrl: String
    var maxAllowedAccounts: Int
    var minimumBalance: Double

    var userHasProductAlready = false
    var maxAllowedAccountsExceeded = false

    var isEligible: Bool {
        userHasProductAlready == false && maxAllowedAccountsExceeded == false
    }

    enum CodingKeys: String, CodingKey {
        case id = "typeId"
        case type
        case category
        case productUrl = "productMarketingUrl"
        case externalUrl = "externalMarketingUrl"
        case maxAllowedAccounts
        case minimumBalance = "minimumBalanceRequired"
    }

    var formattedMinimumBalance: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current

        guard let priceString = currencyFormatter.string(from: NSNumber(value: minimumBalance)) else {
            return "$0.00"
        }

        return priceString
    }
}

extension WCUProduct: CustomStringConvertible {
    var description: String {
        "id: \(id), type: \(type), category: \(category), maxAllowedAccounts: \(maxAllowedAccounts), minimumBalance: \(minimumBalance)"
    }
}
