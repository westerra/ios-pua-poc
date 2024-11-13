//
//  CustomTransactionsUseCase.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Backbase
import Foundation
import Resolver
import RetailAccountsAndTransactionsJourney
import RetailAccountsAndTransactionsJourneyTransactionsUseCase
import TransactionsClient2Gen2

class CustomTransactionsUseCase: TransactionsUseCase {

    var defaultUseCase: TransactionsUseCase!

    init() {
        defaultUseCase = RetailTransactionsUseCase(client: client)
    }

    private lazy var client: TransactionClientAPIProtocol = {
        guard let transactionsUrl = ServerEndpoint.transactions.url else {
            fatalError("Failed to construct transactions URL")
        }

        let transactionsClient = TransactionClientAPI()
        transactionsClient.baseURL = transactionsUrl

        if let dataProvider = Resolver.optional(DBSDataProvider.self) {
            transactionsClient.dataProvider = dataProvider
            return transactionsClient
        }

        try? Backbase.register(client: transactionsClient)
        guard let dbsClient = Backbase.registered(client: TransactionClientAPI.self),
            let client = dbsClient as? TransactionClientAPI
        else {
            fatalError("Failed to retrieve client")
        }
        return client
    }()

    func retrieveTransaction(identifier: String, completion: @escaping RetrieveTransactionCompletionHandler) {
        defaultUseCase.retrieveTransaction(identifier: identifier, completion: completion)
    }

    func retrieveTransactions(
        with params: RetailAccountsAndTransactionsJourney.Transaction.GetRequestParameters,
        completion: @escaping RetrieveTransactionsCompletionHandler
    ) {

        let params = Transaction.GetRequestParameters(
            amountGreaterThan: params.amountGreaterThan,
            amountLessThan: params.amountLessThan,
            bookingDateGreaterThan: params.bookingDateGreaterThan,
            bookingDateLessThan: params.bookingDateLessThan,
            types: params.types,
            description: params.description,
            reference: params.reference,
            typeGroups: params.typeGroups,
            counterPartyName: params.counterPartyName,
            counterPartyAccountNumber: params.counterPartyAccountNumber,
            creditDebitIndicator: params.creditDebitIndicator,
            categories: params.categories,
            billingStatus: params.billingStatus,
            state: params.state,
            currency: params.currency,
            notes: params.notes,
            identifier: params.identifier,
            arrangementId: params.arrangementId,
            arrangementsIds: params.arrangementsIds,
            fromCheckSerialNumber: params.fromCheckSerialNumber,
            toCheckSerialNumber: params.toCheckSerialNumber,
            checkSerialNumbers: params.checkSerialNumbers,
            query: params.query,
            from: params.from ?? 0,
            cursor: params.cursor,
            size: params.size,
            orderBy: "externalId",
            direction: params.direction,
            secDirection: params.secDirection
        )

        defaultUseCase.retrieveTransactions(with: params) { response in
            switch response {
            case .success(let transactions):
                var transactionItems = [Transaction.Item]()
                for transaction in transactions {
                    var item = transaction
                    if transaction.billingStatus == "PENDING" {
                        item = self.getTransactionItem(transactionItem: transaction, withRunningBalance: false)
                    }
                    transactionItems.append(item)
                }
                completion(.success(transactionItems))

            case .failure(let error):
                completion(.failure(ErrorResponse(statusCode: 404, data: nil, error: error)))
            }
        }
    }

    func retrieveIcon(for merchant: RetailAccountsAndTransactionsJourney.Transaction.Merchant, completion: @escaping RetrieveMerchantLogoHandler) {
        defaultUseCase.retrieveIcon(for: merchant, completion: completion)
    }

    func retrieveCheckImages(transactionIdentifier: String, completion: @escaping RetrieveCheckImagesHandler) {
        defaultUseCase.retrieveCheckImages(transactionIdentifier: transactionIdentifier, completion: completion)
    }
}

extension CustomTransactionsUseCase {

    func getTransactionItem(transactionItem: Transaction.Item, withRunningBalance showRunningBalance: Bool) -> Transaction.Item {
        return Transaction.Item(
            identifier: transactionItem.identifier,
            arrangementId: transactionItem.arrangementId,
            reference: transactionItem.reference,
            description: transactionItem.description,
            typeGroup: transactionItem.typeGroup,
            type: transactionItem.type,
            category: transactionItem.category,
            categoryId: transactionItem.categoryId,
            location: transactionItem.location,
            merchant: transactionItem.merchant,
            bookingDate: transactionItem.bookingDate,
            valueDate: transactionItem.valueDate,
            creditDebitIndicator: transactionItem.creditDebitIndicator,
            transactionAmountCurrency: transactionItem.transactionAmountCurrency,
            instructedAmountCurrency: transactionItem.instructedAmountCurrency,
            currencyExchangeRate: transactionItem.currencyExchangeRate,
            counterPartyName: transactionItem.counterPartyName,
            counterPartyAccountNumber: transactionItem.counterPartyAccountNumber,
            counterPartyBIC: transactionItem.counterPartyBIC,
            counterPartyCity: transactionItem.counterPartyCity,
            counterPartyAddress: transactionItem.counterPartyAddress,
            counterPartyCountry: transactionItem.counterPartyCountry,
            counterPartyBankName: transactionItem.counterPartyBankName,
            creditorId: transactionItem.creditorId,
            mandateReference: transactionItem.mandateReference,
            billingStatus: transactionItem.billingStatus,
            checkSerialNumber: transactionItem.checkSerialNumber,
            notes: transactionItem.notes,
            runningBalance: showRunningBalance ? transactionItem.runningBalance : nil,
            additions: transactionItem.additions,
            checkImageAvailability: transactionItem.checkImageAvailability == .available
                ? RetailAccountsAndTransactionsJourney.Transaction.CheckImageAvailability.available
                : RetailAccountsAndTransactionsJourney.Transaction.CheckImageAvailability.unavailable,
            creationTime: transactionItem.creationTime,
            originalDescription: transactionItem.originalDescription,
            state: transactionItem.state
        )
    }
}
