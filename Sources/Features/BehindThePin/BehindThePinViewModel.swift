//
//  NewAccountViewModel.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Combine
import FirebaseAnalytics
import Foundation

final class BehindThePinViewModel: ObservableObject {
    enum ScreenEvent {
        case onAppear
        case onGoBack
        case onCategorySelection
        case onProductSelection
        case onFinePrint
        case onFundingAccountInfo
        case onFundingAccountSelection
        case onPaymentDetails
        case onCreateAndFundAccount
        case onDone
    }

    @Published var isLoading = false
    @Published var failedLoadingAccounts = false
    @Published var accounts = [BBAccount]()
    @Published var noAvailableAccounts: Bool = false

    // Products List View
    @Published var spendingProducts: [WCUProduct] = []
    @Published var savingsProducts: [WCUProduct] = []
    @Published var availableProductsSectionTitle = ""
    @Published var availableProducts = [WCUProduct]()

    // Fund Account View
    @Published var selectedProduct: WCUProduct?
    @Published var fundingAccount: BBAccount?
    @Published var memberNumber: String = ""

    // Payment Details View
    @Published var transferAmount = 0
    @Published var transferAmountNote: String = ""

    @Published var confirmationState: ConfirmationState = .loading
    @Published var errorMessage: String = ""

    // Validations
    @Published var termsChecked = false
    @Published var certifyChecked = false
    @Published var authorizeChecked = false

    @Published var agreementsChecked = false
    @Published var fundingAccountSelected = false
    @Published var amountInputIsDirty = false
    @Published var validAmountEntered = false

    let noteLength = 140
    let phoneNumber = "303-321-4209"

    private let coordinator: any BehindThePinCoordinator
    private let accountService: BTPServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        coordinator: any BehindThePinCoordinator,
        accountService: BTPServiceProtocol,
        isLoading: Bool = false
    ) {
        self.coordinator = coordinator
        self.accountService = accountService
        self.isLoading = isLoading

        spendingProducts = WCUStore.shared.westerraProducts.filter { $0.category == "Checking" }
        savingsProducts = WCUStore.shared.westerraProducts.filter { $0.category == "Savings" }

        setUpValidations()
    }

    @MainActor
    func validatePaymentDetails() {
        guard let selectedProduct = self.selectedProduct else { return }

        amountInputIsDirty = transferAmount != 0
        validAmountEntered = (transferAmount.toDouble >= selectedProduct.minimumBalance) && (transferAmountNote.count <= noteLength)
    }

    func setUpAvailableProducts(using fetchedAccounts: [BBAccount]) {
        var fetchedAccountsCount = [String: Int]()
        fetchedAccounts.forEach { userAccount in
            if let productTypeName = userAccount.productTypeName {
                fetchedAccountsCount[productTypeName.lowercased(), default: 0] += 1
            }
        }

        fetchedAccounts.forEach { userAccount in
            for (index, spendingProduct) in spendingProducts.enumerated() {
                if let productTypeName = userAccount.productTypeName,
                    productTypeName.lowercased() == spendingProduct.type.lowercased() {

                    spendingProducts[index].userHasProductAlready = true

                    if let userProductTypeCount = fetchedAccountsCount[productTypeName.lowercased()],
                        userProductTypeCount >= spendingProduct.maxAllowedAccounts {

                        spendingProducts[index].maxAllowedAccountsExceeded = true
                    }
                }
            }

            for (index, savingsProduct) in savingsProducts.enumerated() {
                if let productTypeName = userAccount.productTypeName,
                    productTypeName.lowercased() == savingsProduct.type.lowercased() {

                    savingsProducts[index].userHasProductAlready = true

                    if let userProductTypeCount = fetchedAccountsCount[productTypeName.lowercased()],
                        userProductTypeCount >= savingsProduct.maxAllowedAccounts {

                        savingsProducts[index].maxAllowedAccountsExceeded = true
                    }
                }
            }
        }
    }
}

// MARK: - Actions

