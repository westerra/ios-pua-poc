//
//  RetailPayment.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import UIKit

import Resolver
import RetailAccountsAndTransactionsJourney
import RetailContactsJourney
import RetailJourneyCommon
import RetailPaymentJourney
import RetailUSApp

extension RetailPayment {

    static func configure(_ retailPayment: RetailPayment.Configuration, isP2P: Bool = false) -> RetailPayment.Configuration {
        var payments = RetailPayment.Configuration(
            createPaymentOrderUseCase: isP2P ? CustomCreatePaymentOrderUseCase() : retailPayment.createPaymentOrderUseCase,
            getPaymentPartiesUseCase: CustomGetPaymentPartiesServiceUseCase(),
            contactsUseCase: CustomContactsUseCase()
        )

        if isP2P {
            payments = payments.p2pTransfer()
            payments.transferType = .custom("INTRABANK_TRANSFER")
            payments.paymentSteps = p2pPaymentSteps
            payments.contactList.strings.noResultsTitle = LocalizedString("p2p.paymentFlow.noContacts.title")
            payments.contactList.router.onAddContactTapped = onAddContactTapped
        }
        else {
            payments.paymentSteps = paymentSteps
            payments.paymentPartyList = transferPaymentParties
        }

        // Disable payTowards options
        payments.otherAmountForm.payTowardsOption = { _, _ in
            return []
        }

        // Disable credit card other amount
        payments.paymentOptionList.amountOptionsForPaymentParty = { _, _ in
            return []
        }

        payments.paymentPartyList.dataMapper.accountNumber = paymentPartyListAccountNumber
//        payments.paymentPartyList.fromPaymentPartyListFilter = .init(apply: { fromParty, _ in
//            guard let fromAccountId = fromParty?.identifier else {
//                return true
//            }
//
//            return WCUStore.shared.hiddenAccountIds.contains(fromAccountId) == false
//        })
//        payments.paymentPartyList.toPaymentPartyListFilter = .init(apply: { _, toParty in
//            guard let toAccountId = toParty?.identifier else {
//                return true
//            }
//
//            return WCUStore.shared.hiddenAccountIds.contains(toAccountId) == false
//        })

        payments.balanceDisplayOption = paymentBalanceDisplayOption
        payments.paymentReview = paymentReview
        payments.paymentComplete = paymentSuccess
        return payments
    }
}

// MARK: Payment Flow
private extension RetailPayment {

    static var paymentSteps: PaymentSteps.Configuration {
        var formStep = FormStep.Configuration()

        var scheduleField = ScheduleFieldConfiguration()
        scheduleField.filteredFrequencyOptions = { _ in
            return [.weekly, .biweekly, .monthly, .quarterly, .yearly]
        }

        scheduleField.showRecurringOption = { paymentOrderInput in
            switch paymentOrderInput.fromPaymentParty?.type {
            case .loan, .creditCard:
                return false
            default:
                return true
            }
        }

        var remittanceInfo = RemittanceInfoConfiguration()
        remittanceInfo.strings.title = LocalizedString("Note")
        remittanceInfo.strings.placeHolderText = LocalizedString("Enter note")

        var amountField = AmountFieldConfiguration()
        amountField.strings.noDueAmountInfo = ""

        formStep.fields = [
            .paymentParty(PaymentPartyFieldConfiguration()),
            .amount(amountField),
            .schedule(scheduleField),
            .remittanceInfo(remittanceInfo)
        ]

        var paymentSteps = PaymentSteps.Configuration()
        paymentSteps.steps = [.form(formStep)]

        paymentSteps.router.didTapReviewButton = onTapReviewButton

        return paymentSteps
    }

    static var paymentReview: PaymentReview.Configuration {
        var paymentReviewScreen = PaymentReview.Configuration()

        paymentReviewScreen.defaultAccountIcon = .checking

        paymentReviewScreen.reviewScreenElements = [
            .amountSummary,
            .paymentPartySummary,
            .customDescription { paymentOrder in
                let scheduleDateString = paymentOrder.paymentDate.formattedShort
                let currentDateString = Date().formattedShort

                if scheduleDateString == currentDateString && paymentOrder.frequencyOption != nil {
                    return ("Warning", "The start date cannot be today's date. Please choose a future date.")
                }
                return nil
            },
            .customDescription { paymentOrder in
                if paymentOrder.fromAccount.type == .creditCard {
                    return ("Rates & Fees", "Standard cash Advance rates and fees apply")
                }
                return nil
            },
            .scheduleSummary,
            .paymentDescription
        ]

        paymentReviewScreen.currencyFormatter = {
            DefaultCurrencyFormatter()
        }

        return paymentReviewScreen
    }

