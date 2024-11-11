//
//  ExploreWesterraProducts.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import ProgressHUD
import SwiftUI

struct ExploreWesterraProducts: View {
    @ObservedObject var viewModel: BehindThePinViewModel

    @State var isPresentingContactUsDialog = false

    var body: some View {
        BaseView {
            VStack(alignment: .center, spacing: 30) {
                Text("Let's make this easy")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Adding a new share is now just a few taps away!")
                    .multilineTextAlignment(.center)

                Text("What are you looking for?")

                HStack(spacing: 40) {
                    ProductTile(image: UIImage(resource: .categorySpending), title: "Spending") {
                        Task {
                            viewModel.availableProductsSectionTitle = "Spending"
                            viewModel.availableProducts = viewModel.spendingProducts
                            await viewModel.onScreen(event: .onCategorySelection)
                        }
                    }

                    ProductTile(image: UIImage(resource: .categorySavings), title: "Savings") {
                        Task {
                            viewModel.availableProductsSectionTitle = "Savings"
                            viewModel.availableProducts = viewModel.savingsProducts
                            await viewModel.onScreen(event: .onCategorySelection)
                        }
                    }
                }

                Spacer()

                Group {
                    Text("Not all products are available for online enrollment. Please ")
                    + Text("contact us")
                        .foregroundColor(.aquaDark)
                    + Text(" to learn more.")
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
        }
        .navigationTitle("Explore Westerra Products")
        .onAppear {
            Task {
                await viewModel.onScreen(event: .onAppear)
            }
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
}

private struct ProductTile: View {
    var image: UIImage
    var title: String
    var onTap: (() -> Void)

    var body: some View {
        VStack {
            Button(action: {
                onTap()
            }, label: {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1))

                    Text(title)
                        .foregroundColor(.textPrimary)
                }
            })
        }
    }
}

#Preview {
    ExploreWesterraProducts(
        viewModel: .init(
            coordinator: MockBehindThePinCoordinator(),
            accountService: MockAccountService()
        )
    )
}
