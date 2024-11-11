//
//  UIImage.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import NotificationsJourney
import RetailAccountsAndTransactionsJourney
import UIKit

extension UIImage {

    // Disabling force_unwrapping check because we should have the assets to back these variables
    // swiftlint:disable force_unwrapping

    // MARK: Logos
    static let horizontalLogoHero: UIImage = UIImage(named: "horizontalLogoHero")!
    static let horizontalLogoHeroAqua: UIImage = UIImage(named: "horizontalLogoHeroAqua")!
    static let horizontalLogoHeroBlack: UIImage = UIImage(named: "horizontalLogoHeroBlack")!
    static let horizontalLogoHeroDarkAqua: UIImage = UIImage(named: "horizontalLogoHeroDarkAqua")!
    static let horizontalLogoHeroDarkRed: UIImage = UIImage(named: "horizontalLogoHeroDarkRed")!
    static let horizontalLogoHeroRedBlack: UIImage = UIImage(named: "horizontalLogoHeroRedBlack")!
    static let horizontalLogoHeroRedWhite: UIImage = UIImage(named: "horizontalLogoHeroRedWhite")!
    static let horizontalLogoHeroWarmRed: UIImage = UIImage(named: "horizontalLogoHeroWarmRed")!
    static let horizontalLogoHeroWhite: UIImage = UIImage(named: "horizontalLogoHeroWhite")!

    static let horizontalLogoLargeBlack6C: UIImage = UIImage(named: "horizontalLogoLargeBlack6C")!
    static let horizontalLogoLargeBlack: UIImage = UIImage(named: "horizontalLogoLargeBlack")!
    static let horizontalLogoLargeWhite: UIImage = UIImage(named: "horizontalLogoLargeWhite")!

    static let logotypeLogoAqua: UIImage = UIImage(named: "logotypeLogoAqua")!
    static let logotypeLogoBlack: UIImage = UIImage(named: "logotypeLogoBlack")!
    static let logotypeLogoDarkAqua: UIImage = UIImage(named: "logotypeLogoDarkAqua")!
    static let logotypeLogoDarkRed: UIImage = UIImage(named: "logotypeLogoDarkRed")!
    static let logotypeLogoWarmRed: UIImage = UIImage(named: "logotypeLogoWarmRed")!
    static let logotypeLogoWhite: UIImage = UIImage(named: "logotypeLogoWhite")!

    static let stackedLogo: UIImage = UIImage(named: "stackedLogo")!
    static let stackedLogoAqua: UIImage = UIImage(named: "stackedLogoAqua")!
    static let stackedLogoBlack6C: UIImage = UIImage(named: "stackedLogoBlack6C")!
    static let stackedLogoDarkAqua: UIImage = UIImage(named: "stackedLogoDarkAqua")!
    static let stackedLogoDarkRed: UIImage = UIImage(named: "stackedLogoDarkRed")!
    static let stackedLogoRedBlack: UIImage = UIImage(named: "stackedLogoRedBlack")!
    static let stackedLogoRedWhite: UIImage = UIImage(named: "stackedLogoRedWhite")!
    static let stackedLogoWarmRed: UIImage = UIImage(named: "stackedLogoWarmRed")!
    static let stackedLogoWhite: UIImage = UIImage(named: "stackedLogoWhite")!

    // MARK: Cards
    static let businessCredit: UIImage = UIImage(named: "businessCredit")!
    static let businessDebit: UIImage = UIImage(named: "businessDebit")!
    static let businessRewards: UIImage = UIImage(named: "businessRewards")!
    static let classic: UIImage = UIImage(named: "classic")!
    static let debit: UIImage = UIImage(named: "debit")!
    static let platinum: UIImage = UIImage(named: "platinum")!
    static let select: UIImage = UIImage(named: "select")!
    static let signature: UIImage = UIImage(named: "signature")!

