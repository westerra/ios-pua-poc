//
//  InvestmentAccountProvider.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailAccountsAndTransactionsJourney

enum InvestmentAccountProvider {

    /// Get the data to build out the account details page
    /// - Parameter account: The account we're trying to display
    /// - Returns: An array of sections to be added to the page with their containing data
    static func getDetails(for account: InvestmentAccount) -> [AccountDetailsSection] {

        var sections: [AccountDetailsSection] = []

        sections.append(AccountDetailsSection(title: "General", rows: getGeneralDetails(for: account)))
        sections.append(AccountDetailsSection(title: "Other", rows: getOtherDetails(for: account)))

        return sections
    }
}

// MARK: Helper Methods
private extension InvestmentAccountProvider {

    /// Get an account's general details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getGeneralDetails(for account: InvestmentAccount) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Type", account.productKindName)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Name", account.name)

        return detailsRow
    }

    /// Get an account's other details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getOtherDetails(for account: InvestmentAccount) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Opening Date", account.accountOpeningDate?.formattedPreferred)

        return detailsRow
    }
}
