//
//  TimeUnit.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailAccountsAndTransactionsJourney

extension TimeUnit {
    func pluralStringValue() -> String {
        switch self {
        case .day:        return "Days"
        case .week:       return "Weeks"
        case .month:      return "Months"
        case .year:       return "Years"
        default:          return "Invalid TimeUnit"
        }
    }
}