extension BehindThePinViewModel {
    @MainActor
    func onScreen(event: ScreenEvent) async {
        switch event {
        case .onAppear:
            await onAppear()

        case .onCategorySelection:
            Analytics.logEvent("btp_select_product_category", parameters: [
                "category": availableProductsSectionTitle.lowercased()
            ])
            coordinator.push(to: .productsList)

        case .onGoBack:
            coordinator.pop()

        case .onProductSelection:
            Analytics.logEvent("btp_select_product", parameters: [
                "product": selectedProduct?.description ?? "none"
            ])
            coordinator.push(to: .finePrint)

        case .onFinePrint:
            Analytics.logEvent("btp_terms_accepted", parameters: nil)
            coordinator.push(to: .fundAccount)

        case .onFundingAccountInfo:
            Analytics.logEvent("btp_funding_info_read", parameters: nil)
            coordinator.push(to: .chooseFundingAccount)

        case .onFundingAccountSelection:
            Analytics.logEvent("btp_fund_initiated", parameters: nil)
            coordinator.push(to: .paymentDetails)

        case .onPaymentDetails:
            Analytics.logEvent("btp_funding_info_reviewed", parameters: nil)
            coordinator.push(to: .paymentReview)

        case .onCreateAndFundAccount:
            await onCreateAndFundAccount()

        case .onDone:
            coordinator.popToHostViewController()
        }
    }

    @MainActor
    func onCreateAndFundAccount() async {
        guard let selectedProduct = selectedProduct,
            let fundingAccount = fundingAccount
        else {
            Analytics.logEvent("onCreateAndFundAccount(): product not selected", parameters: nil)
            return
        }

        coordinator.push(to: .confirmation)

        let params = CreateAccountParams(
            selectedProduct: selectedProduct,
            fundingAccount: fundingAccount,
            transferAmount: transferAmount,
            transferAmountNote: transferAmountNote
        )

        do {
            try await accountService.createAccount(with: params)
            confirmationState = .success
            Analytics.logEvent("btp_new_account_created", parameters: [
                "params": params
            ])
        }
        catch let error {
            confirmationState = .failure

            let apiError = error as? NetworkError
            if case .apiErrorWith(let apiErrorMessage) = apiError {
                errorMessage = apiErrorMessage
            }
            else {
                errorMessage = ""
            }
            Analytics.logEvent("btp_account_creation_failed", parameters: [
                "params": params
            ])
        }
    }

    func onAppear() async {
        await executeFetchRequestOnAppear()
    }

    func executeFetchRequestOnAppear() async {
        do {
            let fetchedAccounts = try await fetchAccounts()
            await MainActor.run {
                setUpAvailableProducts(using: fetchedAccounts)
                accounts = fetchedAccounts
            }

            let profile = try await accountService.fetchProfile()
            memberNumber = profile.additions?.customerCode ?? ""
        }
        catch {
            print("handle error: \(error.localizedDescription)")
        }
    }

    func fetchAccounts() async throws -> [BBAccount] {
        do {
            return try await accountService.fetchAccounts()
        }
        catch {
            print("fetchAccounts() error: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - Helpers

extension BehindThePinViewModel {
    private func setUpValidations() {
        // Terms & Conditions
        $termsChecked.sink(receiveValue: { [weak self] termsCheckedValue in
            guard let self else { return }

            self.agreementsChecked = termsCheckedValue && self.certifyChecked && self.authorizeChecked
        })
        .store(in: &cancellables)

        $certifyChecked.sink(receiveValue: { [weak self] certifyCheckedValue in
            guard let self else { return }

            self.agreementsChecked = self.termsChecked && certifyCheckedValue && self.authorizeChecked
        })
        .store(in: &cancellables)

        $authorizeChecked.sink(receiveValue: { [weak self] authorizeCheckedValue in
            guard let self else { return }

            self.agreementsChecked = self.termsChecked && self.certifyChecked && authorizeCheckedValue
        })
        .store(in: &cancellables)

        // Funding Account
        $fundingAccount.sink(receiveValue: { [weak self] fundingAccountValue in
            guard let self else { return }

            self.fundingAccountSelected = fundingAccountValue != nil
        })
        .store(in: &cancellables)

        // Payment Details
        $transferAmount.sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                self?.validatePaymentDetails()
            }
        })
        .store(in: &cancellables)

        $transferAmountNote.sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                self?.validatePaymentDetails()
            }
        })
        .store(in: &cancellables)
    }
}
