//
//  CardsManagement.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import RetailAppCommon
import RetailCardsManagementJourney
import RetailJourneyCommon
import RetailUSApp
import UIKit

extension CardsManagement {

    /// This is the configuration of the Cards Management module
    static func configure() -> CardsManagement.Configuration {

        // Initialize object
        var cardsManagement = CardsManagement.Configuration()

        // Save indexing for simplifaction
        var details = cardsManagement.details
        var replaceCardSelectReason = cardsManagement.replaceCardSelectReason
        var replaceCardAddressConfirmation = cardsManagement.replaceCardAddressConfirmation

        // Adjust configuration settings
        cardsManagement.strings.cardValidThru = LocalizedString("card.management.valid.thru")
        cardsManagement.uiDataMapper.paymentCardContentProvider = paymentCardContentProvider

        details.strings.screenTitle = LocalizedString("card.management.title")
        details.strings.lockUnlockTitle = LocalizedString("cardsManagement.details.lockUnlockTitle")
        details.strings.replaceCardTitle = LocalizedString("cardsManagement.details.replaceCardTitle")
        details.strings.changePINSubtitle = LocalizedString("cardsManagement.details.changePinSubtitle")
        details.cardNavigationOptionsV2 = getCardOptions(details.cardNavigationOptionsV2)

        replaceCardSelectReason.strings.title = LocalizedString("cardsManagement.replaceCardReason.title")
        replaceCardSelectReason.strings.lostTitle = LocalizedString("cardsManagement.replaceCardReason.lostTitle")
        replaceCardSelectReason.strings.lostSubtitle = LocalizedString("cardsManagement.replaceCardReason.lostSubtitle")
        replaceCardSelectReason.strings.stolenTitle = LocalizedString("cardsManagement.replaceCardReason.stolenTitle")
        replaceCardSelectReason.strings.stolenSubtitle = LocalizedString("cardsManagement.replaceCardReason.stolenSubtitle")
        replaceCardSelectReason.strings.damagedCardTitle = LocalizedString("cardsManagement.replaceCardReason.damagedCardTitle")

        replaceCardAddressConfirmation.strings.screenTitleLost = LocalizedString("cardsManagement.replaceCardAddressConfirmation.screenTitleLost")
        replaceCardAddressConfirmation.strings.screenTitleStolen = LocalizedString("cardsManagement.replaceCardAddressConfirmation.screenTitleStolen")
        replaceCardAddressConfirmation.strings.screenTitleDamaged = LocalizedString("cardsManagement.replaceCardAddressConfirmation.screenTitleDamaged")
        replaceCardAddressConfirmation.strings.inlineMessageTitleLost = LocalizedString("cardsManagement.replaceCardAddressConfirmation.inlineMessageTitleLost")
        replaceCardAddressConfirmation.strings.inlineMessageSubtitleLost = LocalizedString("cardsManagement.replaceCardAddressConfirmation.inlineMessageSubtitleLost")
        replaceCardAddressConfirmation.strings.inlineMessageTitleStolen = LocalizedString("cardsManagement.replaceCardAddressConfirmation.inlineMessageTitleStolen")
        replaceCardAddressConfirmation.strings.inlineMessageSubtitleStolen = LocalizedString("cardsManagement.replaceCardAddressConfirmation.inlineMessageSubtitleStolen")
        replaceCardAddressConfirmation.strings.inlineMessageTitleDamaged = LocalizedString("cardsManagement.replaceCardAddressConfirmation.inlineMessageTitleDamaged")
        replaceCardAddressConfirmation.strings.orderNewCardButtonTitle = LocalizedString("cardsManagement.replaceCardAddressConfirmation.orderNewCardButtonTitle")

        // Apply values back to passed in object
        cardsManagement.details = details
        cardsManagement.replaceCardSelectReason = replaceCardSelectReason
        cardsManagement.replaceCardAddressConfirmation = replaceCardAddressConfirmation

        return cardsManagement
    }
}

private extension CardsManagement {

    static func applyLabelStyles(on label: inout UILabel, with cardItem: CardItem) {
        label.font = UIFont.overrideSystemFont(ofSize: 12.0, weight: .bold)
        label.textColor = (cardItem.type == "Credit") ? .white : .dark
        label.text = label.text == "Credit" || label.text == "Debit" ? "" : label.text
        label.alpha = (self.isLocked(cardItem: cardItem) ? 0.6 : 1.0)
    }

    static func getPaymentCard(from cardItem: CardItem) -> Style<PaymentCard> {
        { paymentCard in
            applyLabelStyles(on: &paymentCard.front.labelOne, with: cardItem)
            applyLabelStyles(on: &paymentCard.front.labelTwo, with: cardItem)
            applyLabelStyles(on: &paymentCard.front.labelThree, with: cardItem)
            applyLabelStyles(on: &paymentCard.front.labelFour, with: cardItem)
        }
    }

    static func paymentCardContentProvider(_ cardItem: RetailCardsManagementJourney.CardItem, _ cvvPlaceholder: String) -> RetailCardsManagementJourney.PaymentCardContent {
        let backgroundImage = UIImage.imageFor(cardType: cardItem.subType ?? "").image(alpha: isLocked(cardItem: cardItem) ? 0.5 : 1.0)
        let cardFront = PaymentCardContent.Front(
            backgroundType: .image(backgroundImage),
            labelOne: cardItem.maskedNumber,
            labelTwo: cardItem.holder?.name ?? "",
            labelThree: "Valid Thru",
            labelFour: "\(cardItem.expiryDate?.month ?? "")/\(cardItem.expiryDate?.year ?? "")",
            labelFive: cardItem.type,
            leftTopImage: nil,
            rightTopImage: nil
        )

        let cardBack = PaymentCardContent.Back(backgroundType: .solidColor(.dark), cvvPlaceholder: "•••")

        return PaymentCardContent(
            identifier: cardItem.identifier,
            front: cardFront,
            back: cardBack,
            style: getPaymentCard(from: cardItem)
        )
    }

    static func isLocked(cardItem: CardItem) -> Bool {
        return cardItem.lockStatus == .some(.locked)
    }

    static func getCardOptions(_ existingOptions: @escaping (UINavigationController) -> (CardItem) -> [CardOptionProtocol]?) -> ((UINavigationController) -> (CardItem) -> [CardOptionProtocol]?) {
        // swiftlint:disable:previous line_length discouraged_optional_collection
        // Haven't found another way to accomplish the removal of the optional_collection
        // The line_length is due to the above disable and having not figured out how to simplify this code

        return { navigationController in
            return { cardItem in
                var options = existingOptions(navigationController)(cardItem) ?? []
                let requestPINtitle = LocalizedString(key: "cardsManagement.details.requestPINView.labels.title", in: .cardsManagement).value
                let changePINtitle = LocalizedString(key: "cardsManagement.details.changePINView.labels.title", in: .cardsManagement).value
                options.removeAll { $0.title == changePINtitle }
                options.removeAll { $0.title == requestPINtitle }
                return options
            }
        }
    }
}
