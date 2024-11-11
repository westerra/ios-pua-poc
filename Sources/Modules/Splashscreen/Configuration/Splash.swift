//
//  Splash.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import RetailAppCommon
import RetailUSApp
import UIKit

extension Splash {

    /// This is the configuration of the Splashcreen module
    /// - Parameter config: The App Configuration instance that will be passed back out of this method
    static func configure(_ splash: inout Splash.Configuration) {

        // Adjust configuration settings
        splash.backgroundImage = nil
        splash.logoImage = .stackedLogoWhite

        splash.strings.title = ""
        splash.strings.subtitle = ""

        splash.design.indicator = indicatorStyle
        splash.design.logo = logoStyle
    }
}

// MARK: Calculated Properties
private extension Splash {

    static var indicatorStyle: Style<UIActivityIndicatorView> {
        return { indicator in
            indicator.style = .medium
            indicator.color = .white
        }
    }

    static var logoStyle: Style<UIImageView> {
        return { imageView in

            guard
                let parentView = imageView.superview
            else {
                return
            }

            imageView.contentMode = .scaleAspectFit
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 340),
                imageView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
            ])


            // Handle background color while we have the parentView
            parentView.backgroundColor = UIColor(light: .dark, dark: .dark)
        }
    }
}
