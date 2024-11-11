//
//  PaymentReviewView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct PaymentReviewView: View {
    @ObservedObject var viewModel: BehindThePinViewModel

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Transferring")
                    .font(.largeTitle)

                Text("$\(viewModel.transferAmount.toCurrency)")
                    .font(.largeTitle)
            }

            VStack(alignment: .leading) {
                PaymentAccountRow(
                    accountName: "From \(viewModel.fundingAccount?.displayName?.uppercased() ?? "")",
                    accountNumber: "\(viewModel.fundingAccount?.number ?? "")",
                    iconColor: .aquaLight
                )

                PaymentAccountCircles()

                PaymentAccountRow(
                    accountName: viewModel.selectedProduct?.type.uppercased() ?? "",
                    accountNumber: "",
                    iconColor: .greyLight
                )
                .padding(.bottom, 30)
            }
            .padding(.bottom, 80)

            VStack(alignment: .leading) {
                Text("When")

                Text("Your transfer will be executed immediately")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.contentBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 3.0)
            }

            Spacer()

            Button("Confirm and Transfer") {
                Task {
                    await viewModel.onScreen(event: .onCreateAndFundAccount)
                }
            }
            .padding(.top, 20)
            .buttonStyle(ShrinkingButton())
        }
        .padding()
        .background(Color.appBackground)
        .navigationTitle("Review")
    }
}

struct PaymentAccountRow: View {
    var accountName: String
    var accountNumber: String
    var iconColor: Color

    var body: some View {
        HStack {
            Group {
                Image(systemName: "creditcard")
                    .font(.system(size: 20))
                    .padding(10)
            }
            .background(iconColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(accountName)
                Text(accountNumber)
            }
        }
    }
}

struct PaymentAccountCircles: View {
    var body: some View {
        VStack(alignment: .leading) {
            Circle()
                .frame(width: 11, height: 11)
                .foregroundColor(.aquaLight)

            Spacer()
                .frame(width: 1, height: 20)
                .background(Color.greyLight)
                .offset(x: 5)

            Circle()
                .frame(width: 11, height: 11)
                .foregroundColor(.greyLight)
        }
        .padding()
    }
}

#Preview {
    PaymentReviewView(
        viewModel: .init(
            coordinator: MockBehindThePinCoordinator(),
            accountService: MockAccountService()
        )
    )
}