    static var paymentSuccess: PaymentComplete.Configuration {
        var paymentSuccessScreen = PaymentComplete.Configuration()
        paymentSuccessScreen.strings.doneTitle = LocalizedString("paymentFlow.retail.paymentComplete.doneButton.title")

        paymentSuccessScreen.strings.subtitle = { state in
            if state.status == .rejected {
                return state.reasonText ?? "Unknown Reason"
            }

            return ""
        }

        paymentSuccessScreen.router.exitJourney = { _, _ in
            if let tabbarController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController {
                tabbarController.dismiss(animated: true) {
                    if let navigationController = tabbarController.selectedViewController as? UINavigationController {
                        navigationController.isNavigationBarHidden = false
                        navigationController.popToRootViewController(animated: true)
                    }
                }
            }
        }
        return paymentSuccessScreen
    }

    static var transferPaymentParties: PaymentPartyList.Configuration {

        var transferPaymentPartyConfig = PaymentPartyList.Configuration()

        transferPaymentPartyConfig.fromPaymentPartyListFilter = PaymentPartyList.Filter { tuple -> Bool in
            return [
                PaymentPartyType.savingsAccount,
                PaymentPartyType.currentAccount,
                PaymentPartyType.creditCard,
                PaymentPartyType.loan
            ].contains { $0 == tuple.from?.type }
        }

        transferPaymentPartyConfig.toPaymentPartyListFilter = PaymentPartyList.Filter { tuple -> Bool in
            return [
                PaymentPartyType.savingsAccount,
                PaymentPartyType.currentAccount,
                PaymentPartyType.creditCard,
                PaymentPartyType.loan
            ].contains { $0 == tuple.to?.type }
        }

        return transferPaymentPartyConfig
    }

    // Customize balance displayed for To and From lists in Move Money
    static var paymentBalanceDisplayOption: (PaymentParty, PaymentPartyRole) -> BalanceDisplayOption {
        return { paymentParty, paymentPartyRole in

            if paymentPartyRole == .debit {
                return .availableBalance
            }

            if paymentParty.type == .loan || paymentParty.type == .creditCard {
                return .bookedBalance
            }

            return .availableBalance
        }
    }

    static var paymentPartyListAccountNumber: (PaymentParty) -> String? = { paymentParty in
        return paymentParty.identifications[.bban]
    }

    static var onTapReviewButton: (
        UINavigationController,
        RetailPaymentJourney.RetailPayment.Configuration,
        RetailPaymentJourney.PaymentOrder?) -> Void = { navigationController, configuration, paymentOrder in

        guard let paymentOrder = paymentOrder else { return }

        if (paymentOrder.fromAccount.type == .loan || paymentOrder.fromAccount.type == .creditCard) && paymentOrder.paymentDate > Date() {
            let alert = UIAlertController(
                title: "Error",
                message: "Future transfer from a loan account or credit card is not allowed.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            navigationController.present(alert, animated: true)
            return
        }

        let paymentReview = PaymentReview.build(
            navigationController: navigationController,
            configuration: configuration,
            paymentOrder: paymentOrder
        )

        let actionClose = UIAction(
            title: "", handler: { _ in
                navigationController.popViewController(animated: true)
            }
        )

        paymentReview.navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: actionClose
        )

        navigationController.pushViewController(paymentReview, animated: true)
    }
}

private extension RetailPayment {

    static var p2pPaymentSteps: PaymentSteps.Configuration {

        var formStep = FormStep.Configuration()
        formStep.strings.title = LocalizedString("Payment details")

        var scheduleField = ScheduleFieldConfiguration()
        scheduleField.filteredFrequencyOptions = { _ in
            return [.weekly, .biweekly, .monthly, .quarterly, .yearly]
        }

        scheduleField.showRecurringOption = { paymentOrderInput in
            switch paymentOrderInput.fromPaymentParty?.type {
            case .loan, .creditCard:
                return false
            default:
                return true
            }
        }

        var remittanceInfo = RemittanceInfoConfiguration()
        remittanceInfo.strings.title = LocalizedString("Note")
        remittanceInfo.strings.placeHolderText = LocalizedString("Enter note")

        formStep.fields = [
            .amount(AmountFieldConfiguration()),
            .schedule(scheduleField),
            .remittanceInfo(remittanceInfo)
        ]

        var paymentSteps = PaymentSteps.Configuration()
        paymentSteps.steps = [
            .toContactSelection,
            .fromPartySelection(.init()),
            .form(formStep)
        ]

        paymentSteps.router.didTapReviewButton = onTapReviewButton

        return paymentSteps
    }
}

// MARK: Contacts Flow
private extension RetailPayment {

    static func onAddContactTapped(
        navigationController: UINavigationController,
        paymentOrder: PaymentOrderInput,
        configuration: RetailPayment.Configuration
    ) {
        let addContactViewController = ContactForm.buildAdd(navigationController: navigationController)
        let newNavigationController = UINavigationController(rootViewController: addContactViewController)
        newNavigationController.navigationBar.tintColor = UIColor(light: .dark, dark: .greyLightest)
        navigationController.visibleViewController?.present(newNavigationController, animated: true)
    }
}
