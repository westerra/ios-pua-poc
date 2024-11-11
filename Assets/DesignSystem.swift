//
//  DesignSystem.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import UIKit

extension DesignSystem {

    static var stackViewLabel: UILabel?

    /// This is the configuration of the DesignSystem module
    static func configure() -> DesignSystem {

        var design = DesignSystem()

        // Override system fonts
        UIFont.overrideInitialize(&design)

        design.colors.primary.default = .appTheme
        design.colors.foundation.default = .appBackground

        design.styles.infoBadge = { badge in
            badge.backgroundColor = UIColor(light: .redMedium, dark: .aquaDarkest)
            badge.textColor = .appTheme
        }

        design.styles.summaryStackViewPrimaryLabel = summaryStackViewPrimaryStyle
        design.styles.summaryStackViewAmountLabel = summaryStackViewAmountStyle

        design.styles.stateView = stateViewStyle

        design.styles.navigationController = navigationControllerStyle

        return design
    }
    
    static var summaryStackViewAmountStyle: Style<UILabel> {
        return { balance in
            balance.textColor = .init(light: .dark, dark: .white)
            balance.font = UIFont.overrideSystemFont(ofSize: 20.0, weight: .bold)
        }
    }
}

private extension DesignSystem {

    static var summaryStackViewPrimaryStyle: Style<UILabel> {
        return { title in
            title.textColor = .init(light: .dark, dark: .white)
            title.font = UIFont.overrideSystemFont(ofSize: 16.0, weight: .bold)
            DesignSystem.stackViewLabel = title
        }
    }

    static var navigationControllerStyle: Style<UINavigationController> {
        return { navigationController in
            UINavigationBar.setStyle(for: navigationController.navigationBar)
        }
    }
    
    static var stateViewStyle: Style<BackbaseDesignSystem.StateView> {
        return { stateView in
            stateView.titleLabelStyle = { titleLabel in
                titleLabel.textColor = UIColor(light: .dark, dark: .white)
                titleLabel.font = UIFont.overrideSystemFont(ofSize: 17.0, weight: .bold)
            }
            
            stateView.subtitleLabelStyle = { subtitleLabel in
                subtitleLabel.textColor = .systemGray
                subtitleLabel.font = UIFont.overrideSystemFont(ofSize: 15.0, weight: .regular)
                subtitleLabel.numberOfLines = 2
                subtitleLabel.textAlignment = .center
            }
            
            stateView.firstButtonStyle = { firstButton in
                firstButton.normalBackgroundColor = .redPrimaryBackground
                firstButton.highlightedBackgroundColor = .redDarkest
                firstButton.cornerRadius = .max()
                firstButton.titleLabel?.font = UIFont.overrideBoldSystemFont(ofSize: 15.0)
                
                let buttonHeight = 32.0
                let heightContraint = NSLayoutConstraint(
                    item: firstButton,
                    attribute: NSLayoutConstraint.Attribute.height,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: nil,
                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                    multiplier: 1,
                    constant: buttonHeight)
                NSLayoutConstraint.activate([heightContraint])
            }
        }
    }
}
