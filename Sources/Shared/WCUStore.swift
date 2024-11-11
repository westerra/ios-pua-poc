//
//  WCUStore.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import ArrangementsClient2

class WCUStore {
    static let shared = WCUStore()

    var westerraProducts: [WCUProduct] = []

    var productSummaryItems: [ArrangementsClient2.ProductSummaryItem] = []
    var isInterceptAdEnabled = false

    private init() {}
}

extension WCUStore {
    var hiddenAccountIds: Set<String> {
        var result = Set<String>()
        productSummaryItems.forEach { account in
            if let accountVisible = account.userPreferences?.visible, !accountVisible {
                result.insert(account.id)
            }
        }
        return result
    }
}
