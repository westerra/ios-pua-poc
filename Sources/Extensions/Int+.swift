//
//  Int+.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

extension Int {
    // Convert Int to formatted currency String
    // Example: 9999 becomes 99.99
    var toCurrency: String {
        var currencyString = String(self)
        if currencyString.count < 3 {
            return "0." + currencyString
        }

        let atIndex = currencyString.index(currencyString.endIndex, offsetBy: -2)
        currencyString.insert(".", at: atIndex)
        return currencyString
    }

    var toDouble: Double {
        Double(self.toCurrency) ?? 0.0
    }
}
