//
//  RetailUSAppFeatureFlags.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailUSApp

extension RetailUSAppFeatureFlags {

    static func configure(_ featureFlags: inout RetailUSAppFeatureFlags) {

        // FEATURE FLAGS
        featureFlags.showChangePasswordMenuItem = true
        featureFlags.useSelfEnrollmentJourney = true
    }
}
