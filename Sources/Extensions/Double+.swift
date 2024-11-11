//
//  Double.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

extension Double {

    /// Checks if passed in string is capable of being converted to a Double format and if so returns a value formatted to a USD Currency standard
    /// - Parameter amountUnformatted: String value to be assesed and formatted
    /// - Returns: The formatted string or an invalid format string
    static func formatAmount(_ amountUnformatted: String) -> String {
        guard let amount = Double(amountUnformatted) else { return "Invalid Format" }

        return formatAmountFromDouble(amount)
    }

    /// Formats a Double into a USD Currency standard
    /// - Parameter amountUnformatted: Doube value to be formatted
    /// - Returns: The formatted string or an invalid format string
    static func formatAmountFromDouble(_ amountUnformatted: Double) -> String {
        if let usaCurrency = amountUnformatted.usaCurrency {
            return "$\(usaCurrency)"
        }

        return "Formatting Failed"
    }

    /// Format set up for USD Currency standard  and convience property to allow for simple conversion of Double values
    private var usaCurrency: String? {
        let usdNumberFormatter = NumberFormatter()

        usdNumberFormatter.numberStyle = .decimal
        usdNumberFormatter.minimumFractionDigits = 2
        usdNumberFormatter.maximumFractionDigits = 2
        usdNumberFormatter.generatesDecimalNumbers = true

        // Disable needed as there is no bridging type for NSNumber to Swift https://github.com/realm/SwiftLint/issues/3723
        // swiftlint:disable:next legacy_objc_type
        if let usdString = usdNumberFormatter.string(from: self as NSNumber) {
            return usdString
        }

        return nil
    }

    func toDecimal() -> Decimal {
        return Decimal(string: String(format: "%.2f", self)) ?? Decimal(0.0)
    }

    var currencyFormatted: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current

        guard let formattedCurency = currencyFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }

        return formattedCurency
    }
}
