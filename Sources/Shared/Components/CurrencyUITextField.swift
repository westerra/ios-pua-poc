//
//  CurrencyUITextField.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI
import UIKit

class CurrencyUITextField: UITextField {
    @Binding private var value: Int
    private let formatter: NumberFormatter

    init(formatter: NumberFormatter, value: Binding<Int>) {
        self.formatter = formatter
        self._value = value
        super.init(frame: .zero)
        setupViews()
    }

    // swiftlint:disable:next unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(resetSelection), for: .allTouchEvents)
        keyboardType = .numberPad
        textAlignment = .left
        sendActions(for: .editingChanged)
    }

    override func deleteBackward() {
        text = textValue.digits.dropLast().string
        sendActions(for: .editingChanged)
    }

    private func setupViews() {
        tintColor = .clear
        font = .systemFont(ofSize: 40, weight: .regular)
    }

    @objc
    private func editingChanged() {
        text = currency(from: decimal)
        resetSelection()
        value = Int(doubleValue * 100)
    }

    @objc
    private func resetSelection() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }

    private var textValue: String {
        return text ?? ""
    }

    private var doubleValue: Double {
        // swiftlint:disable:next legacy_objc_type
        return (decimal as NSDecimalNumber).doubleValue
    }

    private var decimal: Decimal {
        return textValue.decimal / pow(10, formatter.maximumFractionDigits)
    }

    private func currency(from decimal: Decimal) -> String {
        return formatter.string(for: decimal) ?? ""
    }
}
