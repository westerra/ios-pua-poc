//
//  AppDelegate.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import AppCenterAnalytics
import Backbase
import BackbaseDesignSystem
import BusinessWorkspacesJourney
import FirebaseMessaging
import IdentityAuthenticationJourney
import IdentitySelfEnrollmentJourney
import MessagesJourney
import NotificationsJourney
import RetailAccountsAndTransactionsJourney
import RetailAccountStatementsJourney
import RetailAppCommon
import RetailCardsManagementJourney
import RetailContactsJourney
import RetailJourneyCommon
import RetailMoreJourney
import RetailPaymentJourney
import RetailRemoteDepositCaptureJourney
import RetailRemoteDepositImageCaptureAction
import RetailUpcomingPaymentsJourney
import RetailUSApp
import RxSwift
import UIKit
import UserProfileJourney

final class AppDelegate: RetailUSAppDelegate {

    override init() {
        super.init { sdk, design in

            // Use `sdk` as a customization point for Backbase SDK.
            // Use `design` as a customization point for design system.
            sdk.additionalSetup = ApplicationSetup.getSecurityAdditionalSetup()

            design = DesignSystem.configure()

            return { appConfig in

                // FEATURE FLAGS
                RetailUSAppFeatureFlags.configure(&appConfig.featureFlags)

                // MODULE CONFIGURATION
                appConfig.accountStatements = RetailAccountStatements.configure()
                AccountsAndTransactions.configure(&appConfig.accountsAndTransactions)
                appConfig.authentication = Authentication.configure()
                appConfig.cardsManagement = CardsManagement.configure()
                appConfig.messages = Messages.configure()
                appConfig.payment = RetailPayment.configure(appConfig.payment)
                appConfig.remoteDepositCapture = RemoteDepositCapture.configure()
                Splash.configure(&appConfig.splash)
                appConfig.upcomingPayments = UpcomingPayments.configure()
                appConfig.contacts = Contacts.configure()
                ChangePassword.configure(&appConfig.userProfile.changePassword)
                Notifications.configure(&appConfig.notifications)
                Workspaces.configure(&appConfig.workspaces)
                UserProfile.configure(&appConfig.userProfile)
                SelfEnrollment.configure(&appConfig.selfEnrollment)

                // ROUTING AND MENU CONFIGURATION
                appConfig.more.menu = More.configureMenu()
                appConfig.router = RetailUSAppRouter.configure(appConfig)
            }
        }
    }

    /// Sets up analytics and frameworks for the application
    /// - Parameters:
    ///   - application: The application to be handled
    ///   - launchOptions: Options to alter launch state
    /// - Returns: Confirmation that we did or didn't launch successfully
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // swiftlint:disable:previous discouraged_optional_collection
        ApplicationSetup.setupAnalyticsAndFrameworks()
        ApplicationSetup.firebaseRemoteConfig()

        _ = WAFConfig.shared().tokenProvider?.getToken()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationWillEnterForeground(_ application: UIApplication) {
        super.applicationWillEnterForeground(application)

        WAFConfig.shared().tokenProvider?.onTokenReady(wafTokenResultCallback: { _, error in
            if let error = error {
                Analytics.trackEvent("Error refreshing WAF token", withProperties: ["Error": error.localizedDescription], flags: .critical)
            }
        })
    }

    /// - Parameter application: Currently running application, which initiated this delegate method.
    /// - Parameter deviceToken: Token hash generated from the user's device. This is ignored in favor of the hash generated from Firebase instead.
    @objc
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Messaging.messaging().token { token, error in
            if let token = token {
                self.notificationsFramework.pushTokenListener.setDeviceToken(token: token)
            }
            else if let error = error {
                dump(error)
            }
        }
    }

    // Code required to handle rotation when using mitek.
    // Also Project->General->DeploymentInfo->DeviceOrientation enable `landscapeLeft` and `landscapeRight`.
    // This function enables rotation only on the mitek view controllers.
    @objc(application:supportedInterfaceOrientationsForWindow:)
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        guard let rootController = window?.rootViewController else {
            return self.getSupportedOrientation()
        }

        var topMostViewController = rootController.presentedViewController
        while topMostViewController?.presentedViewController != nil {
            topMostViewController = topMostViewController?.presentedViewController
        }

        return (topMostViewController as? RotatableInterface)?.supportedInterface ?? self.getSupportedOrientation()
    }

    private func getSupportedOrientation() -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }

        return .portrait
    }
}

class MyApplication: UIApplication {

    override var preferredContentSizeCategory: UIContentSizeCategory {
        // Always return .large
        // swiftlint:disable:next implicit_getter
        get { return .large }
    }
}
