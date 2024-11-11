//
//  CreateAccountResponse.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

enum AccountCreationStatus: String {
    case processed = "PROCESSED"
    case rejected = "REJECTED"
}

struct AccountCreationResponse: Codable {
    let id: String
    let status: String
    let bankStatus: String
    let reasonCode: String?
    let reasonText: String?
    let errorDescription: String?
    let exportAllowed: Bool
}
