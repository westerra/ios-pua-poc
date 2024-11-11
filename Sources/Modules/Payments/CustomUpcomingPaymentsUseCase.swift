//
//  CustomUpcomingPaymentsUseCase.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import PaymentOrderClient2
import Resolver
import RetailAccountsAndTransactionsJourney
import RetailJourneyCommon
import RetailUpcomingPaymentsJourney
import RetailUpcomingPaymentsJourneyUseCase
import RetailUSApp
import UIKit

class CustomUpcomingPaymentsUseCase: GetUpcomingPaymentsUseCase {
    let defaultUseCase: GetUpcomingPaymentsUseCase

    init() {
        defaultUseCase = RetailGetUpcomingPaymentsUseCase()
    }

    // MARK: - GetUpcomingPaymentsUseCase protocol

    func getPayments(
        parameters: RetailUpcomingPaymentsJourney.GetPaymentsRequestParameters,
        _ whenDone: @escaping RetailUpcomingPaymentsJourney.OnResult<[RetailUpcomingPaymentsJourney.Payment], RetailUpcomingPaymentsJourney.UpcomingPaymentsError>
    ) {
        let itemsPerRequest = 50

        let isScheduledPaymentsRequest = parameters.statuses.contains(.accepted)
        if isScheduledPaymentsRequest {
            let scheduledPaymentsParameters = GetPaymentsRequestParameters(
                paymentTypes: [],
                statuses: parameters.statuses,
                executionDate: nil,
                ascendingOrder: false,
                from: parameters.from,
                size: itemsPerRequest
            )

            fetchUpcomingTabPayments(itemsPerRequest, scheduledPaymentsParameters, whenDone)
            return
        }

        fetchHistoryTabPayments(itemsPerRequest, parameters, whenDone)
    }

    func cancelPayment(
        identifier paymentIdentifier: String,
        version paymentVersion: Int,
        _ whenDone: @escaping RetailUpcomingPaymentsJourney.OnResult<Bool, RetailUpcomingPaymentsJourney.UpcomingPaymentsError>
    ) {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: ["version": paymentVersion])
        else {
            DispatchQueue.main.async {
                whenDone(.failure(.failed))
            }
            return
        }

        let urlPath = String(format: "%@/%@/%@", ServerEndpoint.paymentOrders.path, paymentIdentifier, "cancel")
        guard let url = URL(string: urlPath) else {
            DispatchQueue.main.async {
                whenDone(.failure(.failed))
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    whenDone(.failure(.failed))
                }
                return
            }

            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                if let status = response?["accepted"] as? Bool {
                    DispatchQueue.main.async {
                        whenDone(.success(status))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        whenDone(.failure(.failed))
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    whenDone(.failure(.failed))
                }
            }
        }
        .resume()
    }

    func getPayments(
        status: [String],
        executionDate: Date,
        from: Int,
        size: Int,
        _ whenDone: @escaping RetailUpcomingPaymentsJourney.OnResult<[RetailUpcomingPaymentsJourney.Payment], RetailUpcomingPaymentsJourney.UpcomingPaymentsError>
    ) {
        guard let url = self.getUpcomingPaymentsEndpointURL(
            withStatus: status,
            executionDate: executionDate,
            from: from,
            size: size
        ) else {
            whenDone(.failure(.failed))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let dataResponse = data, error == nil
            else {
                whenDone(.failure(.failed))
                return
            }

            do {
                let upcomingPayments = try JSONDecoder().decode([PaymentOrderClient2.PaymentOrderGetResponse].self, from: dataResponse)
                let upcomingPaymentsItems = self.mapUpcomingPaymentItem(fromPaymentOrderGetResponse: upcomingPayments)
                DispatchQueue.main.async {
                    whenDone(.success(upcomingPaymentsItems))
                }
            }
            catch {
                whenDone(.failure(.failed))
            }
        }

        task.resume()
    }
}

// MARK: - API

