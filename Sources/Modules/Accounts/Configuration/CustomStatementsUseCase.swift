//
//  CustomStatementsUseCase.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import AccountStatementsClient2Gen2
import Backbase
import Foundation
import Resolver
import RetailAccountStatementsJourney
import RetailAccountStatementsJourneyAccountStatementsUseCase

class CustomStatementsUseCase: AccountStatementsServiceUseCase {
    var statements = [RetailAccountStatementsJourney.AccountStatement]()
    let error = NSError(domain: "Unavailable", code: 404, userInfo: nil)

    func retrieveAccountStatementsFirstPage(
        params: RetailAccountStatementsJourney.AccountStatementsRequestParams,
        loading: @escaping RetrieveLoadingStateHandler,
        completion: @escaping RetrieveHandler
    ) {
        self.statements.removeAll()
        loading(true)
        guard let url = self.getStatementsEndpointURL(with: params) else {
            DispatchQueue.main.async {
                loading(false)
                completion(.failure(RetailAccountStatements.Error.loadingFailed))
            }
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                loading(false)

                guard let dataResponse = data, error == nil
                else {
                    completion(.failure(RetailAccountStatements.Error.loadingFailed))
                    return
                }

                do {
                    let statementList = try JSONDecoder().decode([AccountStatementsClient2Gen2.AccountStatement].self, from: dataResponse)
                    let statementItems = self.mapStatementItem(fromAccountStatementsClient: statementList)
                    self.statements.append(contentsOf: statementItems)
                    if self.statements.isEmpty {
                        completion(.failure(AccountStatementsList.Error.emptyList))
                        return
                    }

                    completion(.success(self.statements))
                }
                catch {
                    completion(.failure(RetailAccountStatements.Error.invalidResponse))
                }
            }
        }
        task.resume()
    }

    func retrieveAccountStatementsNextPage(
        params: RetailAccountStatementsJourney.AccountStatementsRequestParams,
        loading: @escaping RetrieveLoadingStateHandler,
        completion: @escaping RetrieveHandler
    ) {
        loading(true)
        guard let url = self.getStatementsEndpointURL(with: params) else {
            DispatchQueue.main.async {
                loading(false)
                completion(.failure(RetailAccountStatements.Error.loadingFailed))
            }
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard let dataResponse = data, error == nil
                else {
                    loading(false)
                    completion(.failure(RetailAccountStatements.Error.loadingFailed))
                    return
                }

                do {
                    let statementList = try JSONDecoder().decode([AccountStatementsClient2Gen2.AccountStatement].self, from: dataResponse)
                    let statementItems = self.mapStatementItem(fromAccountStatementsClient: statementList)
                    self.statements.append(contentsOf: statementItems)
                    DispatchQueue.main.async {
                        loading(false)
                        if self.statements.isEmpty {
                            completion(.failure(AccountStatementsList.Error.emptyList))
                            return
                        }

                        completion(.success(self.statements))
                    }
                }
                catch {
                    loading(false)
                    completion(.failure(RetailAccountStatements.Error.invalidResponse))
                }
            }
        }
        task.resume()
    }

    func retrieveCategories(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = ServerEndpoint.statementCategories.url else {
            completion(.failure(RetailAccountStatements.Error.loadingFailed))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let dataResponse = data, error == nil
            else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }

            DispatchQueue.main.async {
                do {
                    let response = try JSONSerialization.jsonObject(with: dataResponse, options: .allowFragments) as? [String: Any]
                    if let categories = response?["categories"] as? [String] {
                        completion(.success(categories))
                    }
                    else {
                        completion(.success([]))
                    }
                }
                catch {
                    completion(.success([]))
                }
            }
        }
        task.resume()
    }

    func retrieveAccountStatement(uid: String, loading: @escaping AccountStatementLoadingStateHandler, completion: @escaping AccountStatementHandler) {
        loading(true)
        guard let url = URL(string: String(format: "%@/%@", ServerEndpoint.statementDownload.path, uid)) else {
            DispatchQueue.main.async {
                loading(false)
                completion(.failure(self.error))
            }
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard let dataResponse = data, error == nil
                else {
                    loading(false)
                    completion(.failure(self.error))
                    return
                }

                loading(false)
                completion(.success(dataResponse))
            }
        }
        task.resume()
    }

    func retrieveAccountStatement(url: URL, loading: @escaping AccountStatementLoadingStateHandler, completion: @escaping AccountStatementHandler) { }
}

extension CustomStatementsUseCase {

    func getStatementsEndpointURL(with params: RetailAccountStatementsJourney.AccountStatementsRequestParams) -> URL? {
        guard var urlComponents = ServerEndpoint.statements.urlComponents else {
            return nil
        }

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "from", value: String(format: "%d", self.statements.count)))
        queryItems.append(URLQueryItem(name: "size", value: "10"))

        if let accountId = params.accountId {
            queryItems.append(URLQueryItem(name: "accountId", value: accountId))
        }

        if let fromDate = params.dateFrom {
            queryItems.append(URLQueryItem(name: "dateFrom", value: fromDate))
        }

        if let toDate = params.dateTo {
            queryItems.append(URLQueryItem(name: "dateTo", value: toDate))
        }

        if let category = params.category?.compactMap({ $0 }).joined(separator: ",") {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }

        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    func mapStatementItem(fromAccountStatementsClient items: [AccountStatementsClient2Gen2.AccountStatement]) -> [RetailAccountStatementsJourney.AccountStatement] {
        var accountStatementItems = [RetailAccountStatementsJourney.AccountStatement]()

        for item in items {
            let documents = item.documents.map { document in
                RetailAccountStatementsJourney.AccountStatementIdentification(
                    uid: document.uid,
                    url: document.url,
                    contentType: document.contentType,
                    additions: document.additions
                )
            }

            accountStatementItems.append(
                RetailAccountStatementsJourney.AccountStatement(
                    date: item.date,
                    description: item.description,
                    category: item.category,
                    documents: documents,
                    additions: item.additions
                )
            )
        }

        return accountStatementItems
    }
}
