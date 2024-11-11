//
//  Workspaces.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import BusinessJourneyCommon
import BusinessWorkspacesJourney
import Foundation
import RetailUSApp
import UIKit

extension Workspaces {

    /// This is the configuration of the Authentication module
    static func configure(_ workspaces: inout Workspaces.Configuration) {

        // Save indexing for simplifaction
        var selector = workspaces.selector

        // Adjust configuration settings
        selector.design.background = { background in
            background.backgroundColor = UIColor(light: .aquaPrimary, dark: .dark)
        }

        selector.design.loadingView = { activityIndicator in
            activityIndicator.color = UIColor(light: .dark, dark: .white)
        }

        selector.strings.workspaceSelectorTitle = ""

        // Apply values back to passed in object
        workspaces.selector = selector
    }
}