extension CustomUpcomingPaymentsUseCase {
    private func fetchUpcomingTabPayments(
        _ itemsPerRequest: Int,
        _ parameters: RetailUpcomingPaymentsJourney.GetPaymentsRequestParameters,
        _ whenDone: @escaping RetailUpcomingPaymentsJourney.OnResult<[RetailUpcomingPaymentsJourney.Payment], RetailUpcomingPaymentsJourney.UpcomingPaymentsError>
    ) {
        let statuses = getMappedStatuses(from: parameters.statuses)
        guard let url = self.getUpcomingPaymentsEndpointURL(
            withStatus: statuses,
            executionDate: nil,
            from: parameters.from,
            size: itemsPerRequest
        ) else {
            whenDone(.failure(.failed))
            return
        }

        fetchPayments(with: url, and: whenDone)
    }

    private func fetchHistoryTabPayments(
        _ itemsPerRequest: Int,
        _ parameters: RetailUpcomingPaymentsJourney.GetPaymentsRequestParameters,
        _ whenDone: @escaping RetailUpcomingPaymentsJourney.OnResult<[RetailUpcomingPaymentsJourney.Payment], RetailUpcomingPaymentsJourney.UpcomingPaymentsError>
    ) {
        var paymentStatuses = parameters.statuses
        paymentStatuses.append(.cancellationPending)

        let statuses = getMappedStatuses(from: paymentStatuses)
        guard let url = self.getUpcomingPaymentsEndpointURL(
            withStatus: statuses,
            executionDate: nil,
            from: parameters.from,
            size: itemsPerRequest
        ) else {
            whenDone(.failure(.failed))
            return
        }

        fetchPayments(with: url, and: whenDone)
    }

    private func fetchPayments(
        with url: URL,
        and whenDone: @escaping RetailUpcomingPaymentsJourney.OnResult<[RetailUpcomingPaymentsJourney.Payment], RetailUpcomingPaymentsJourney.UpcomingPaymentsError>
    ) {
        let getPaymentsTask = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard let dataResponse = data, error == nil
                else {
                    whenDone(.failure(.failed))
                    return
                }

                do {
                    guard let jsonArray = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [Any] else {
                        whenDone(.failure(.failed))
                        return
                    }

                    let upcomingPayments = self.parseUpcomingPayments(from: jsonArray)
                    let upcomingPaymentsItems = self.mapUpcomingPaymentItem(fromPaymentOrderGetResponse: upcomingPayments)
                    whenDone(.success(upcomingPaymentsItems))
                }
                catch {
                    whenDone(.failure(.failed))
                }
            }
        }
        getPaymentsTask.resume()
    }
}

// MARK: - API Helpers

