//
//  ProductsListView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import AlertToast
import SwiftUI

struct ProductsListView: View {
    @ObservedObject var viewModel: BehindThePinViewModel

    @State var showToast: Bool = false
    @State var isPresentingContactUsDialog = false

    private let alertStyle = AlertToast.AlertStyle.style(
        backgroundColor: Color(.appTheme),
        titleColor: Color(.appBackground),
        subTitleColor: nil,
        titleFont: .system(size: 14),
        subTitleFont: nil
    )

    var body: some View {
        if viewModel.accounts.isEmpty {
            if viewModel.noAvailableAccounts {
                noAvailableAccountsView
            }
            else {
                loadingView
            }
        }
        else {
            mainContent
        }
    }

    @ViewBuilder var noAvailableAccountsView: some View {
        VStack(spacing: 20) {
            Text("Please try again soon!")
                .font(.headline)

            Text("No products are curently available for your account.")

            Button("Go Back") {
                Task {
                    await viewModel.onScreen(event: .onGoBack)
                }
            }
            .foregroundColor(.appTheme)
        }
    }

    @ViewBuilder var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView().scaleEffect(1.5)
            Text("Retrieving Products")
        }
    }

    @ViewBuilder var mainContent: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    ForEach(viewModel.availableProducts) { product in
                        ProductWebRow(product: product, showToast: $showToast) {
                            Task {
                                viewModel.selectedProduct = product

                                if product.isEligible {
                                    await viewModel.onScreen(event: .onProductSelection)
                                }
                                else {
                                    showToast = true
                                }
                            }
                        }
                        .padding()
                    }

                    Spacer()

                    Group {
                        Text("Not finding it? ")
                        + Text("Contact us!")
                            .foregroundColor(.aquaDark)
                    }
                    .multilineTextAlignment(.center)
                    .onTapGesture {
                        isPresentingContactUsDialog = true
                    }
                    .confirmationDialog("", isPresented: $isPresentingContactUsDialog) {
                        Button("Message Westerra") { messageWesterra() }
                        Button("Call Westerra") { callWesterra() }
                    }
                }
                .background(Color.appBackground)
                .frame(maxWidth: .infinity)
                .listStyle(.plain)

                if viewModel.isLoading {
                    Spacer()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(Color.black.opacity(0.3))

                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .appTheme))
                }
            }
        }
        .navigationTitle("\(viewModel.availableProductsSectionTitle) Products")
        .navigationBarTitleDisplayMode(.inline)
        .toast(isPresenting: $showToast) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .regular,
                title: getAlertToastTitle(),
                style: alertStyle
            )
        }
    }

    private func messageWesterra() {
        if let phoneNumberUrl = URL(string: "sms:+\(viewModel.phoneNumber)") {
            UIApplication.shared.open(phoneNumberUrl)
        }
    }

    private func callWesterra() {
        if let phoneNumberUrl = URL(string: "tel://\(viewModel.phoneNumber)") {
            UIApplication.shared.open(phoneNumberUrl)
        }
    }

    private func getAlertToastTitle() -> String {
        guard let product = viewModel.selectedProduct else { return "" }

        if product.userHasProductAlready {
            return "You already have an account of this type"
        }

        if product.maxAllowedAccountsExceeded {
            return "You have reached the limit for accounts of this type"
        }

        return "You are not eligible"
    }
}

struct ProductWebRow: View {
    var product: WCUProduct
    @Binding var showToast: Bool
    var onOpenAccount: (() -> Void)

    @State var showSafari = false
    @State private var isLoading = true

    // swiftlint:disable:next force_unwrapping
    let marketingUrl = URL(string: "https://westerra-dev.vercel.app/api/preview?return_to=/iframe-test&secret=NcLE2Ltaa75e")!

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(product.type.uppercased())
                    .padding()
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .background(Color.contentBackground)

                WebView(url: marketingUrl, isLoading: $isLoading)
                    .frame(height: 220)
                    .background(Color.contentBackground)

                HStack(spacing: 0) {
                    moreInfoButton.frame(maxWidth: .infinity)
                    openAccountButton.frame(maxWidth: .infinity)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3.0)
            .sheet(isPresented: $showSafari) {
                if let url = URL(string: product.productUrl) {
                    SafariView(url: url)
                }
            }

            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }

    var moreInfoButton: some View {
        Button(action: {
            showSafari = true
        }, label: {
            Text("More Info")
                .font(.title3)
                .padding(.vertical, 20)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)
                .background(Color.contentBackground)
        })
    }

    var openAccountButton: some View {
        Button(action: {
            onOpenAccount()
        }, label: {
            Text("Open Account")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.textPrimaryReversed)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(getOpenAccountButtonBackground())
        })
    }

    private func getOpenAccountButtonBackground() -> Color {
        return product.isEligible
        ? Color.appTheme
        : Color(.disabledButtonBackground)
    }
}

#Preview {
    ProductsListView(
        viewModel: .init(
            coordinator: MockBehindThePinCoordinator(),
            accountService: MockAccountService()
        )
    )
}
