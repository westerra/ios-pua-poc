//
//  Date.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

extension Date {
    var firstDayOfMonth: Date! {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)

        return calendar.date(from: components)
    }

    var lastDayOfMonth: Date! {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = 1
        dateComponents.day = -1

        return calendar.date(byAdding: dateComponents, to: firstDayOfMonth)
    }

    var dayNumberOfWeek: Int {
        Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0
    }

    var dayOfMonth: Int {
        Calendar.current.dateComponents([.day], from: self).day ?? 1
    }

    var monthOfYear: Int {
        Calendar.current.dateComponents([.month], from: self).month ?? 1
    }

    var formattedPreferred: String {
        getDateString(format: "EEEE, MMM dd, yyyy")
    }

    var formattedShort: String {
        getDateString(format: "MM/dd/YYYY")
    }

    func getDateString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: self)
    }

    static func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"

        return formatter.date(from: string)
    }
}
