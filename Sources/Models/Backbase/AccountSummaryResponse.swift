//
//  AccountSummaryResponse.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

struct AccountSummaryResponse: Codable {
    let currentAccounts: BBAccountSummary?
    let savingsAccounts: BBAccountSummary?
    let termDeposits: BBAccountSummary?
    let loans: BBAccountSummary?
    let creditCards: BBAccountSummary?
    let debitCards: BBAccountSummary?
    let investmentAccounts: BBAccountSummary?
}

struct BBAdditions: Codable {
    let minimumPaymentDueDate: String?
    let allowTransferTo: String?
    let accountCode: String?
    let allowToP2P: String?
    let remainingCredit: String?
    let allowToA2A: String?
    let payverisTransferFrom: String?
    let allowFromP2P: String?
    let allowTransferFrom: String?
    let isPrimaryBillpayAccount: String?
    let allowFromA2A: String?
    let payverisTransferTo: String?
    let allowToBILLPAY: String?
    let creditLimit: String?
    let allowFromBILLPAY: String?
}

struct BBState: Codable {
    let externalStateID: String?
    let state: String?

    enum CodingKeys: String, CodingKey {
        case externalStateID = "externalStateId"
        case state
    }
}

struct BBAccountSummary: Codable {
    let name: String?
    let products: [BBAccount]
}

// swiftlint:disable discouraged_optional_boolean
struct BBAccount: Codable, Identifiable, Hashable {
    let additions: BBAdditions?
    let id: String?
    let name: String?
    let displayName: String?
    let crossCurrencyAllowed: Bool
    let productKindName: String?
    let productTypeName: String?
    let bankAlias: String?
    let sourceID: String?
    let visible: Bool?
    let accountOpeningDate: String?
    let lastUpdateDate: String?
    let userPreferences: BBUserPreferences?
    let state: BBState?
//    let interestDetails: {}
    let bookedBalance: String?
    let availableBalance: String?

    // Credit
    let creditLimit: String?
    let number: String?
    let creditCardAccountNumber: String?
    let remainingCredit: Double?
    let outstandingPayment: Double?
    let minimumPayment: Double?
    let minimumPaymentDueDate: String?
    let accountInterestRate: Double?

    // Debit
    let bban: String?
    let currency: String?
    let bankBranchCode: String?
    let accruedInterest: Double?
    let accountHolderNames: String?
    let minimumRequiredBalance: Int?
    let accountHolderAddressLine1, town, postCode: String?
    let creditAccount: Bool?
    let debitAccount: Bool?
    let accountHolderCountry: String?
    let unmaskableAttributes: [String]

    enum CodingKeys: String, CodingKey {
        case additions, id, name, displayName, crossCurrencyAllowed, productKindName, productTypeName, bankAlias
        case sourceID = "sourceId"
        case visible, accountOpeningDate, lastUpdateDate
        case userPreferences
        case state
        case bookedBalance, availableBalance

        // Credit
        case creditLimit, number, creditCardAccountNumber, remainingCredit, outstandingPayment, minimumPayment, minimumPaymentDueDate, accountInterestRate

        // Debit
        case bban = "BBAN"
        case currency, bankBranchCode, accruedInterest
        case accountHolderNames, minimumRequiredBalance
        case accountHolderAddressLine1, town, postCode
        case creditAccount, debitAccount, accountHolderCountry, unmaskableAttributes
    }

    var availableBalanceFormatted: String {
        guard let availableBalance = availableBalance,
            let availableBalanceNumber = availableBalance.numberValueFromDouble else {
            return ""
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: availableBalanceNumber) ?? ""
    }

    static func == (lhs: BBAccount, rhs: BBAccount) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct BBUserPreferences: Codable {
    let alias: String?
    let visible: Bool?
    let favorite: Bool
}
// swiftlint:enable discouraged_optional_boolean
