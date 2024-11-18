//
//  PaymentsClient.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import ArrangementsClient2
import Backbase
import Foundation
import PaymentOrderClient2
import RetailPaymentJourney

class PaymentsClient {

    let backbaseConfiguration: BBConfiguration

    init() {
        self.backbaseConfiguration = Backbase.configuration()
    }

    func getPaymentAccountListings(url: URL, completion: @escaping ([PaymentParty]) -> Void) {

        let task = URLSession.shared.dataTask(with: url) { data, _, error in

            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }

            do {
                let arrangementList = try JSONDecoder().decode([ArrangementsClient2.ProductSummaryItem].self, from: dataResponse)
                let paymentPartyList = self.getAccountPaymentParties(arrangementList: arrangementList)
                completion(paymentPartyList)
            }
            catch {
                print(error.localizedDescription)
                completion([])
            }
        }
        task.resume()
    }
}

private extension PaymentsClient {

    func getAccountPaymentParties(arrangementList: [ArrangementsClient2.ProductSummaryItem]) -> [PaymentParty] {
        WCUStore.shared.productSummaryItems = arrangementList

        var accountPaymentParties: [PaymentParty] = []

        for account in arrangementList {
            switch account.productKindName {
            case AccountTypes.currentAccount.rawValue:
                accountPaymentParties.append(mapAccountType(account: account, type: .currentAccount))
            case AccountTypes.savingsAccount.rawValue:
                accountPaymentParties.append(mapAccountType(account: account, type: .savingsAccount))
            case AccountTypes.termDeposit.rawValue, AccountTypes.loan.rawValue:
                accountPaymentParties.append(mapAccountType(account: account, type: .loan))
            case AccountTypes.creditCard.rawValue:
                accountPaymentParties.append(mapAccountType(account: account, type: .creditCard))
            case AccountTypes.investmentAccount.rawValue:
                accountPaymentParties.append(mapAccountType(account: account, type: .custom(type: AccountTypes.investmentAccount.rawValue)))
            default:
                accountPaymentParties.append(mapAccountType(account: account, type: .custom(type: AccountTypes.otherAccount.rawValue)))
            }
        }

        return PartyOrder().orderParties(accountPaymentParties: accountPaymentParties)
    }

    func mapAccountType(account: ArrangementsClient2.ProductSummaryItem, type: PaymentPartyType) -> PaymentParty {

        let availableBalance = account.availableBalance?.toDecimal()
        let bookedBalance = account.bookedBalance?.toDecimal()
        let remainingCredit = account.remainingCredit?.toDecimal()
        let minimumPayment = account.minimumPayment?.toDecimal()
        let outstandingPayment = account.outstandingPayment?.toDecimal()

        // emailAddress and phoneNumber are being set to nil. So we don't need to map them. If needed, then map them using product type of contact
        // minimumPayment, outstandingPayment and minimumPaymentDueDate are moved under CreditCard when productType is set to .creditCard
        // Depening on the business requirement we need to create either a generic or credit card product type
        let creditCardProductType: ProductType = .creditCard(CreditCardAdditions(minimumPaymentDueDate: account.minimumPaymentDueDate, outstandingPayment: outstandingPayment, minimumPayment: minimumPayment))
        let contactProductType: ProductType = .contact(ContactAdditions(phoneNumber: "testNumber", emailAddress: "testEmail"))
        let genericProductType: ProductType = .generic
        
        return PaymentParty(
            identifier: account.id,
            name: account.displayName ?? "Failed to Parse",
            type: type,
            identifications: [.bban: account.BBAN ?? "Unknown Account Number"],
            currencyCode: account.currency,
            availableBalance: availableBalance,
            bookedBalance: bookedBalance,
            remainingCredit: remainingCredit,
            amountOptions: [
                AmountOption(fieldType: .outstandingPayment, amount: outstandingPayment),
                AmountOption(fieldType: .minimumPayment, amount: minimumPayment),
                AmountOption(fieldType: .statementBalance, amount: availableBalance),
                AmountOption(fieldType: .bookedBalance, amount: bookedBalance)
            ],
            saveContact: nil,
            additions: account.additions,
            // set this value based on the business logic
            productType: contactProductType
        )
    }
}
