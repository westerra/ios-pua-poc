//
//  TermDepositAccountProvider.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailAccountsAndTransactionsJourney

enum TermDepositAccountProvider {

    /// Get the data to build out the account details page
    /// - Parameter account: The account we're trying to display
    /// - Returns: An array of sections to be added to the page with their containing data
    static func getDetails(for account: TermDeposit) -> [AccountDetailsSection] {

        var sections: [AccountDetailsSection] = []

        let generalSection = AccountDetailsSection(title: "General", rows: getGeneralDetails(for: account))
        let interestSection = AccountDetailsSection(title: "Payment & Interest Details", rows: getPaymentInterestDetails(for: account))
        let maturitySection = AccountDetailsSection(title: "Maturity Details", rows: getMaturityDateDetails(for: account))
        let otherSection = AccountDetailsSection(title: "Other", rows: getOtherDetails(for: account))

        if !generalSection.rows.isEmpty { sections.append(generalSection) }
        if !interestSection.rows.isEmpty { sections.append(interestSection) }
        if !maturitySection.rows.isEmpty { sections.append(maturitySection) }
        if !otherSection.rows.isEmpty { sections.append(otherSection) }

        return sections
    }
}

// MARK: Helper Methods
private extension TermDepositAccountProvider {

    /// Get an account's general details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getGeneralDetails(for account: TermDeposit) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Type", account.productTypeName)
        AccountDetailsUtils.retrieveRow(
            accountRows: &detailsRow,
            "Account Number",
            account.bban?.masked(
                uptoLast: 4,
                withCharacter: "*"
            ),
            unmaskingAttributeName: .bban
        )

        return detailsRow
    }

    /// Get an account's payment and interest details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getPaymentInterestDetails(for account: TermDeposit) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Interest Rate", account.accountInterestRate, format: .percentage)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Accrued Interest", account.accruedInterest)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Interest Payment Frequency", account.interestPaymentFrequencyUnit)

        return detailsRow
    }

    /// Get an account's maturity details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getMaturityDateDetails(for account: TermDeposit) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Term", account.termUnit)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Maturity Date", account.maturityDate)

        return detailsRow
    }

    /// Get an account's other details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getOtherDetails(for account: TermDeposit) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Opening Date", account.accountOpeningDate?.formattedPreferred)

        return detailsRow
    }
}
