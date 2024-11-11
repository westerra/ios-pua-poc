//
//  AccountDetailsUtils.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailAccountsAndTransactionsJourney
import UIKit

enum AccountDetailsUtils {

    /// Creates and appends a new row in Account Details
    /// - Parameters:
    ///   - accountRow: The current array of Account Details rows passed by reference to allow modification
    ///   - title: The title of the new row to be added
    ///   - value: The String value to be output in the new row
    static func retrieveRow(
        accountRows: inout [AccountDetailsRow],
        _ title: String?,
        _ value: String?,
        format: AccountDetailsRow.Format = .plainText,
        unmaskingAttributeName: MaskableAttribute? = nil,
        isCopyAvailable: Bool = false,
        isEditableAccountName: Bool = false,
        externalActionConfigurations: [AccountDetailsRow.ExternalActionConfiguration] = []
    ) {
        var externalActionConfigurations = externalActionConfigurations

        if isEditableAccountName {
            externalActionConfigurations.append(
                AccountDetailsRow.ExternalActionConfiguration(
                    action: editAction,
                    icon: UIImage(systemName: "pencil"),
                    accessibilityLabel: "Edit"
                )
            )
        }

        if let title = title, let value = value, !value.isEmpty {
            accountRows.append(
                AccountDetailsRow(
                    title: title,
                    value: value,
                    format: format,
                    unmaskingAttributeName: unmaskingAttributeName,
                    isCopyAvailable: isCopyAvailable,
                    externalActionConfigurations: externalActionConfigurations
                )
            )
        }
    }

    /// Creates and appends a new row in Account Details
    /// - Parameters:
    ///   - accountRow: The current array of Account Details rows passed by reference to allow modification
    ///   - title: The title of the new row to be added
    ///   - value: The Date value to be output in the new row
    static func retrieveRow(
        accountRows: inout [AccountDetailsRow],
        _ title: String,
        _ value: Date?,
        format: AccountDetailsRow.Format = .plainText,
        unmaskingAttributeName: MaskableAttribute? = nil,
        isCopyAvailable: Bool = false,
        externalActionConfigurations: [AccountDetailsRow.ExternalActionConfiguration] = []
    ) {
        if let value = value {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            accountRows.append(
                AccountDetailsRow(
                    title: title,
                    value: dateFormatter.string(from: value),
                    format: format,
                    unmaskingAttributeName: unmaskingAttributeName,
                    isCopyAvailable: isCopyAvailable,
                    externalActionConfigurations: externalActionConfigurations
                )
            )
        }
    }

    /// Creates and appends a new row in Account Details
    /// - Parameters:
    ///   - accountRow: The current array of Account Details rows passed by reference to allow modification
    ///   - title: The title of the new row to be added
    ///   - value: The Double value to be output in the new row
    static func retrieveRow(
        accountRows: inout [AccountDetailsRow],
        _ title: String,
        _ value: Double?,
        format: AccountDetailsRow.Format = .plainText,
        unmaskingAttributeName: MaskableAttribute? = nil,
        isCopyAvailable: Bool = false,
        externalActionConfigurations: [AccountDetailsRow.ExternalActionConfiguration] = []
    ) {
        if let value = value {
            var formattedValue: String
            switch format {
            case .plainText: formattedValue = Double.formatAmountFromDouble(value)
            default:         formattedValue = String(value)
            }

            accountRows.append(
                AccountDetailsRow(
                    title: title,
                    value: formattedValue,
                    format: format,
                    unmaskingAttributeName: unmaskingAttributeName,
                    isCopyAvailable: isCopyAvailable,
                    externalActionConfigurations: externalActionConfigurations
                )
            )
        }
    }

    /// Creates and appends a new row in Account Details
    /// - Parameters:
    ///   - accountRow: The current array of Account Details rows passed by reference to allow modification
    ///   - title: The title of the new row to be added
    ///   - value: The TimeUnit value to be output in the new row
    static func retrieveRow(
        accountRows: inout [AccountDetailsRow],
        _ title: String,
        _ value: TimeUnit?,
        format: AccountDetailsRow.Format = .plainText,
        unmaskingAttributeName: MaskableAttribute? = nil,
        isCopyAvailable: Bool = false,
        externalActionConfigurations: [AccountDetailsRow.ExternalActionConfiguration] = []
    ) {
        if let value = value {
            accountRows.append(
                AccountDetailsRow(
                    title: title,
                    value: value.rawValue,
                    format: format,
                    unmaskingAttributeName: unmaskingAttributeName,
                    isCopyAvailable: isCopyAvailable,
                    externalActionConfigurations: externalActionConfigurations
                )
            )
        }
    }

    /// Creates and appends a new row in Account Details
    /// - Parameters:
    ///   - accountRow: The current array of Account Details rows passed by reference to allow modification
    ///   - title: The title of the new row to be added
    ///   - value: The unformatted String representation of a Double value to be formatted and output in the new row
    static func retrieveRowFormatStringToDouble(
        accountRows: inout [AccountDetailsRow],
        _ title: String,
        _ unformattedAmount: String?,
        format: AccountDetailsRow.Format = .plainText,
        unmaskingAttributeName: MaskableAttribute? = nil,
        isCopyAvailable: Bool = false,
        externalActionConfigurations: [AccountDetailsRow.ExternalActionConfiguration] = []
    ) {
        if let unformattedAmount = unformattedAmount, !unformattedAmount.isEmpty {
            accountRows.append(
                AccountDetailsRow(
                    title: title,
                    value: Double.formatAmount(unformattedAmount),
                    format: format,
                    unmaskingAttributeName: unmaskingAttributeName,
                    isCopyAvailable: isCopyAvailable,
                    externalActionConfigurations: externalActionConfigurations
                )
            )
        }
    }

    /// Creates and appends a new row in Account Details
    /// - Parameters:
    ///   - accountRow: The current array of Account Details rows passed by reference to allow modification
    ///   - title: The title of the new row to be added
    ///   - value: The unformatted String representation of a Double value to be formatted and output in the new row
    static func retrieveRowFormatStringToDate(accountRows: inout [AccountDetailsRow], _ title: String, _ unformattedDate: String?) {
        if let unformattedDate = unformattedDate,
            let formattedDate = Date.date(from: unformattedDate)?.getDateString(format: "MM/dd/YYYY") {
            accountRows.append(
                AccountDetailsRow(
                    title: title,
                    value: formattedDate
                )
            )
        }
    }
}

// MARK: Actions
extension AccountDetailsUtils {

    static func editAction(_ navigationController: UINavigationController) -> (AccountDetailsRow.ExternalActionConfiguration.ExitParams) -> Void {
        return { exitParams in

            let aliasVC = AccountDetailsFieldEditor.build(
                navigationController: navigationController,
                entryParams: AccountDetailsFieldEditor.EntryParams(
                    prodcut: exitParams.product,
                    completion: exitParams.completion,
                    field: .accountName
                )
            )

            let wrappingNavigationController = UINavigationController(rootViewController: aliasVC)
            navigationController.present(wrappingNavigationController, animated: true, completion: nil)
        }
    }

    static func dmiMortgageViewLoanDetailsAction(_ navigationController: UINavigationController) -> (AccountDetailsRow.ExternalActionConfiguration.ExitParams) -> Void {
        return { exitParams in
            if let mortgageId = exitParams.product.account.identifier {
                DmiMortgageViewModel().initiateDmiMortgageSSO(mortgageId: mortgageId, title: "Loan Details", viewToLoad: .loanDetails, on: navigationController)
            }
        }
    }
}
