//
//  SelfEnrollment.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import Foundation
import UIKit

import Backbase
import BackbaseDesignSystem
import IdentitySelfEnrollmentJourney
import SafariServices

extension SelfEnrollment {

    static func configure(_ selfEnrollment: inout SelfEnrollment.Configuration) {

        selfEnrollment.design.styles.background = { background in
            background.backgroundColor = UIColor(light: .aquaPrimary, dark: .dark)

            if let subviews = background.superview?.subviews {
                // Workaround for setting text colors since Backbase is missing `selfEnrollment.design.colors`
                setTextColors(subviews)
                setButtonColor(subviews)
            }
        }

        selfEnrollment.mainScreenConfig.image = .stackedLogo
        selfEnrollment.mainScreenConfig.router.didTapNewEnrollment = onTapNewEnrollment
    }

    static var onTapNewEnrollment: ((_ navigationController: UINavigationController) -> () -> Void)? = { navigationController in
        return {
            guard var serverUrl = Backbase.configuration().backbase.serverURL
            else { fatalError("Failed to get server URL") }

            if !Bundle.isDev {
                serverUrl = serverUrl.replacingOccurrences(of: "edge.", with: "digitalservices.")
            }

            guard let enrollmentUrl = URL(string: "\(serverUrl)/retail-app/en/enrollment?source=mobile")
            else { fatalError("Failed to get enrollment URL") }

            let safariVC = SFSafariViewController(url: enrollmentUrl)
            navigationController.present(safariVC, animated: true)
        }
    }

    private static func setTextColors(_ subviews: [UIView]) {
        if subviews.count >= 3, let scrollView = subviews[1] as? UIScrollView,
            scrollView.subviews.count >= 2, let stackView = scrollView.subviews[1] as? UIStackView, stackView.subviews.count >= 2 {

            if let firstLabel = stackView.subviews[0] as? UILabel,
                let secondLabel = stackView.subviews[1] as? UILabel {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    firstLabel.text = "Welcome to digital banking!"
                    firstLabel.textColor = .textPrimary
                    secondLabel.textColor = .textPrimary
                }
            }
        }
    }

    private static func setButtonColor(_ subviews: [UIView]) {
        if subviews.count >= 3, let stackView = subviews[2] as? UIStackView, stackView.subviews.count >= 2 {

            if let secondButton = stackView.subviews[1] as? BackbaseDesignSystem.Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    secondButton.setTitleColor(.textPrimary, for: .normal)
                }
            }
        }
    }
}
