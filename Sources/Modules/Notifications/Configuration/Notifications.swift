//
//  Notifications.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import NotificationsJourney
import RetailUSApp
import UIKit

extension Notifications {

    /// Documentation: https://backbase.io/developers/documentation/retail-banking-usa/2023.07/notifications/mobile/notifications-journey-ios-reference/
    static func configure(_ notifications: inout Notifications.Configuration) {

        // Adjust configuration settings
        notifications.accountIconInfo = accountIcon
        notifications.accountsGrouping = .accountType
        notifications.accountNumberMasked = true
        notifications.displayedAccounts = displayedAccounts

        notifications.strings.errorTitleString = notificationsErrorTitle
        notifications.strings.errorSubtitleString = notificationsErrorSubtitle

        notifications.notificationSettings.design.accountIconView = accountIconStyle
        notifications.notificationSettings.strings.errorTitleString = noAccountsErrorTitle
        notifications.notificationSettings.strings.errorSubtitleString = noAccountsErrorSubtitle

        notifications.setLowBalanceAmount.strings.description = LocalizedString("notifications.setLowBalanceAmount.description")
        notifications.setLowBalanceAmount.design.descriptionLabel = setLowBalanceAmountDescriptionLabel
        notifications.setLowBalanceAmount.strings.saveButton = LocalizedString("notifications.setLowBalanceAmount.saveButton")

        notifications.notificationSettingsAPI = .actions
        notifications.accountNotificationsSettings.design.accountIconView = accountIconStyle
        notifications.accountNotificationsSettings.strings.balanceSubtitle = LocalizedString("notifications.setLowBalanceAmount.description")
        notifications.accountNotificationsSettings.strings.debitsAndCreditsTitle = LocalizedString("notifications.accountNotificationsSettings.debitsAndCreditsTitle")
        notifications.accountNotificationsSettings.strings.debitsAndCreditsSubtitle = LocalizedString("notifications.accountNotificationsSettings.debitsAndCreditsSubtitle")

        notifications.newTransactionNotificationSettings.strings.navigationTitle = LocalizedString("notifications.accountNotificationsSettings.debitsAndCreditsTitle")

        notifications.lowBalanceNotificationSettings.design.allowNotificationsSwitch = enabledTintColor
        notifications.lowBalanceNotificationSettings.design.channelSwitch = enabledTintColor
        notifications.newTransactionNotificationSettings.design.allowNotificationsSwitch = enabledTintColor
        notifications.newTransactionNotificationSettings.design.channelSwitch = enabledTintColor

        notifications.notificationList.design.markAsReadBarItem = markAsReadBarItemButton
        notifications.notificationList.design.notificationTitleLabel = notificationTitleLabel
        notifications.notificationList.dateStyle = .short

        // Enable notification settings icon
        notifications.validateNotificationSettingsPrivacy = { true }
    }
}


private extension Notifications {

    static var displayedAccounts: [AccountType] {
        return [
            .current,
            .savings,
            .investment,
            .creditCard,
            .debitCard,
            .loan,
            .termDeposit,
            .general
        ]
    }

    static func accountIcon(type: AccountType) -> AccountIconInfo? {
        AccountIconInfo(icon: .imageFor(accountType: type), isFullSized: false)
    }

    static func accountIconStyle(icon: IconView) {
        icon.tintColor = UIColor(light: .white, dark: .dark)
        icon.imageView.layer.cornerRadius = 8.0
    }

    static func notificationsErrorTitle(error: NotificationsError) -> LocalizedString {
        switch error {
        case .loadingFailure:
            return LocalizedString("notifications.loading.failed")
        case .notConnected:
            return LocalizedString("notifications.no.internet")
        default:
            return LocalizedString("notifications.something.went.wrong")
        }
    }

    static func notificationsErrorSubtitle(error: NotificationsError) -> LocalizedString {
        switch error {
        case .loadingFailure:
            return LocalizedString("notifications.something.went.wrong.try.again")
        case .notConnected:
            return LocalizedString("notifications.no.network")
        default:
            return LocalizedString("notifications.working.on.it")
        }
    }

    static func markAsReadBarItemButton(buttonItem: UIBarButtonItem) {
        buttonItem.title = "MARK AS READ"
    }

    static func notificationTitleLabel(notification: NotificationsJourney.Notification) -> (UILabel) -> Void {
        return { label in
            label.numberOfLines = 0
            label.text = notification.title
        }
    }

    static func setLowBalanceAmountDescriptionLabel(label: UILabel) {
        label.font = UIFont.overrideSystemFont(ofSize: 18.0, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .greyDarkest
    }

    static func noAccountsErrorTitle(notification: NotificationsError) -> LocalizedString {
        LocalizedString("notifications.no.accounts")
    }

    static func noAccountsErrorSubtitle(notification: NotificationsError) -> LocalizedString {
        LocalizedString("notifications.contact.us")
    }

    static func enabledTintColor(uiSwitch: UISwitch) {
        uiSwitch.onTintColor = UIColor(light: .primaryGreen, dark: .aquaPrimary)
    }
}
