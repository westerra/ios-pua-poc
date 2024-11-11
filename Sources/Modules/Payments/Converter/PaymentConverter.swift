//
//  PaymentConverter.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import PaymentOrderClient2
import RetailPaymentJourney

enum PaymentConverter {
    static func convertPaymentState(state: PaymentOrderClient2.PaymentOrdersPostResponse) -> RetailPaymentJourney.PaymentState {
        return RetailPaymentJourney.PaymentState(
            id: "",
            status: convertStatus(status: state.status),
            transactionSigningState: nil,
            bankStatus: state.bankStatus,
            reasonCode: state.reasonCode,
            reasonText: state.reasonText,
            additions: state.additions
        )
    }

    static func paymentStatus(for value: String?) -> PaymentState.Status {
        switch value?.uppercased() {
        case "DRAFT":                   return .draft
        case "ENTERED":                 return .entered
        case "READY":                   return .ready
        case "ACCEPTED":                return .accepted
        case "PROCESSED":               return .processed
        case "REJECTED":                return .rejected
        case "CANCELLED":               return .cancelled
        case "CANCELLATION PENDING":    return .cancellationPending
        case "CONFIRMATION PENDING":    return .confirmationPending
        case "CONFIRMATION DECLINED":   return .confirmationDeclined
        default:                        return .rejected
        }
    }

    // swiftlint:disable:next discouraged_optional_collection
    static func convertFrequencyOption(option: FrequencyOption?, andStartDate date: Date) -> [String: Any]? {
        guard let option = option else {
            return nil
        }

        let startDate = date.getDateString(format: "yyyy-MM-dd")
        var schedule = [String: Any]()
        var endRecurringOption: EndRecurringOption

        switch option {
        case .weekly(option: let end):
            schedule["transferFrequency"] = "WEEKLY"
            schedule["on"] = "\(date.dayNumberOfWeek)"
            endRecurringOption = end
        case .biweekly(option: let end):
            schedule["transferFrequency"] = "BIWEEKLY"
            schedule["on"] = "\(date.dayNumberOfWeek)"
            endRecurringOption = end
        case .quarterly(option: let end):
            schedule["transferFrequency"] = "QUARTERLY"
            schedule["on"] = "\(date.dayNumberOfWeek)"
            endRecurringOption = end
        case .monthly(option: let end):
            schedule["transferFrequency"] = "MONTHLY"
            schedule["on"] = "\(date.dayOfMonth)"
            endRecurringOption = end
        case .yearly(option: let end):
            schedule["transferFrequency"] = "YEARLY"
            schedule["on"] = "\(date.monthOfYear)"
            endRecurringOption = end
        default:
            return nil
        }

        switch endRecurringOption {
        case .numberOfTimes(let repeatCount):
            schedule["repeat"] = "\(repeatCount)"
        case .date(let endDate):
            schedule["endDate"] = endDate.getDateString(format: "yyyy-MM-dd")
        case .never:
            break
        default:
            break
        }

        schedule["every"] = "1"
        schedule["startDate"] = startDate

        return schedule
    }
}


private extension PaymentConverter {

    static func convertStatus(status: PaymentOrderClient2.Status) -> PaymentState.Status {

        switch status {
        case PaymentOrderClient2.Status.accepted:               return PaymentState.Status.accepted
        case PaymentOrderClient2.Status.cancellationPending:    return PaymentState.Status.cancellationPending
        case PaymentOrderClient2.Status.cancelled:              return PaymentState.Status.cancelled
        case PaymentOrderClient2.Status.confirmationDeclined:   return PaymentState.Status.confirmationDeclined
        case PaymentOrderClient2.Status.confirmationPending:    return PaymentState.Status.confirmationPending
        case PaymentOrderClient2.Status.draft:                  return PaymentState.Status.draft
        case PaymentOrderClient2.Status.entered:                return PaymentState.Status.entered
        case PaymentOrderClient2.Status.processed:              return PaymentState.Status.processed
        case PaymentOrderClient2.Status.ready:                  return PaymentState.Status.ready
        case PaymentOrderClient2.Status.rejected:               return PaymentState.Status.rejected
        @unknown default:                                       return PaymentState.Status.rejected
        }
    }
}
