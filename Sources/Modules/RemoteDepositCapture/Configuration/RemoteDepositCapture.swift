//
//  RemoteDepositCapture.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import RetailRemoteDepositCaptureJourney
import RetailRemoteDepositCaptureJourneyUseCase
import RetailRemoteDepositImageCaptureAction
import RetailUSApp
import UIKit

extension RemoteDepositCapture {

    /// This is the configuration of the RemoteDepositCapture module
    /// - Parameter config: The App Configuration instance that will be passed back out of this method
    static func configure() -> RemoteDepositCapture.Configuration {

        var remoteDepositCapture = RemoteDepositCapture.Configuration(useCaseProvider: { RetailRemoteDepositCaptureUseCase() })

        remoteDepositCapture.accountList.balanceDisplayOption = { _ in
            return .availableBalance
        }

        remoteDepositCapture.form.balanceDisplayOption = { _ in
            return .availableBalance
        }

        remoteDepositCapture.router.dismissJourney = dismissRDCJourney

        #if targetEnvironment(simulator)
        // Mitek cannot run on simulator so mocked.
        #else
        // override the Form.Router
        remoteDepositCapture.form.router = Form.Router.MiSnapRouter
        #endif

        return remoteDepositCapture
    }

    static var dismissRDCJourney: (UINavigationController, Configuration) -> Void = { _, _ in
        if let tabbarController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController {
            tabbarController.dismiss(animated: true) {
                if let navigationController = tabbarController.selectedViewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: true)
                }
            }
        }
    }
}
