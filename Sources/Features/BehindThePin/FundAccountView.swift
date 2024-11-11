//
//  FundAccountView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct FundAccountView: View {
    @ObservedObject var viewModel: BehindThePinViewModel

    var body: some View {
        BaseView(mainContent: {
            mainContent
        }, bottomContent: {
            bottomContent
        })
        .navigationTitle("Fund Account")
    }

    var mainContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Let’s fund your account!")
                .font(.system(size: 20, weight: .semibold))

            Text("In order to activate your Westerra account, it will need to be funded.")

            Text("Please select one of your Westerra accounts on the following screen and enter the amount you would like to open your new account with.")

            Text("The new account will be created for member number \(viewModel.memberNumber).")

            if let minimumBalance = viewModel.selectedProduct?.minimumBalance {
                Text("A minimum of \(minimumBalance.currencyFormatted) is required to open this account. If the account is not funded within 25 days, it may be removed.")
            }

            Spacer()
        }
    }

    var bottomContent: some View {
        ContinueButton(
            enabled: .constant(true),
            onTap: {
                Task {
                    await viewModel.onScreen(event: .onFundingAccountInfo)
                }
            }
        )
    }
}

#Preview {
    FundAccountView(
        viewModel: .init(
            coordinator: MockBehindThePinCoordinator(),
            accountService: MockAccountService()
        )
    )
}
