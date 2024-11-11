//
//  Bundle.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

extension Bundle {

    /// Retrieves Info.plist properties
    /// - Parameter forKey: Key for property
    /// - Returns: Optional string value of the property
    static let getInfoPlistProperty: [String: Any] = {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist file not found")
        }
        return infoDictionary
    }()

    static var isProd: Bool {
        Bundle.main.bundleIdentifier == "com.westerracu.bbmobile"
    }

    static var isDev: Bool {
        Bundle.main.bundleIdentifier == "com.westerracu.mobile.dev"
    }

    static var isUat: Bool {
        Bundle.main.bundleIdentifier == "com.westerracu.mobile.uat"
    }
}
