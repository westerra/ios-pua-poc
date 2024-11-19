//
//  More.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import IdentityAuthenticationJourney
import IdentitySelfEnrollmentJourney
import MessagesJourney
import NotificationsJourney
import Resolver
import RetailCardsManagementJourney
import RetailContactsJourney
import RetailDesign
import RetailJourneyCommon
import RetailMoreJourney
import RetailRemoteDepositCaptureJourney
import RetailRemoteDepositCaptureJourneyUseCase
import SwiftUI
import UIKit
import UserProfileJourney

extension More {

    static func configureMenu() -> More.Menu {
        return More.Menu(
            showIcons: true,
            sections: [
                manageSection,
                contactSection,
                securitySection
            ]
        )
    }
}


// MARK: - More Menu Items

private extension More {

    static var manageSection: More.MenuSection {
        var menuSection = More.MenuSection(
            title: RetailJourneyCommon.LocalizedString("more.menu.manage.section.title"),
            items: [
                profileItem,
                notificationsItem,
                contactsItem,
                rewardsItem
            ]
        )

        if Bundle.isDev {
            menuSection.items.append(creditCardItem)
            menuSection.items.append(westerraProductsItem)
        }

        return menuSection
    }

    static var notificationsItem: More.MenuItem {
        return More.MenuItem(
            title: RetailJourneyCommon.LocalizedString("more.contactSection.notifications.title"),
            icon: .manageNotifications,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                let manageNotificationsVC = NotificationSettings.build(navigationController: navigationController)
                navigationController.pushViewController(manageNotificationsVC, animated: true)
            }
        )
    }

    static var creditCardItem: More.MenuItem {
        return More.MenuItem(
            title: RetailJourneyCommon.LocalizedString("more.manageSection.creditcard.title"),
            icon: .card,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                let manageCardsVC = CardsDetails.build(navigationController: navigationController)
                navigationController.pushViewController(manageCardsVC, animated: true)
            }
        )
    }

    static var contactsItem: More.MenuItem {
        return More.MenuItem(
            title: RetailJourneyCommon.LocalizedString("Manage contacts"),
            icon: .contacts,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                let manageContactsViewController = ContactList.build(navigationController: navigationController)
                navigationController.pushViewController(manageContactsViewController, animated: true)
            }
        )
    }

    static var profileItem: More.MenuItem {
        return More.MenuItem(
            title: RetailJourneyCommon.LocalizedString("My profile"),
            icon: .profile,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                let userProfileViewController = UserProfile.build(navigationController: navigationController)
                navigationController.pushViewController(userProfileViewController, animated: true)
            }
        )
    }

    static var rewardsItem: More.MenuItem {
        return More.MenuItem(
            title: RetailJourneyCommon.LocalizedString("Card rewards"),
            icon: .cardRewards,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: SSOView.view(for: AmplifiEndpoint(), with: RetailJourneyCommon.LocalizedString("Card rewards").value)
        )
    }

    static var westerraProductsItem: More.MenuItem {
        return More.MenuItem(
            title: "Explore Westerra Products",
            icon: .wcuLogo,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                DispatchQueue.main.async {
                    let coordinatorViewModel = BehindThePinCoordinatorViewModel(hostViewController: navigationController.topViewController)
                    let viewModel = BehindThePinViewModel(coordinator: coordinatorViewModel, accountService: BTPService())
                    let behindThePinCoordinatorView = BehindThePinCoordinatorView(viewModel: viewModel, coordinatorViewModel: coordinatorViewModel)

                    let behindThePinViewController = UIHostingController(rootView: behindThePinCoordinatorView)
                    behindThePinViewController.hidesBottomBarWhenPushed = true
                    navigationController.navigationBar.prefersLargeTitles = false
                    navigationController.pushViewController(behindThePinViewController, animated: true)
                }
            }
        )
    }
}

// MARK: Contact Section
private extension More {

    static var contactSection: More.MenuSection {
        return More.MenuSection(
            title: RetailJourneyCommon.LocalizedString("more.menu.contact.section.title"),
            items: [
                messagesItem,
                disputeTransactionItem,
                scheduleAppointmentItem
            ]
        )
    }

