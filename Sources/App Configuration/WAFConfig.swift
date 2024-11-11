//
//  WAFConfig.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import AppCenterAnalytics
import Backbase
import Foundation
import WafMobileSdk

final class WAFConfig: NSObject {
    var tokenProvider: WAFTokenProvider?

    private static let sharedInstance: WAFConfig = {
        let instance = WAFConfig()
        return instance
    }()

    override private init() {
        super.init()
        setupConfiguration()
    }

    static func shared() -> WAFConfig {
        return sharedInstance
    }

    static func setWafCookie() {
        let twentyFourHours: Double = 60 * 60 * 24

        guard let wafTokenProvider = WAFConfig.shared().tokenProvider,
            let token = wafTokenProvider.getToken(),
            let cookie = HTTPCookie(properties: [
                .name: "aws-waf-token",
                .value: token.value,
                .domain: ".westerracu.com",
                .path: "/",
                .expires: Date(timeIntervalSinceNow: twentyFourHours),
                .sameSitePolicy: HTTPCookieStringPolicy.sameSiteLax
            ])
        else { return }

        HTTPCookieStorage.shared.setCookie(cookie)
    }

    private func setupConfiguration() {
        let urlString = Backbase.configuration().custom["wafURL"] as? String ?? ""
        guard let url: URL = URL(string: urlString),
            let configuration = WAFConfiguration(applicationIntegrationUrl: url, domainName: "westerracu.com")
        else {
            Analytics.trackEvent("WAF configuration failure", withProperties: ["urlString": urlString], flags: .critical)
            return
        }

        tokenProvider = WAFTokenProvider(configuration)
    }
}
