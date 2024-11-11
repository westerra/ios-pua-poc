//
//  LoanAccountProvider.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailAccountsAndTransactionsJourney
import UIKit

enum LoanAccountProvider {

    /// Get the data to build out the account details page
    /// - Parameter account: The account we're trying to display
    /// - Returns: An array of sections to be added to the page with their containing data
    static func getDetails(for account: Loan) -> [AccountDetailsSection] {

        var sections: [AccountDetailsSection] = []

        let balanceSection = AccountDetailsSection(title: "Balance Details", rows: getBalanceDetails(for: account))
        let paymentSection = AccountDetailsSection(title: "Payment Details", rows: getPaymentDetails(for: account))
        let interestSection = AccountDetailsSection(title: "Loan Details", rows: getLoanDetails(for: account))
        let generalSection = AccountDetailsSection(title: "General", rows: getGeneralDetails(for: account))

        if !balanceSection.rows.isEmpty { sections.append(balanceSection) }
        if !paymentSection.rows.isEmpty { sections.append(paymentSection) }
        if !interestSection.rows.isEmpty { sections.append(interestSection) }
        if !generalSection.rows.isEmpty { sections.append(generalSection) }

        if isMortgageLoan(account.productTypeName) {
            let makePaymentSection = AccountDetailsSection(title: "Other", rows: getMakePaymentDetails(for: account))
            if !makePaymentSection.rows.isEmpty { sections.append(makePaymentSection) }
        }

        return sections
    }
}

extension LoanAccountProvider {

    static func isLineOfCreditOrOverdraftProductType(_ productTypeName: String?) -> Bool {
        if let productTypeName = productTypeName?.lowercased(),
            productTypeName.contains("loc") || productTypeName.contains("line of credit") || productTypeName.contains("overdraft") {
            return true
        }

        return false
    }

    static func isAutoLoan(_ productTypeName: String?) -> Bool {
        if let productTypeName = productTypeName?.lowercased(), productTypeName.contains("auto") {
            return true
        }

        return false
    }

    static func isMortgageLoan(_ productTypeName: String?) -> Bool {
        !isLineOfCreditOrOverdraftProductType(productTypeName) && !isAutoLoan(productTypeName)
    }
}

// MARK: - Private Helpers

private extension LoanAccountProvider {

    /// Get an account's status details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getBalanceDetails(for account: Loan) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        if isLineOfCreditOrOverdraftProductType(account.productTypeName) {
            AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Current Balance", account.bookedBalance)
            AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Available Credit", account.additions?["remainingCredit"])
        }
        else {
            AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Remaining Balance", account.bookedBalance)
        }

        return detailsRow
    }

    /// Get an account's other details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getPaymentDetails(for account: Loan) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        var formattedNextPaymentDueDate = ""
        if let nextPaymentDueDateString = account.additions?["minimumPaymentDueDate"] {
            formattedNextPaymentDueDate = Date.date(from: nextPaymentDueDateString)?.formattedPreferred ?? ""
        }

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Next Payment Amount Due", account.monthlyInstalmentAmount)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Next Payment Due Date", formattedNextPaymentDueDate)

        return detailsRow
    }

    /// Get an account's payment and interest details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getLoanDetails(for account: Loan) -> [AccountDetailsRow] {

        var detailsRow: [AccountDetailsRow] = []

        if  isLineOfCreditOrOverdraftProductType(account.productTypeName) {
            AccountDetailsUtils.retrieveRowFormatStringToDouble(accountRows: &detailsRow, "Credit Limit", account.additions?["creditLimit"])
        }
        else {
            AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Original Loan Amount", account.principalAmount)

            if let termNumber = account.termNumber, let termUnit = account.termUnit?.pluralStringValue() {
                AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Term", "\(termNumber) \(termUnit)")
            }
        }

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Interest Rate", account.accountInterestRate, format: .percentage)

        return detailsRow
    }

    /// Get an account's general details
    /// - Parameter account: The account used to pull the details
    /// - Returns: Array of the requested account details
    static func getGeneralDetails(for account: Loan) -> [AccountDetailsRow] {
        var detailsRow: [AccountDetailsRow] = []

        let maskedAccountNumber = account.bban?.masked(uptoLast: 4, withCharacter: "*")
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Number", maskedAccountNumber, unmaskingAttributeName: .bban)

        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Routing Number", "302075319")
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Type", account.productTypeName)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Opening Date", account.accountOpeningDate?.formattedPreferred)
        AccountDetailsUtils.retrieveRow(accountRows: &detailsRow, "Account Owners", account.accountHolderNames)

        return detailsRow
    }

    static func getMakePaymentDetails(for account: Loan) -> [AccountDetailsRow] {
        var detailsRow: [AccountDetailsRow] = []

        var externalActionConfigurations: [AccountDetailsRow.ExternalActionConfiguration] = []
        externalActionConfigurations.append(
            AccountDetailsRow.ExternalActionConfiguration(
                action: AccountDetailsUtils.dmiMortgageViewLoanDetailsAction,
                icon: UIImage(systemName: "info.circle"),
                accessibilityLabel: "View loan details"
            )
        )

        detailsRow.append(
            AccountDetailsRow(
                title: "More Details",
                value: "Click the button for more information about this loan.",
                format: .plainText,
                unmaskingAttributeName: .number,
                isCopyAvailable: false,
                externalActionConfigurations: externalActionConfigurations
            )
        )

        return detailsRow
    }
}
