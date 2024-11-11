//
//  UpcomingPayments.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import Resolver
import RetailAccountsAndTransactionsJourney
import RetailJourneyCommon
import RetailUpcomingPaymentsJourney
import RetailUSApp
import UIKit

extension UpcomingPayments {

    static func configure() -> UpcomingPayments.Configuration {
        Resolver.register { CustomUpcomingPaymentsUseCase() as GetUpcomingPaymentsUseCase }

        // Initialize object
        var upcomingPayments = UpcomingPayments.Configuration()

        // Adjust configuration settings
        upcomingPayments.strings.listNavigationTitle = LocalizedString("scheduled.transfers.title")
        upcomingPayments.strings.emptyStateTitle = LocalizedString("paymentFlow.scheduledPayment.noPayment.title")

        // Hide edit button from the stack view
        upcomingPayments.paymentDetails.design.editButtonColor = { editButton in
            editButton.superview?.superview?.isHidden = true
        }

        let westerraDateFormatting = WCUDateFormatting()
        upcomingPayments.paymentsList.dateFormatter = westerraDateFormatting
        upcomingPayments.paymentDetails.dateFormatter = westerraDateFormatting

        return upcomingPayments
    }
}
