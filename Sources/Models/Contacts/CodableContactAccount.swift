//
//  CodableContactAccount.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailPaymentJourney

class CodableContactAccount: Codable {
    var accountNumber: String
    var accountIban, name, accountType, iban, phoneNumber, email: String?

    enum CodingKeys: String, CodingKey {
        case accountIban = "iban"
        case name, accountType, accountNumber
        case iban = "IBAN"
        case phoneNumber, email
    }

    var accountIdentifier: Contact.Account.Identifier {
        return Contact.Account.Identifier(
            value: accountNumber,
            type: .phoneNumber
        )
    }
}
