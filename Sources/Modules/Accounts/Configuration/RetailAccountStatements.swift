//
//  RetailAccountStatements.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import Resolver
import RetailAccountStatementsJourney
import RetailDesign
import RetailJourneyCommon
import RetailUSApp
import UIKit

extension RetailAccountStatements {

    static func configure() -> RetailAccountStatements.Configuration {

        Resolver.register { CustomStatementsUseCase() as AccountStatementsServiceUseCase }

        var accountStatements = RetailAccountStatements.Configuration()

        // Hide share button for all devices except iPhones
        if UIDevice.current.userInterfaceIdiom != .phone {
            accountStatements.preview.design.navigationShareBarButtonImage = nil
        }

        // Save indexing for simplifaction
        var list = accountStatements.list
        list.strings.screenTitle = LocalizedString("accountStatements.title")

        // Adjust configuration settings
        list.strings.errorSubtitle = errorSubtitle
        list.strings.errorTitle = errorTitle

        // Apply values back to passed in object
        accountStatements.list = list

        accountStatements.formattedDateProvider = { date in
            date.formattedPreferred
        }

        return accountStatements
    }
}

// MARK: Calculated Properties
private extension RetailAccountStatements {
    static var errorTitle: (AccountStatementsList.Error) -> LocalizedString {
        return { error in
            switch error {
            case .emptyList:
                return "No account statements"

            case .noFilterResults:
                return "No results found."

            default:
                return "Oops, loading failed"
            }
        }
    }

    static var errorSubtitle: (AccountStatementsList.Error) -> LocalizedString {
        return { error in
            switch error {
            case .emptyList:
                return "Sorry, there's nothing here yet.\nPlease check back later."

            case .noFilterResults:
                return "Please select different criteria."

            default:
                return "Something went wrong.\nPlease try again."
            }
        }
    }
}
