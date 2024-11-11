//
//  NavigationActionKey.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

private struct NavigationActionKey: EnvironmentKey {
    static let defaultValue = 0
}

extension EnvironmentValues {
    var navigationAction: Int {
        get { self[NavigationActionKey.self] }
        set { self[NavigationActionKey.self] = newValue }
    }
}
