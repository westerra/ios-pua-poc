//
//  CustomAccountsUseCase.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import ArrangementsClient2Gen2
import Backbase
import Foundation
import Resolver
import RetailAccountsAndTransactionsJourney
import RetailAccountsAndTransactionsJourneyAccountsUseCase

class CustomAccountsUseCase: AccountsUseCase {
    var defaultUseCase: AccountsUseCase!

    private lazy var client: ProductSummaryAPIProtocol = {
        guard let accountsUrl = ServerEndpoint.accounts.url else {
            fatalError("Failed to construct accounts URL")
        }

        let accountsClient = ProductSummaryAPI()
        accountsClient.baseURL = accountsUrl

        if let dataProvider = Resolver.optional(DBSDataProvider.self) {
            accountsClient.dataProvider = dataProvider
            return accountsClient
        }

        try? Backbase.register(client: accountsClient)
        guard let dbsClient = Backbase.registered(client: ProductSummaryAPI.self),
            let client = dbsClient as? ProductSummaryAPI
        else {
            fatalError("Failed to retrieve client")
        }
        return client
    }()

    init() {
        defaultUseCase = RetailAccountsUseCase(client: client)
    }

    func retrieveAccounts(params: RetailAccountsAndTransactionsJourney.ProductSummary.GetRequestParameters?, completion: @escaping RetrieveAccountsHandler) {
        defaultUseCase.retrieveAccounts(params: params, completion: completion)
    }
}
