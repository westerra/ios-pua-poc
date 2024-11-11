//
//  RetailUSAppRouter.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Backbase
import Foundation
import Resolver
import RetailAccountsAndTransactionsJourney
import RetailAppCommon
import RetailCardsManagementJourney
import RetailJourneyCommon
import RetailMoreJourney
import RetailPaymentJourney
import RetailUSApp
import UIKit


extension RetailUSAppRouter {

    /// Configure App Menus and Routing
    static func configure(_ appConfig: RetailUSAppConfiguration) -> RetailUSAppRouter {

        MoveMoneyTab(retailPaymentConfig: appConfig.payment).configure()
        RemoteDepositTab().configure()

        let router = RetailUSAppRouter()

        if let didUpdateState = router.didUpdateState {
            router.didUpdateState = getStateUpdate(didUpdateState)
        }

        return router
    }
}

private extension RetailUSAppRouter {

    static func getStateUpdate(_ defaultDidUpdateState: @escaping ((RetailUSAppState) -> AppWindowUpdater)) -> ((RetailUSAppState) -> AppWindowUpdater) {
        return { state in

            if Resolver.resolve(FeatureFilter.self).features != nil,
                state == .loggedInEnrolled {
                return { window in
                    DispatchQueue.main.async {
                        let stateScreenBuilder = RetailUSAppRouter.screenBuilder(for: self.getBottomNavigationItem)
                        let stateViewController = RetailUSAppRouter.viewController(for: stateScreenBuilder)
                        window.rootViewController = stateViewController

                        Self.createSession(window: window)
                    }
                }
            }
            return defaultDidUpdateState(state)
        }
    }

    static func createSession(window: UIWindow) {

        let sessionHandler = SessionHandler.shared

        // Setup UITapGestureRecognizer to track user interactions
        let tap = UITapGestureRecognizer(target: self, action: nil)
        tap.delegate = sessionHandler
        window.addGestureRecognizer(tap)

        // Setup SessionHandler to manage session token refresh
        do {
            try Backbase.authClient().startSessionObserver(sessionHandler)
        }
        catch {
            print("SessionHandler failed to load with " + error.localizedDescription)
        }
    }
}

// Bottom Menu Creation
private extension RetailUSAppRouter {
    static var getBottomNavigationItem: RetailAppCommon.EntryPoint {
        return .tabbedMenu([
            Accounts.build,
            More.build(identifier: "payment-hub-menu"),
            More.build(identifier: "check-deposit-menu"),
            //  CardsDetails.build,
            More.build
        ])
    }
}