extension CustomUpcomingPaymentsUseCase {
    private func getUpcomingPaymentsEndpointURL(withStatus status: [String], executionDate: Date?, from: Int, size: Int) -> URL? {
        guard var urlComponents = ServerEndpoint.paymentOrders.urlComponents else {
            return nil
        }

        let queryItems = [
            URLQueryItem(name: "from", value: String(format: "%d", from)),
            URLQueryItem(name: "orderBy", value: "requestedExecutionDate"),
            URLQueryItem(name: "direction", value: "DESC"),
            URLQueryItem(name: "size", value: String(format: "%d", size)),
            URLQueryItem(name: "status", value: status.joined(separator: ","))
        ]

        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    // Reduction would make this harder to read
    // swiftlint:disable:next function_body_length
    private func mapUpcomingPaymentItem(
        fromPaymentOrderGetResponse items: [PaymentOrderClient2.PaymentOrderGetResponse]
    ) -> [RetailUpcomingPaymentsJourney.Payment] {

        var upcomingPayments = [RetailUpcomingPaymentsJourney.Payment]()

        for item in items {
            let paymentAmount = RetailUpcomingPaymentsJourney.Amount(
                value: Decimal(string: item.totalAmount?.amount ?? "") ?? 0.00,
                currencyCode: item.totalAmount?.currencyCode ?? "USD"
            )

            var paymentFrequency: RetailUpcomingPaymentsJourney.Frequency = .once
            var paymentSchedule: RetailUpcomingPaymentsJourney.Schedule = RetailUpcomingPaymentsJourney.Schedule(
                nextExecutionDate: item.requestedExecutionDate,
                frequency: paymentFrequency,
                endDate: item.requestedExecutionDate,
                startDate: item.requestedExecutionDate,
                numberOfPayment: 1,
                remainingNumberOfPayments: nil
            )

            if let schedule = item.schedule {
                switch schedule.transferFrequency {
                case .once:
                    paymentFrequency = .once
                case .daily:
                    paymentFrequency = .daily
                case .weekly:
                    paymentFrequency = .weekly
                case .biweekly:
                    paymentFrequency = .biweekly
                case .monthly:
                    paymentFrequency = .monthly
                case .quarterly:
                    paymentFrequency = .quarterly
                case .yearly:
                    paymentFrequency = .yearly
                default:
                    paymentFrequency = .once
                }

                paymentSchedule = RetailUpcomingPaymentsJourney.Schedule(
                    nextExecutionDate: schedule.nextExecutionDate,
                    frequency: paymentFrequency,
                    endDate: schedule.endDate,
                    startDate: schedule.startDate,
                    numberOfPayment: schedule._repeat,
                    remainingNumberOfPayments: nil
                )
            }

            var paymentStatus: RetailUpcomingPaymentsJourney.PaymentStatus = .unknown
            switch item.status {
            case .accepted:
                paymentStatus = .accepted
            case .cancellationPending:
                paymentStatus = .cancellationPending
            case .cancelled:
                paymentStatus = .cancelled
            case .confirmationDeclined:
                paymentStatus = .unknown
            case .confirmationPending:
                paymentStatus = .unknown
            case .draft:
                paymentStatus = .draft
            case .entered:
                paymentStatus = .entered
            case .processed:
                paymentStatus = .processed
            case .ready:
                paymentStatus = .ready
            case .rejected:
                paymentStatus = .rejected
            default:
                paymentStatus = .unknown
            }

            let payment = RetailUpcomingPaymentsJourney.Payment(
                identifier: item.id,
                amount: paymentAmount,
                counterpartyAccount: RetailUpcomingPaymentsJourney.CounterpartyAccount(
                    name: item.transferTransactionInformation?.counterparty.name ?? "",
                    identifier: item.transferTransactionInformation?.counterpartyAccount.arrangementId,
                    accountNumber: item.transferTransactionInformation?.counterpartyAccount.identification.identification
                ),
                originatorAccount: RetailUpcomingPaymentsJourney.OriginatorAccount(
                    name: item.originator?.name ?? "",
                    identifier: item.originatorAccount?.arrangementId,
                    accountNumber: item.originatorAccount?.identification.identification
                ),
                schedule: paymentSchedule,
                requestedExecutionDate: item.requestedExecutionDate,
                status: paymentStatus,
                reasonCode: item.reasonCode,
                type: item.paymentType,
                version: item.version,
                description: item.transferTransactionInformation?.remittanceInformation?.content,
                paymentSetupId: item.paymentSetupId
            )
            upcomingPayments.append(payment)
        }

        return upcomingPayments
    }

    private func getMappedStatuses(from paymentStatuses: [PaymentStatus]) -> [String] {
        var statuses = [String]()
        for status in paymentStatuses {
            switch status {
            case .accepted:            statuses.append("ACCEPTED")
            case .cancellationPending: statuses.append("CANCELLATION_PENDING")
            case .draft:               statuses.append("DRAFT")
            case .entered:             statuses.append("ENTERED")
            case .ready:               statuses.append("READY")
            case .processed:           statuses.append("PROCESSED")
            case .rejected:            statuses.append("REJECTED")
            case .cancelled:           statuses.append("CANCELLED")
            case .unknown:             statuses.append("UNKNOWN")
            @unknown default:          statuses.append("")
            }
        }
        return statuses
    }

    private func parseUpcomingPayments(from jsonArray: [Any]) -> [PaymentOrderClient2.PaymentOrderGetResponse] {
        var upcomingPayments = [PaymentOrderClient2.PaymentOrderGetResponse]()
        for object in jsonArray {
            do {
                let jsonObject = try JSONSerialization.data(withJSONObject: object)
                let upcomingPayment = try JSONDecoder().decode(PaymentOrderClient2.PaymentOrderGetResponse.self, from: jsonObject)
                upcomingPayments.append(upcomingPayment)
            }
            catch let error as NSError {
                print("JSON decoder error: \(error)")
            }
        }

        return upcomingPayments
    }
}
