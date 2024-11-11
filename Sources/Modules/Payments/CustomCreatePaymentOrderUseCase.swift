//
//  CustomCreatePaymentOrderUseCase.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import PaymentOrderClient2
import RetailPaymentJourney

class CustomCreatePaymentOrderUseCase: CreatePaymentOrderUseCase {

    private let dispatchQueue = DispatchQueue.main

    func execute(
        _ paymentOrder: RetailPaymentJourney.PaymentOrder,
        completion: @escaping RetailPaymentJourney.OnResult<RetailPaymentJourney.PaymentState, RetailPaymentJourney.ServiceError>
    ) {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody(for: paymentOrder)),
            let paymentOrdersUrl = ServerEndpoint.paymentOrders.url
        else {
            dispatchQueue.async {
                completion(.failure(.failed(error: nil)))
            }
            return
        }

        var request = URLRequest(url: paymentOrdersUrl)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                self.dispatchQueue.async {
                    completion(.failure(.failed(error: error)))
                }
                return
            }

            do {
                struct Status: Codable {
                    let bankStatus, reasonCode: String?
                }

                let status = try JSONDecoder().decode(Status.self, from: data)

                let paymentState = PaymentState(
                    id: "",
                    status: PaymentConverter.paymentStatus(for: status.bankStatus),
                    transactionSigningState: nil,
                    bankStatus: status.bankStatus,
                    reasonCode: status.reasonCode,
                    reasonText: nil,
                    additions: nil,
                    errorDescription: nil
                )

                self.dispatchQueue.async {
                    completion(.success(paymentState))
                }
            }
            catch {
                self.dispatchQueue.async {
                    completion(.failure(.failed(error: error)))
                }
            }
        }
        .resume()
    }

    func pollPaymentOrderStatus(_ orderId: String, completion: @escaping OnResult<PaymentState, ServiceError>) {
        guard let paymentOrdersProgressStatusRequest = ServerEndpoint.paymentOrdersProgressStatus(for: orderId).request else {
            return
        }

        URLSession.shared.dataTask(with: paymentOrdersProgressStatusRequest) { data, _, error in
            self.dispatchQueue.async {
                if let error = error {
                    completion(.failure(.failed(error: error)))
                }

                do {
                    guard
                        let data = data
                    else {
                        completion(.success(PaymentState(id: "", status: .rejected)))
                        return
                    }

                    let paymentResponse = try JSONDecoder().decode(PaymentOrderClient2.PaymentOrdersPostResponse.self, from: data)

                    completion(.success(PaymentConverter.convertPaymentState(state: paymentResponse)))
                }
                catch {
                    print(error)
                    completion(.success(PaymentState(id: "", status: .rejected)))
                }
            }
        }
        .resume()
    }
}

private extension CustomCreatePaymentOrderUseCase {

    func requestBody(for paymentOrder: PaymentOrder) -> [String: Any?] {
        return [
            "instructionPriority": "NORM",
            "paymentType": paymentOrder.paymentType,
            "paymentMode": paymentOrder.frequencyOption == nil ? "SINGLE" : "RECURRING",
            "requestedExecutionDate": paymentOrder.paymentDate.getDateString(format: "yyyy-MM-dd"),
            "originatorAccount": [
                "name": paymentOrder.fromAccount.name,
                "identification": [
                    "identification": paymentOrder.fromAccount.identifier,
                    "schemeName": "ID"
                ]
            ] as [String: Any],
            "transferTransactionInformation": [
                "counterparty": [
                    "name": paymentOrder.toAccount.name,
                    "role": "CREDITOR"
                ],
                "instructedAmount": [
                    "amount": "\(paymentOrder.amount.value)",
                    "currencyCode": paymentOrder.amount.currencyCode
                ],
                "counterpartyAccount": [
                    "identification": [
                        "identification": paymentOrder.toAccount.phoneNumber ?? "",
                        "schemeName": "BBAN"
                    ],
                    "selectedContact": [
                        "contactId": paymentOrder.toAccount.identifier
                    ]
                ],
                "remittanceInformation": paymentOrder.remittanceInfo ?? ""
            ] as [String: Any],

            "schedule": PaymentConverter.convertFrequencyOption(option: paymentOrder.frequencyOption, andStartDate: paymentOrder.paymentDate)
        ]
    }
}
