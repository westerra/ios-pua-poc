//
//  PaymentView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct PaymentDetailsView: View {
    @ObservedObject var viewModel: BehindThePinViewModel

    private let numberFormatter: NumberFormatter

    init(viewModel: BehindThePinViewModel) {
        self.viewModel = viewModel
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Amount")
                    .font(.system(size: 16))

                CurrencyTextField(
                    numberFormatter: numberFormatter,
                    value: $viewModel.transferAmount
                )
                .frame(height: 50)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.greyDarkest)
                .border(width: 1, edges: [.bottom], color: viewModel.amountInputIsDirty && !viewModel.validAmountEntered ? .red : .clear)

                if let selectedProduct = viewModel.selectedProduct,
                    viewModel.amountInputIsDirty,
                    !viewModel.validAmountEntered {
                    Text(
                        "A minimum of \(selectedProduct.formattedMinimumBalance) is required to open this account." +
                        "If the account is not funded within 25 days, it may be removed."
                    )
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                    .padding(.top, 10)
                }
            }
            .padding(20)
            .background(Color.contentBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3.0)

            VStack(alignment: .leading) {
                Text("Note (optional)")
                    .font(.system(size: 16))

                TextField("", text: $viewModel.transferAmountNote)
                    .placeholder(when: viewModel.transferAmountNote.isEmpty) {
                        Text("Enter note")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .autocapitalization(.sentences)
                    .addBorder(viewModel.transferAmountNote.count <= viewModel.noteLength ? Color.textPrimary : .red, width: 1, cornerRadius: 10)

                Text("\(viewModel.transferAmountNote.count)/\(viewModel.noteLength)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding( 20)
            .background(Color.contentBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3.0)

            Spacer()

            ContinueButton(
                enabled: $viewModel.validAmountEntered,
                onTap: {
                    Task {
                        await viewModel.onScreen(event: .onPaymentDetails)
                    }
                }
            )
        }
        .padding()
        .background(Color.appBackground)
        .navigationTitle("Payment Details")
    }
}

#Preview {
    PaymentDetailsView(
        viewModel: .init(
            coordinator: MockBehindThePinCoordinator(),
            accountService: MockAccountService()
        )
    )
}
