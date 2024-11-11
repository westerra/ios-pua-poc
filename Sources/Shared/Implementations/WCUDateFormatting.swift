//
//  WCUDateFormatting.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation
import RetailUpcomingPaymentsJourney

struct WCUDateFormatting: DateFormatting {
    func format(date: Date, style: DateFormatter.Style) -> String {
        date.formattedPreferred
    }
}
