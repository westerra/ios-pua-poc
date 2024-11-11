//
//  ApplicationSetup.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import AppCenterAnalytics
import AppCenterCrashes
import FirebaseCore
import FirebaseRemoteConfig
import Foundation
import GoogleMaps
import RetailAppCommon
import SwiftUI

enum ApplicationSetup {

    private enum FirebaseConfig: String {
        case btpProductsQA = "btp_westerra_products_list_qa"
        case interceptAd = "intercept_advertisement"
        case minimumVersion = "minimum_version"
    }

    /// Handling the set up third-party dependency services including:
    ///   - AppCenter - Handles Analytics and Crash Reporting in app and Distribution externally
    static func setupAnalyticsAndFrameworks() {
        AppCenter.start(
            withAppSecret: Bundle.getInfoPlistProperty["AppCenterKey"] as? String,
            services: [
                Analytics.self,
                Crashes.self
            ]
        )

        GMSServices.provideAPIKey("GoogleMapsKey")

        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)

        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }

    /// Handles the set up of various security measures within the app
    /// - Returns: Configuration Setup object to be applied to the sdk setup
    static func getSecurityAdditionalSetup() -> BackbaseConfiguration.Setup? {
        return { backbase in
            #if !DEBUG
            // Deny access to the application when device is compromised
            // Application will crash if device is compromised
            backbase.denyWhenJailbroken()
            backbase.denyWhenReverseEngineered()
            #endif

            // The URLCache may contain sensitive information and it is recommended to disable it.
            URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        }
    }

    static func showInterceptAd() {
        guard WCUStore.shared.isInterceptAdEnabled else {
            return
        }

        guard !Defaults.activateCardsModalShown else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let config = ModalViewConfiguration()
            let viewController = UIHostingController(rootView: ActivateCardsModalView(config: config))
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            config.hostingController = viewController

            if let window = UIApplication.shared.delegate?.window {
                window?.rootViewController?.present(viewController, animated: true)
                Defaults.activateCardsModalShown = true
            }
        }
    }

    static func firebaseRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        remoteConfig.fetch { status, _ in
            if status == .success {
                remoteConfig.activate { _, _ in
                    setUpFirebaseConfig(remoteConfig)
                    checkForAppUpdate(remoteConfig)
                }
            }
        }
    }

    private static func setUpFirebaseConfig(_ remoteConfig: RemoteConfig) {
        let btpProductsConfig = remoteConfig.configValue(forKey: FirebaseConfig.btpProductsQA.rawValue)
        if let btpProducts = try? JSONDecoder().decode([WCUProduct].self, from: btpProductsConfig.dataValue) {
            WCUStore.shared.westerraProducts = btpProducts
        }

        let interceptAdPayload = remoteConfig.configValue(forKey: FirebaseConfig.interceptAd.rawValue)
        if let interceptAdValues = interceptAdPayload.jsonValue as? [String: AnyObject],
            let interceptAdEnabled = interceptAdValues["is_enabled"] as? Bool {
            WCUStore.shared.isInterceptAdEnabled = interceptAdEnabled
        }
    }

    private static func checkForAppUpdate(_ remoteConfig: RemoteConfig) {
        let minimumVersionPayload = remoteConfig.configValue(forKey: FirebaseConfig.minimumVersion.rawValue)
        guard
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let minimumVersionValues = minimumVersionPayload.jsonValue as? [String: AnyObject],
            let minimumVersion = minimumVersionValues["minimum_version_ios"] as? String,
            let alertTitle = minimumVersionValues["minimum_version_title"] as? String,
            let alertMessage = minimumVersionValues["minimum_version_message"] as? String
        else { return }

        if minimumVersion.compare(appVersion, options: .numeric) == .orderedDescending {
            forceUserToUpdateApp(with: alertTitle, and: alertMessage)
        }
    }

    private static func forceUserToUpdateApp(with title: String, and message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let updateAction = UIAlertAction(title: "Update Now", style: .default) { _ in
                guard let appStoreUrl = URL(string: "https://apps.apple.com/us/app/westerra-cu/id1627076819") else {
                    return
                }

                UIApplication.shared.open(appStoreUrl, options: [:])
            }
            alert.addAction(updateAction)

            if let window = UIApplication.shared.delegate?.window {
                window?.rootViewController?.present(alert, animated: true)
            }
        }
    }
}
