//
//  ProfileResponse.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

struct ProfileResponse: Codable {
    let fullName: String?
    let phoneAddresses: [ProfileAddress]
    let electronicAddresses: [ProfileAddress]
    let postalAddresses: [ProfilePostalAddress]
    let additions: ProfileAdditions?

    enum CodingKeys: String, CodingKey {
        case fullName
        case phoneAddresses = "phone-addresses"
        case electronicAddresses = "electronic-addresses"
        case postalAddresses = "postal-addresses"
        case additions
    }
}

struct ProfileAdditions: Codable {
    let customerCode, ssn: String?

    enum CodingKeys: String, CodingKey {
        case customerCode
        case ssn = "SSN"
    }
}

struct ProfileAddress: Codable {
    let key: String?
    let type: String?
    let primary: Bool
    let address: String?
    let number: String?
}

struct ProfilePostalAddress: Codable {
    let key: String?
    let type: String?
    let primary: Bool
    let buildingNumber: String?
    let townName: String?
    let postalCode: String?
    let countrySubDivision: String?
    let country: String?
}
