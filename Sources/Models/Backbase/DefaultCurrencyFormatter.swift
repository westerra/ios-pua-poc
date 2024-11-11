//
//  DefaultCurrencyFormatter.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import Foundation

import BackbaseDesignSystem
import RetailPaymentJourney

struct DefaultCurrencyFormatter: CurrencyFormatter {
    private let locale: Locale

    init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    /// Number formatting configurations and APIs, by default it uses ``DesignSystem.Formatting.Options()``
    var options: DesignSystem.Formatting.Options {
        var options = DesignSystem.Formatting.Options()
        options.locale = self.locale
        options.formattingStyle = .currency
        return options
    }

    private func format(amount: Decimal, options: DesignSystem.Formatting.Options) -> String? {
        return DesignSystem.shared.formatting.amountFormatter.format(amount: amount, options: options)
    }

    /// Formats the given number as a currency strings and uses the ``options`` to config the formatter
    /// - Parameters:
    ///   - amount: The numerical amount to be formatted
    /// - Returns: The formatted text
    func format(amount: Decimal) -> String? {
        self.format(amount: amount, options: self.options)
    }

    /// Formats the given amount but uses a custom currency code,
    /// it calculates the maxFractionDigits and minFractionDigits
    /// based on the provided currency code
    ///
    ///
    ///     let currencyFormatter = DefaultCurrencyFormatter()
    ///     currencyFormatter.format(1477.00) //"$ 1,205"
    ///     currencyFormatter.format(1477.00, "AED") //"AED 1,205"
    /// - Parameters:
    ///   - amount: The numerical amount to be formatted as a currency
    ///   - currencyCode: A three-letter string for displaying a custom currency code (eg. `ABC 1,205` instead of `USD 1,205`).
    /// - Returns: The formatted text
    func format(amount: Decimal, currencyCode: String) -> String? {
        let numberOfDecimals = NumberFormatter.decimalPlaces(forCurrencyCode: currencyCode)
        var options = DesignSystem.Formatting.Options()
        options.locale = self.locale
        options.minFractionDigits = numberOfDecimals
        options.maxFractionDigits = numberOfDecimals
        options.customCode = currencyCode

        let cleanedAmount = amountToCleanedString(value: amount, currencyCode: currencyCode)
        let amountInDecimal = Decimal(string: cleanedAmount) ?? amount

        return self.format(amount: amountInDecimal, options: options)
    }

    private func amountToCleanedString(value: Decimal, currencyCode: String) -> String {
        let newLocale = "en_US@currency=\(currencyCode)"
        let currencyISONumberFormatter = NumberFormatter()
        currencyISONumberFormatter.numberStyle = .decimal
        currencyISONumberFormatter.locale = Locale(identifier: newLocale)
        currencyISONumberFormatter.usesGroupingSeparator = false

        // swiftlint:disable:next legacy_objc_type
        return currencyISONumberFormatter.string(from: value as NSNumber) ?? "\(value)"
    }

    private func groupingSeparator() -> String {
        Locale.autoupdatingCurrent.groupingSeparator ?? " "
    }

    func cleanAmount(_ amount: String?) -> String? {
        return amount?.replacingOccurrences(of: groupingSeparator(), with: "")
    }
}

extension NumberFormatter {
    private static var currencyISONumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currencyISOCode
        return numberFormatter
    }()
    // Used to determine how many digits are after the decimal point
    static func decimalPlaces(forCurrencyCode currencyCode: String) -> Int {
        let newLocale = "\(Locale.current.identifier)@currency=\(currencyCode)"
        NumberFormatter.currencyISONumberFormatter.locale = Locale(identifier: newLocale)
        return NumberFormatter.currencyISONumberFormatter.minimumFractionDigits
    }
}
