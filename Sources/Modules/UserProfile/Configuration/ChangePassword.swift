//
//  ChangePassword.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import UIKit

import BackbaseDesignSystem
import UserProfileJourney

/*
    1. If you’re presenting the view controller modally, it should be a new navigation controller
    that the journey is instantiated with, not the one that you already have. e.g. a correct implementation is more like

    let navigationController = UINavigationController()
    let changePassword = ChangePassword.build(navigationController: navigationController)
    navigationController.viewControllers = [changePassword]
    parentViewController.present(navigationController, animated: true)

    2. One option to consider is to change the syntax so that you build-upon the existing OOTB configuration

    changePassword.enterCurrentPassword.design.title = changePassword.enterCurrentPassword.design.title <> { label in
        label.textColor = UIColor(light: .black, dark: .white)
    }

    or

    changePassword.enterCurrentPassword.design.title = { label in
        changePassword.design.title(label)
        label.textColor = .red
    }

    3. Documentations
    - configuration: https://backbase.io/developers/embed/ios/capabilities/user-profile/4.2.0/Structs/ChangePassword/Configuration.html
    - design: https://backbase.io/developers/ios/capabilities/user-profile/4.2.0/Structs/ChangePassword/Design.html

    4. Customization reference: https://support.backbase.com/hc/en-us/requests/14390
*/

extension ChangePassword {

    static func configure(_ changePassword: inout ChangePassword.Configuration) {
        let textColor = UIColor(light: .dark, dark: .white)
        let backgroundColor = UIColor(light: .aquaPrimary, dark: .dark)
        let buttonTitleColor = UIColor(light: .redPrimary, dark: .dark)

        /* "Enter Current Password" screen customizations */

        changePassword.design.backgroundView = changePassword.design.backgroundView <> { backgroundView in
            backgroundView.backgroundColor = backgroundColor
        }
        changePassword.enterCurrentPassword.design.cancelButtonItem = changePassword.enterCurrentPassword.design.cancelButtonItem <> { barButtonItem in
            barButtonItem.tintColor = textColor
        }
        changePassword.enterCurrentPassword.design.title = changePassword.enterCurrentPassword.design.title <> { label in
            label.textColor = textColor
        }
        changePassword.enterCurrentPassword.design.subtitle = changePassword.enterCurrentPassword.design.subtitle <> { label in
            label.textColor = textColor
        }
        changePassword.enterCurrentPassword.design.passwordInputField = changePassword.enterCurrentPassword.design.passwordInputField <> { inputField in
            inputField.titleLabel.textColor = textColor
        }
        changePassword.enterCurrentPassword.design.confirmButton = changePassword.enterCurrentPassword.design.confirmButton <> { confirmButton in
            confirmButton.setTitleColor(buttonTitleColor, for: .normal)
        }

        /* "New Password Screen" screen customizations */

        changePassword.newPassword.design.backgroundView = changePassword.newPassword.design.backgroundView <> { backgroundView in
            backgroundView.backgroundColor = backgroundColor
        }
        changePassword.newPassword.design.cancelButtonItem = changePassword.newPassword.design.cancelButtonItem <> { barButtonItem in
            barButtonItem.tintColor = textColor
        }
        changePassword.newPassword.design.title = changePassword.newPassword.design.title <> { label in
            label.textColor = textColor
        }
        changePassword.newPassword.design.subtitle = changePassword.newPassword.design.subtitle <> { label in
            label.textColor = textColor
        }
        changePassword.newPassword.design.passwordInputField = changePassword.newPassword.design.passwordInputField <> { inputField in
            inputField.titleLabel.textColor = textColor
        }
        changePassword.newPassword.design.confirmPasswordInputField = changePassword.newPassword.design.confirmPasswordInputField <> { inputField in
            inputField.titleLabel.textColor = textColor
            inputField.border?.color = UIColor.borderColor.cgColor
        }
        changePassword.newPassword.design.tooltip = changePassword.newPassword.design.tooltip <> { label in
            label.textColor = textColor
            // swiftlint:disable:next line_length
            label.text = "Your new password must contain:\n\n• A minimum of 9 characters\n• At least one UPPERCASE letter\n• At least one lowercase letter\n• At least one number\n• At least one special character\n\nYour new password CANNOT be:\n\n• Your username\n• Your email address\n• Any of the last 5 previous passwords"
        }
        changePassword.newPassword.design.tooltipIcon = changePassword.newPassword.design.tooltipIcon <> { imageView in
            imageView.tintColor = textColor
        }
        changePassword.newPassword.design.confirmButton = changePassword.newPassword.design.confirmButton <> { barButtonItem in
            barButtonItem.setTitleColor(buttonTitleColor, for: .normal)
        }
    }
}
