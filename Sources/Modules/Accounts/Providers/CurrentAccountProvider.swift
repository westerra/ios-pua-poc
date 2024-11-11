//
//  CurrentAccountProvider.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailAccountsAndTransactionsJourney

enum CurrentAccountProvider {

    /// Get the data to build out the account details page
    /// - Parameter account: The account we're trying to display
    /// - Returns: An array of sections to be added to the page with their containing data
    static func getDetails(for account: CurrentAccount) -> [AccountDetailsSection] {

        var sections: [AccountDetailsSection] = []

        let balanceSection = AccountDetailsSection(title: "Balance Details", rows: getBalanceDetails(for: account))
        let generalSection = AccountDetailsSection(title: "General", rows: getGeneralDetails(for: account))

        if !balanceSection.rows.isEmpty { sections.append(balanceSection) }
        if !generalSection.rows.isEmpty { sections.append(generalSection) }

        return sections
    }
}

// MARK: Helper Methods
private extension CurrentAccountProvider {

    /// Get an account's balance details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getBalanceDetails(for account: CurrentAccount) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Available Balance", account.availableBalance)
        AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Current Balance", account.bookedBalance)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Interest Rate", account.accountInterestRate, format: .percentage)

        return detailsRow
    }

    /// Get an account's general details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getGeneralDetails(for account: CurrentAccount) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(
            accountRows: &detailsRow,
            "Account Number",
            account.bban?.masked(
                uptoLast: 4,
                withCharacter: "*"
            ),
            unmaskingAttributeName: .bban
        )
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Routing Number", "302075319")
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Type", account.productTypeName)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Opening Date", account.accountOpeningDate?.formattedPreferred)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Owners", account.accountHolderNames)

        return detailsRow
    }
}
