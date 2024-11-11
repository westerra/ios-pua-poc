//
//  CreditCardProvider.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailAccountsAndTransactionsJourney

enum CreditCardProvider {

    /// Get the data to build out the account details page
    /// - Parameter account: The account we're trying to display
    /// - Returns: An array of sections to be added to the page with their containing data
    static func getDetails(for account: CreditCard) -> [AccountDetailsSection] {
        var sections: [AccountDetailsSection] = []

        let balanceSection = AccountDetailsSection(title: "Balance Details", rows: getBalanceDetails(for: account))
        let paymentSection = AccountDetailsSection(title: "Payment Details", rows: getPaymentDetails(for: account))
        let interestSection = AccountDetailsSection(title: "Interest Details", rows: getInterestDetails(for: account))
        let generalSection = AccountDetailsSection(title: "General", rows: getGeneralDetails(for: account))

        if !balanceSection.rows.isEmpty { sections.append(balanceSection) }
        if !paymentSection.rows.isEmpty { sections.append(paymentSection) }
        if !interestSection.rows.isEmpty { sections.append(interestSection) }
        if !generalSection.rows.isEmpty { sections.append(generalSection) }

        return sections
    }
}

// MARK: Helper Methods
private extension CreditCardProvider {

    /// Get an account's status details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getBalanceDetails(for account: CreditCard) -> [AccountDetailsRow] {
        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Statement Closing Date", Date().lastDayOfMonth.formattedPreferred)
        AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Current Balance", account.bookedBalance)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Available Credit", account.remainingCredit)
        AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Credit Limit", account.creditLimit)

        return detailsRow
    }

    /// Get an account's other details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getPaymentDetails(for account: CreditCard) -> [AccountDetailsRow] {
        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Minimum Payment Amount Due", account.minimumPayment)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Next Payment Due Date", account.minimumPaymentDueDate?.formattedPreferred)

        return detailsRow
    }

    /// Get an account's payment and interest details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getInterestDetails(for account: CreditCard) -> [AccountDetailsRow] {
        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Purchase APR", account.accountInterestRate, format: .percentage)

        return detailsRow
    }

    /// Get an account's general details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getGeneralDetails(for account: CreditCard) -> [AccountDetailsRow] {
        var detailsRow: [AccountDetailsRow] = []

        let maskedAccountNumber = account.creditCardAccountNumber?.masked(uptoLast: 4, withCharacter: "*")
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Number", maskedAccountNumber, unmaskingAttributeName: .number)

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Routing Number", "302075319")
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Type", account.productTypeName)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Opening Date", account.accountOpeningDate?.formattedPreferred)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Owners", account.accountHolderNames)

        return detailsRow
    }
}
