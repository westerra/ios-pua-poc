//
//  UIApplication+.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import UIKit

extension UIApplication {

    var firstKeyWindow: UIWindow? {
        // swiftlint:disable:next first_where
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.windows
            .first(where: \.isKeyWindow)
    }
}
