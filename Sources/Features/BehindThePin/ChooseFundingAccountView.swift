//
//  ChooseFundingAccountView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct ChooseFundingAccountView: View {
    @ObservedObject var viewModel: BehindThePinViewModel

    var body: some View {
        VStack {
            List(selection: $viewModel.fundingAccount) {
                ForEach(viewModel.accounts, id: \.self) { account in
                    FundingAccountRow(account: account)
                        .tag(account)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3.0)

            ContinueButton(
                enabled: $viewModel.fundingAccountSelected,
                onTap: {
                    Task {
                        await viewModel.onScreen(event: .onFundingAccountSelection)
                    }
                }
            )
        }
        .padding()
        .background(Color.appBackground)
        .navigationTitle("From")
    }
}

struct FundingAccountRow: View {
    var account: BBAccount

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(account.displayName ?? "")
                .font(.system(size: 16, weight: .semibold))

            Text(account.bban ?? "")
                .font(.system(size: 12, weight: .semibold))

            Text("Available Balance")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            Text(account.availableBalanceFormatted)
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    ChooseFundingAccountView(
        viewModel: .init(
            coordinator: MockBehindThePinCoordinator(),
            accountService: MockAccountService()
        )
    )
}
