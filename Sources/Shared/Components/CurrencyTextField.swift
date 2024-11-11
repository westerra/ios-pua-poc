//
//  CurrencyTextField.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct CurrencyTextField: UIViewRepresentable {
    typealias UIViewType = CurrencyUITextField

    let numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField

    init(numberFormatter: NumberFormatter, value: Binding<Int>) {
        self.numberFormatter = numberFormatter
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }

    func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }

    func updateUIView(_ uiView: CurrencyUITextField, context: Context) { }
}
