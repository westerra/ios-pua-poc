//
//  String+.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter(\.isWholeNumber) }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension String {
    var decimal: Decimal {
        Decimal(string: digits) ?? 0
    }

    // swiftlint:disable legacy_objc_type
    var numberValueFromDouble: NSNumber? {
        if let value = Double(self) {
            return NSNumber(value: value)
        }
        return nil
    }

    var numberValueFromInt: NSNumber? {
        if let value = Int(self) {
            return NSNumber(value: value)
        }
        return nil
    }
    // swiftlint:enable legacy_objc_type
}
