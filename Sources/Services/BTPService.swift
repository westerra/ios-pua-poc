//
//  AccountService.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Backbase
import FirebaseAnalytics
import RetailPaymentJourney

protocol BTPServiceProtocol {
    func fetchProfile() async throws -> ProfileResponse
    func fetchAccounts() async throws -> [BBAccount]
    func createAccount(with params: CreateAccountParams) async throws
}

class BTPService: BTPServiceProtocol {
    private let urlSession = URLSession.shared

    func fetchProfile() async throws -> ProfileResponse {
        guard let serverUrl = Backbase.configuration().backbase.serverURL,
            let url = URL(string: "\(serverUrl)/api/user-manager/client-api/v2/users/me/profile") else {
            throw NetworkError.malformedUrl
        }

        do {
            let request = URLRequest(url: url)
            let (responseData, _) = try await urlSession.data(for: request)

            let profile = try JSONDecoder().decode(ProfileResponse.self, from: responseData)
            return profile
        }
        catch {
            Analytics.logEvent("fetchProfile_error", parameters: [
                "description": error.localizedDescription
            ])
            throw NetworkError.apiError
        }
    }

    func fetchAccounts() async throws -> [BBAccount] {
        guard let serverUrl = Backbase.configuration().backbase.serverURL,
            let url = URL(string: "\(serverUrl)/api/arrangement-manager/client-api/v2/productsummary") else {
            throw NetworkError.malformedUrl
        }

        do {
            let request = URLRequest(url: url)
            let (responseData, _) = try await urlSession.data(for: request)

            let accountSummaryResponse = try JSONDecoder().decode(AccountSummaryResponse.self, from: responseData)
            guard let checkingAccounts = accountSummaryResponse.currentAccounts?.products,
                let savingsAccounts = accountSummaryResponse.savingsAccounts?.products
            else {
                throw NetworkError.dataParsing
            }

            return checkingAccounts + savingsAccounts
        }
        catch {
            Analytics.logEvent("fetchAccounts_error", parameters: [
                "description": error.localizedDescription
            ])
            throw NetworkError.apiError
        }
    }

    func createAccount(with params: CreateAccountParams) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            postAccount(with: params) { response in
                switch response {
                case .success:
                    continuation.resume(with: .success(()))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension BTPService {
    private func postAccount(with params: CreateAccountParams, completion: @escaping ((Result<AccountCreationResponse, NetworkError>) -> Void)) {
        guard let serverUrl = Backbase.configuration().backbase.serverURL,
            let url = URL(string: "\(serverUrl)/api/payment-order-service/client-api/v2/payment-orders") else {
            completion(.failure(.malformedUrl))
            return
        }

        guard let httpBody = try? JSONSerialization.data(withJSONObject: newAccountRequestBody(for: params)) else {
            completion(.failure(.dataParsing))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, _ in
            do {
                guard let data = data else {
                    completion(.failure(.apiError))
                    return
                }

                let response = try JSONDecoder().decode(AccountCreationResponse.self, from: data)
                if response.status == AccountCreationStatus.processed.rawValue {
                    completion(.success(response))
                    return
                }

                if response.status == AccountCreationStatus.rejected.rawValue {
                    completion(.failure(.apiErrorWith(response.errorDescription ?? "")))
                    return
                }

                completion(.failure(.apiError))
            }
            catch {
                completion(.failure(.dataParsing))
            }
        }
        .resume()
    }
}

extension BTPService {
    func newAccountRequestBody(for params: CreateAccountParams) -> [String: Any?] {
        var payload = [
            "instructionPriority": "NORM",
            "paymentType": "INTERNAL_TRANSFER",
            "paymentMode": "SINGLE",
            "requestedExecutionDate": Date().getDateString(format: "yyyy-MM-dd"),
            "originatorAccount": [
                "name": params.fundingAccount.name ?? "",
                "identification": [
                    "identification": params.fundingAccount.id ?? "",
                    "schemeName": "ID"
                ]
            ] as [String: Any],
            "transferTransactionInformation": [
                "counterparty": [
                    "name": "HOLIDAY",
                    "role": "CREDITOR"
                ],
                "instructedAmount": [
                    "amount": "\(params.transferAmount)",
                    "currencyCode": "USD"
                ],
                "counterpartyAccount": [
                    "identification": [
                        "identification": "c9d13c35-7cf5-4307-a3de-a07d9990396c",
                        "schemeName": "ID"
                    ]
                ]
            ] as [String: Any]
        ] as [String: Any]

        if !params.transferAmountNote.isEmpty {
            payload["remittanceInformation"] = params.transferAmountNote
        }

        return payload
    }
}
