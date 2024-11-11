//
//  Authentication.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import IdentityAuthenticationJourney
import RetailAppCommon
import RetailUSApp
import UIKit

extension Authentication {

    /// This is the configuration of the Authentication module
    static func configure() -> Authentication.Configuration {

        // Initialize the object
        var authentication = Authentication.Configuration()

        // Save indexing for simplifaction
        let design = authentication.design
        var login = authentication.login

        // Adjust configuration settings
        design.colors.foundation.default = UIColor(light: .aquaPrimary, dark: .dark)
        design.colors.foundation.onFoundation.default = UIColor(light: .dark, dark: .white)
        design.styles.button = authenticationButtonStyling
        design.styles.loading = activityIndicatorStyling

        login.design.image = headerImageStyling
        login.design.imageConstraints = Authentication.Design.ImageConstraints(topSpace: 140, height: 180, sideMargin: 80)
        login.design.biometricButton = biometricButtonStyling
        login.strings.subtitle = loginSubtitleText

        authentication.passcode.loginImage = .stackedLogo
        authentication.passcode.design.image = headerImageStyling
        authentication.passcode.showDismissButton = false

        authentication.inputRequired.design.input = inputRequiredInputFieldDesign
        authentication.setupComplete.image = .accountSuccess

        // Apply values back to passed in object
        authentication.login = login
        authentication.design = design

        authentication.forgotCredentials.showOptions = [.forgotUsername]

        authentication.register.router.didTapForgotCredentials = { _ in
            // Always set WAF cookie on login screen
            WAFConfig.setWafCookie()
            return { }
        }

        return authentication
    }
}

// MARK: Calculated Properties
private extension Authentication {

    static var registerTitle: LocalizedString {
        return LocalizedString(
            key: "authentication.login.strings.title",
            in: .main
        )
    }

    static var activityIndicatorStyling: (UIActivityIndicatorView) -> Void {
        return { activityIndicator in
            activityIndicator.color = UIColor(light: .dark, dark: .white)
        }
    }

    static var authenticationButtonStyling: (Authentication.Design.ButtonType) -> ((BackbaseDesignSystem.Button) -> Void) {
        return { type in
            return { button in
                if type == .primary {
                    button.cornerRadius = .max(roundedCorners: .allCorners)
                    button.normalBackgroundColor = UIColor(light: .white, dark: .aquaPrimary)
                    button.setTitleColor(UIColor(light: .redPrimary, dark: .dark), for: .normal)
                }
                else if type == .plain {
                    button.setTitleColor(UIColor(light: .dark, dark: .white), for: .normal)
                }
            }
        }
    }

    static var biometricButtonStyling: Style<Button> {
        return { button in
            button.normalBackgroundColor = UIColor(light: .white, dark: .aquaPrimary)
            button.setTitleColor(UIColor(light: .redPrimary, dark: .dark), for: .normal)
            button.cornerRadius = .max(roundedCorners: .allCorners)
        }
    }

    static var backgroundStyling: Style<UIView> {
        return { backgroundView in

            backgroundView.backgroundColor = UIColor(light: .aquaPrimary, dark: .dark)

            setUpClickableSubtitle(on: backgroundView)
        }
    }

    static var headerImageStyling: Style<UIImageView> {
        return { imageView in

            imageView.image = .stackedLogo
            imageView.contentMode = .scaleAspectFit
        }
    }

    static var inputRequiredInputFieldDesign: (UITextContentType) -> ((TextInput) -> Void) {
        return { _ in
            return { textInput in
                textInput.backgroundColor = .white
                textInput.tintColor = .systemBlue
                textInput.textField.textColor = .red
                textInput.layer.cornerRadius = 10
                textInput.textFieldPaddings = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            }
        }
    }

    static var loginSubtitleText: (BiometryType) -> LocalizedString {
        return { _ in
            ""
        }
    }

    static func setUpClickableSubtitle(on backgroundView: UIView) {
        if let superview = backgroundView.superview, superview.subviews.count > 3,
            let subtitleLabel = superview.subviews[3] as? UILabel,
            let westerraUrl = URL(string: "https://westerracu.com") {

            let gestureRecognizer = BindableGestureRecognizer {
                UIApplication.shared.open(westerraUrl)
            }
            subtitleLabel.addGestureRecognizer(gestureRecognizer)
            subtitleLabel.isUserInteractionEnabled = true
        }
    }
}
