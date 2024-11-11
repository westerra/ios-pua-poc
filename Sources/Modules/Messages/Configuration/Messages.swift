//
//  Messages.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import MessagesJourney
import RetailUSApp
import UIKit

extension Messages {

    /// This is the configuration of the Messages module
    static func configure() -> Messages.Configuration {

        // Save indexing for simplifaction
        var messages = Messages.Configuration()

        // Adjust configuration settings
        messages.conversation.useMessageIcon = false

        // Apply values back to passed in object
        return messages
    }
}
