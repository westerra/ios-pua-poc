//
//  UserProfile.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import Foundation
import RetailUSApp
import UserProfileJourney

extension UserProfile {

    static func configure(_ userProfile: inout UserProfile.Configuration) {

        // Labels
        userProfile.personalInformation.strings.emailSubheadingWhenPrimary = "%@"
        userProfile.personalInformation.strings.phoneNumberSubheadingWhenPrimary = "%@"
        userProfile.personalInformation.strings.postalAddressSubheadingWhenPrimary = "%@"

        // Email Address
        userProfile.personalInformation.emailAddressCountLimit = 1
        userProfile.personalInformation.emailAddress.design.primaryLabel = { label in
            label.isHidden = true
        }

        userProfile.personalInformation.emailAddress.design.primarySwitch = { switchButton in
            switchButton.isHidden = true
        }

        userProfile.personalInformation.isEmailAddressEditEnabled = false
        userProfile.personalInformation.emailAddress.isTypeEditable = false

        // Phone number
        userProfile.personalInformation.phoneNumber.design.primaryLabel = { label in
            label.isHidden = true
        }

        userProfile.personalInformation.phoneNumber.design.primarySwitch = { switchButton in
            switchButton.isHidden = true
        }

        userProfile.personalInformation.phoneNumber.design.typeLabel = { label in
            // Using async after to override backbase styles
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                label.isHidden = true
            }
        }

        userProfile.personalInformation.phoneNumber.design.typeField = { textField in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                textField.isHidden = true
            }
        }

        userProfile.personalInformation.phoneTypeMapping = [
            "Mobile": "Mobile",
            "Home": "Home",
            "Work": "Work"
        ]

        // Address
        userProfile.personalInformation.postalAddress.addStrings.title = "Add Address"
        userProfile.personalInformation.postalAddress.addStrings.buildingNumberLabel = "Address line 1"
        userProfile.personalInformation.postalAddress.addStrings.streetLabel = "Address line 2"
        userProfile.personalInformation.postalAddress.addStrings.cityLabel = "City"
        userProfile.personalInformation.postalAddress.addStrings.postcodeLabel = "ZIP code"
        userProfile.personalInformation.postalAddress.addStrings.confirm = "Add address"

        userProfile.personalInformation.postalAddress.editStrings.title = "Change Address"
        userProfile.personalInformation.postalAddress.editStrings.buildingNumberLabel = "Address line 1"
        userProfile.personalInformation.postalAddress.editStrings.streetLabel = "Address line 2"
        userProfile.personalInformation.postalAddress.editStrings.cityLabel = "City"
        userProfile.personalInformation.postalAddress.editStrings.postcodeLabel = "ZIP code"
        userProfile.personalInformation.postalAddress.editStrings.confirm = "Update address"

        userProfile.personalInformation.postalAddressCountLimit = 2

        userProfile.personalInformation.postalAddress.visibleFields = [
            .buildingNumber,
            .street,
            .city,
            .subDivision,
            .postcode,
            .type
        ]

        userProfile.personalInformation.postalAddress.requiredFields = [
            .buildingNumber,
            .city,
            .subDivision,
            .postcode,
            .type
        ]

        userProfile.personalInformation.addressTypeMapping = [
            "RESIDENTIAL": "Home",
            "POBOX": "Mailing"
        ]
    }
}
