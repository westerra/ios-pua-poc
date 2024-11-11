//
//  UINavigationBar.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import UIKit

extension UINavigationBar {
    class func setStyle(for navigationBar: UINavigationBar) {

        navigationBar.prefersLargeTitles = true
        // navigationBar.topItem?.largeTitleDisplayMode = .always
        navigationBar.tintColor = UIColor(light: .dark, dark: .white)
        navigationBar.barTintColor = UIColor(light: .greyLightest, dark: .dark)
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = false

        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()

        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.backgroundColor = UIColor(light: .greyLightest, dark: .dark)

        navigationBar.compactAppearance = navigationBarAppearance

        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(light: .dark, dark: .white)]
        navigationBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(light: .dark, dark: .white)]
        navigationBar.compactAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(light: .dark, dark: .white)]
        navigationBar.compactAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(light: .dark, dark: .white)]
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
