//
//  RemoteDepositTab.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import Resolver
import RetailJourneyCommon
import RetailMoreJourney
import RetailRemoteDepositCaptureJourney
import RetailRemoteDepositCaptureJourneyUseCase

struct RemoteDepositTab {

    // Configure Remote Deposit Tab
    func configure() {
        var checkDepositMenuConfig = More.Configuration()
        checkDepositMenuConfig.strings.navigationTitle = LocalizedString("remote.deposit.title")
        checkDepositMenuConfig.tabItem = getTabItem()
        checkDepositMenuConfig.menu = getMenuItems()
        Resolver.register(name: "check-deposit-menu") { checkDepositMenuConfig }
    }
}

private extension RemoteDepositTab {
    func getTabItem() -> RetailJourneyCommon.TabItem {
        return RetailJourneyCommon.TabItem(
            title: LocalizedString("remoteCapture.tabItem.title"),
            image: UIImage(systemName: "camera.fill"),
            selectedImage: UIImage(systemName: "camera.fill")
        )
    }

    func getMenuItems() -> More.Menu {
        return More.Menu(
            showIcons: true,
            sections: [
                More.MenuSection(items: [depositCheckMenuItem])
            ]
        )
    }

    var depositCheckMenuItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("remote.deposit.title"),
            subtitle: LocalizedString("remote.deposit.subtitle"),
            icon: UIImage.camera,
            iconBackgroundColor: .clear,
            action: { navigationController in

                DispatchQueue.main.async {
                    let message = "Checks payable to multiple payees cannot be deposited into a single owner’s account."
                    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    let depositAction = UIAlertAction(title: "Continue with deposit", style: .default) { _ in
                        handleDepositAction(on: navigationController)
                    }
                    alert.addAction(depositAction)

                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
                    alert.addAction(cancelAction)

                    if let window = UIApplication.shared.delegate?.window {
                        window?.rootViewController?.present(alert, animated: true)
                    }
                }
            }
        )
    }

    private func handleDepositAction(on navigationController: UINavigationController) {
        let rdcViewController = RemoteDepositCapture.build(
            navigationController: navigationController,
            configuration: RemoteDepositCapture.configure()
        )

        let actionClose = UIAction(
            title: "", handler: { _ in
                self.showConfirmationAlert(with: navigationController, on: rdcViewController)
            }
        )

        rdcViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: actionClose
        )

        navigationController.pushViewController(rdcViewController, animated: true)
    }

    private func showConfirmationAlert(with navigationController: UINavigationController, on viewController: UIViewController) {
        let confirmationAlert = UIAlertController(
            title: "Discard Check Deposit",
            message: "All entered information will be permanently lost.",
            preferredStyle: .alert
        )

        confirmationAlert.addAction(
            UIAlertAction(title: "Discard", style: .destructive) { _ in
                navigationController.popViewController(animated: true)
            }
        )

        confirmationAlert.addAction(
            UIAlertAction( title: "Cancel", style: .cancel)
        )

        viewController.present(confirmationAlert, animated: true)
    }
}