    // MARK: Icons
    static let accountSuccess: UIImage = UIImage(named: "accountSuccess")!
    static let billPayDashboard: UIImage = UIImage(named: "billPayDashboard")!
    static let calendar: UIImage = UIImage(named: "calendar")!
    static let card: UIImage = UIImage(named: "card")!
    static let changePasscode: UIImage = UIImage(named: "changePasscode")!
    static let changePassword: UIImage = UIImage(named: "changePassword")!
    static let close: UIImage = UIImage(named: "close")!
    static let logout: UIImage = UIImage(named: "logout")!
    static let makeATransfer: UIImage = UIImage(named: "makeATransfer")!
    static let manageNotifications: UIImage = UIImage(named: "manageNotifications")!
    static let messages: UIImage = UIImage(named: "messages")!
    static let moveMoney: UIImage = UIImage(named: "moveMoney")!
    static let billPay: UIImage = UIImage(named: "billPay")!
    static let p2p: UIImage = UIImage(named: "p2p")!
    static let payBills: UIImage = UIImage(named: "payBills")!
    static let paymentActivity: UIImage = UIImage(named: "paymentActivity")!
    static let scheduledTransfers: UIImage = UIImage(named: "scheduledTransfers")!
    static let camera: UIImage = UIImage(named: "camera")!
    static let contacts: UIImage = UIImage(named: "contacts")!
    static let profile: UIImage = UIImage(named: "profile")!
    static let cardRewards: UIImage = UIImage(named: "cardRewards")!
    static let wcuLogo: UIImage = UIImage(named: "wcuLogo")!
    static let trash: UIImage = UIImage(named: "trash")!
    static let backbaseIconGavel: UIImage = UIImage(named: "backbase_ic_gavel")!
    static let backbaseIconSchedule: UIImage = UIImage(named: "backbase_ic_schedule")!

    // MARK: AccountType Images
    static let checking: UIImage = UIImage(named: "checking")!
    static let credit: UIImage = UIImage(named: "credit")!
    static let savings: UIImage = UIImage(named: "savings")!

    // MARK: Account Statement Image
    static let incomingTransaction: UIImage = UIImage(named: "incomingTransaction")!
    static let outgoingTransaction: UIImage = UIImage(named: "outgoingTransaction")!
    static let statement: UIImage = UIImage(named: "statement")!
    static let taxStatement: UIImage = UIImage(named: "taxStatement")!

    // swiftlint:enable force_unwrapping
}

// MARK: Instance Helpers
extension UIImage {

    /// This method is used to increase the opacity of a UIImage, so that we can use it when we don't have access to the ImageView, but we only have access to the Image asset.
    /// - Parameter alpha: Requested image alpha
    /// - Returns: Resulting image with adjusted alpha
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: Static Helpers
extension UIImage {

    /// Retrieves images based on account type
    /// - Parameter accountType: The account type that we're hoping to supply an image for
    /// - Returns: The image associated with the account type, will return an empty image object if account type is not associated to an image
    static func imageFor(accountType: RetailAccountsAndTransactionsJourney.Accounts.AccountType) -> UIImage {
        switch accountType {
        case .creditCard, .debitCard:                       return .credit
        case .current, .general:                            return .checking
        case .savings, .investment, .loan, .termDeposit:    return .savings
        default:                                            return UIImage()
        }
    }

    /// Retrieves images based on account type
    /// - Parameter accountType: The account type that we're hoping to supply an image for
    /// - Returns: The image associated with the account type, will return an empty image object if account type is not associated to an image
    static func imageFor(accountType: NotificationsJourney.AccountType) -> UIImage {
        switch accountType {
        case .creditCard, .debitCard:                       return .credit
        case .current, .general:                            return .checking
        case .savings, .investment, .loan, .termDeposit:    return .savings
        default:                                            return UIImage()
        }
    }

    /// Retrieves images based on account type
    /// - Parameter accountType: The account type that we're hoping to supply an image for
    /// - Returns: The image associated with the account type, will return an empty image object if account type is not associated to an image
    static func imageFor(cardType: String) -> UIImage {
        switch cardType {
        case "Business Debit Card":                         return .businessDebit
        case "Business Rewards":                            return .businessRewards
        case "Business Visa":                               return .businessCredit
        case "Credit Card Classic":                         return .classic
        case "Visa Select":                                 return .select
        case "Credit Card Platinum":                        return .platinum
        case "Visa Signature":                              return .signature
        case "Debit Card":                                  return .debit
        default:                                            return UIImage()
        }
    }
}
