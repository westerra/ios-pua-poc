//
//  BehindThePinCoordinatorView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import FlowStacks
import SwiftUI

struct BehindThePinCoordinatorView: View {
    @StateObject var viewModel: BehindThePinViewModel
    @StateObject var coordinatorViewModel: BehindThePinCoordinatorViewModel

    var body: some View {
        content
    }

    @ViewBuilder private var content: some View {
        Router($coordinatorViewModel.routes) { screen, _ in
            switch screen.wrappedValue {
            case .exploreWesterraProducts:
                makeExploreWesterraProductsView()
            case .productsList:
                makeProductsList()
            case .finePrint:
                makeFinePrint()
            case .fundAccount:
                makeFundAccount()
            case .chooseFundingAccount:
                makeChooseFundingAccount()
            case .paymentDetails:
                makePaymentDetails()
            case .paymentReview:
                makePaymentReview()
            case .confirmation:
                makeConfirmation()
            }
        }
    }
}

private extension BehindThePinCoordinatorView {
    func makeExploreWesterraProductsView() -> some View {
        ExploreWesterraProducts(viewModel: viewModel)
    }

    func makeProductsList() -> some View {
        return ProductsListView(viewModel: viewModel)
    }

    func makeFinePrint() -> some View {
        FinePrintView(viewModel: viewModel)
    }

    func makeFundAccount() -> some View {
        FundAccountView(viewModel: viewModel)
    }

    func makeChooseFundingAccount() -> some View {
        ChooseFundingAccountView(viewModel: viewModel)
    }

    func makePaymentDetails() -> some View {
        PaymentDetailsView(viewModel: viewModel)
    }

    func makePaymentReview() -> some View {
        PaymentReviewView(viewModel: viewModel)
    }

    func makeConfirmation() -> some View {
        ConfirmationView(
            state: $viewModel.confirmationState,
            errorMessage: $viewModel.errorMessage,
            onDoneTap: {
                Task {
                    await viewModel.onScreen(event: .onDone)
                }
            }
        )
    }
}
