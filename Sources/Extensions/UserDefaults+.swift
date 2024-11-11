//
//  UserDefaults.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

class Defaults: NSObject {

    static var activateCardsModalShown: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }
}