    static var messagesItem: More.MenuItem {
        return More.MenuItem(
            title: RetailJourneyCommon.LocalizedString("more.contactSection.messages.title"),
            icon: .messages,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                let messagesVC = MessageList.build(navigationController: navigationController)
                navigationController.pushViewController(messagesVC, animated: true)
            }
        )
    }

    static var disputeTransactionItem: More.MenuItem {
        return More.MenuItem(
            title: "Dispute a transaction",
            icon: .backbaseIconGavel,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                guard let cardDisputeFormUrl = URL(string: "https://www.westerracu.com/resources/forms?q=card-dispute-forms") else {
                    return
                }

                let webVC = WCUWebView()
                webVC.title = "Dispute a transaction"
                webVC.urlToLoad = cardDisputeFormUrl
                navigationController.navigationBar.prefersLargeTitles = false
                navigationController.pushViewController(webVC, animated: true)
            }
        )
    }

    static var scheduleAppointmentItem: More.MenuItem {
        return More.MenuItem(
            title: "Schedule an appointment",
            icon: .backbaseIconSchedule,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { _ in
                let scheduleAppointmentLink = "https://www.timetrade.com/app/westerracu/workflows/westerra002/schedule?resourceId=any"
                guard let scheduleAppointmentUrl = URL(string: scheduleAppointmentLink) else { return }

                UIApplication.shared.open(scheduleAppointmentUrl)
            }
        )
    }
}

// MARK: Security Section
private extension More {

    static var securitySection: More.MenuSection {
        More.MenuSection(
            title: RetailJourneyCommon.LocalizedString("more.menu.security.section.title"),
            items: [
                changePasscodeItem,
                changePasswordItem,
                deleteAccountItem,
                logoutItem
            ]
        )
    }

    static var changePasscodeItem: More.MenuItem {
        More.MenuItem(
            title: RetailJourneyCommon.LocalizedString(key: "more.securitySection.ChangePasscode.title"),
            icon: .changePasscode,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { _ in
                let useCase: AuthenticationUseCase = Resolver.resolve()
                useCase.changePasscode { _ in }
            }
        )
    }

    static var changePasswordItem: More.MenuItem {
        More.MenuItem(
            title: "Change password",
            icon: .changePassword,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { parentViewController in
                let navigationController = UINavigationController()
                let changePassword = ChangePassword.build(navigationController: navigationController)
                navigationController.viewControllers = [changePassword]
                parentViewController.present(navigationController, animated: true)
            }
        )
    }

    static var deleteAccountItem: More.MenuItem {
        More.MenuItem(
            title: "Delete account",
            icon: .trash,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { _ in
                let phoneNumber = "303-321-4209"
                let message = "\n\(phoneNumber)\n\nPlease contact a representative to assist with account deletion."
                let alert = UIAlertController(title: "Contact Us", message: message, preferredStyle: .alert)

                let callAction = UIAlertAction(title: "Call", style: .destructive) { _ in
                    guard let phoneUrl = URL(string: "tel://\(phoneNumber)") else { return }
                    UIApplication.shared.open(phoneUrl)
                }
                alert.addAction(callAction)

                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(cancelAction)

                let keyWindow = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.last { $0.isKeyWindow }
                if let rootViewController = keyWindow?.rootViewController {
                    rootViewController.present(alert, animated: true)
                }
            }
        )
    }

    static var logoutItem: More.MenuItem {
        More.MenuItem(
            title: RetailJourneyCommon.LocalizedString(key: "more.securitySection.Logout.title"),
            subtitle: nil,
            icon: .logout,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { _ in
                let useCase: AuthenticationUseCase = Resolver.resolve()
                let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert)
                let logOutAction = UIAlertAction(title: "Log Out", style: .default) { _ in
                    useCase.endSession(callback: { _ in
                        WAFConfig.setWafCookie()
                    })
                }
                let switchAccountAction = UIAlertAction(title: "Switch Account", style: .default) { _ in
                    useCase.logOut(callback: { _ in
                        WAFConfig.setWafCookie()
                        Defaults.activateCardsModalShown = false
                    })
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(logOutAction)
                alert.addAction(switchAccountAction)
                alert.addAction(cancelAction)

                let keyWindow = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.last { $0.isKeyWindow }
                if let rootViewController = keyWindow?.rootViewController {
                    rootViewController.present(alert, animated: true)
                }
            }
        )
    }
}
