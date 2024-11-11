//
//  PartyOrder.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailPaymentJourney

class PartyOrder {

    func orderParties(accountPaymentParties: [PaymentParty]) -> [PaymentParty] {

        var paymentPartiesOrdered: [PaymentParty] = []

        paymentPartiesOrdered.append(contentsOf: organizeAccounts(for: accountPaymentParties, ofType: .savingsAccount))
        paymentPartiesOrdered.append(contentsOf: organizeAccounts(for: accountPaymentParties, ofType: .currentAccount))
        paymentPartiesOrdered.append(contentsOf: organizeAccounts(for: accountPaymentParties, ofType: .loan))
        paymentPartiesOrdered.append(contentsOf: organizeAccounts(for: accountPaymentParties, ofType: .creditCard))
        paymentPartiesOrdered.append(contentsOf: organizeAccounts(for: accountPaymentParties, ofType: .custom(type: AccountTypes.investmentAccount.rawValue)))
        paymentPartiesOrdered.append(contentsOf: organizeAccounts(for: accountPaymentParties, ofType: .custom(type: AccountTypes.otherAccount.rawValue)))

        return paymentPartiesOrdered
    }
}

private extension PartyOrder {

    func organizeAccounts(for accountPaymentParties: [PaymentParty], ofType type: PaymentPartyType) -> [PaymentParty] {

        var paymentPartiesOrdered: [PaymentParty] = []

        for account in accountPaymentParties where account.type == type {
            paymentPartiesOrdered.append(account)
        }

        return orderAccountsNumerically(for: &paymentPartiesOrdered)
    }

    func orderAccountsNumerically(for accountPaymentParties: inout [PaymentParty]) -> [PaymentParty] {

        guard accountPaymentParties.count > 1 else { return accountPaymentParties }

        var swap = true

        while swap == true {
            swap = false
            for party in 0...accountPaymentParties.count - 2 {

                guard
                    let accountNumStringInitial = accountPaymentParties[party].identifications[.bban]?.suffix(4),
                    let accountNumStringNext = accountPaymentParties[party + 1].identifications[.bban]?.suffix(4),
                    let accountNumInitial = Int(accountNumStringInitial),
                    let accountNumNext = Int(accountNumStringNext)
                else {
                    continue
                }

                if accountNumNext < accountNumInitial {
                    let temp = accountPaymentParties[party + 1]
                    accountPaymentParties[party + 1] = accountPaymentParties[party]
                    accountPaymentParties[party] = temp
                    swap = true
                }
            }
        }
        return accountPaymentParties
    }
}
