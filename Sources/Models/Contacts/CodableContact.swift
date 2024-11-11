//
//  CodableContact.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailPaymentJourney

class CodableContact: Codable {
    var id: String
    var accounts: [CodableContactAccount]
    var accessContextScope, name, phoneNumber, emailID: String?
    var activeStatus: String

    enum CodingKeys: String, CodingKey {
        case id, accounts, accessContextScope, name, phoneNumber
        case emailID = "emailId"
        case activeStatus
    }
}

extension RetailPaymentJourney.Contact {

    init(from contact: CodableContact) {
        self.init(
            id: contact.id,
            name: contact.name ?? "No Name",
            account: Contact.Account(
                identifiers: contact.accounts.compactMap { $0.accountIdentifier }
            )
        )
    }
}
