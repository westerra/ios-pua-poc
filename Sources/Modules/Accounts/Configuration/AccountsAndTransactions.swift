//
//  AccountsAndTransactions.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import Resolver
import RetailAccountsAndTransactionsJourney
import RetailAccountStatementsJourney
import RetailJourneyCommon
import RetailPaymentJourney
import RetailUSApp
import UIKit

extension AccountsAndTransactions {

    /// This is the configuration of the Accounts and Transactions module
    static func configure(_ accountsAndTransactions: inout AccountsAndTransactions.Configuration) {

        Resolver.register { CustomTransactionsUseCase() as TransactionsUseCase }

        // Save indexing for simplifaction
        var accounts = accountsAndTransactions.accounts
        var accountDetails = accountsAndTransactions.accountDetails
        var transactions = accountsAndTransactions.transactions

        // Adjust configuration settings
        accounts.strings.currentAccountTitle = LocalizedString("accountsAndTransactions.accounts.labels.section.title.currentAccounts")
        accounts.strings.errorSubtitle = subtitle

        accounts.accountRowProvider = accountRowProvider
        accounts.displayedAccounts = accountsToDisplay
        accounts.grouping = .accountType
        accounts.creditCardDataProvider = creditCardDataProvider
        accounts.router.didSelectManageAccounts = { navigationController in
            return { [weak navigationController] productSummary in
                guard let navigationController = navigationController else { return }

                let manageAccountsAlertController = ManageAccountsAlertController.build(navigationController: navigationController, productSummary: productSummary)
                manageAccountsAlertController.title = ""
                navigationController.present(manageAccountsAlertController, animated: true)
            }
        }

        accountDetails.accountSummaryProvider = accountSummaryProvider
        accountDetails.creditCardSectionsProvider = creditCardAccountProvider
        accountDetails.currentAccountSectionsProvider = currentAccountProvider
        accountDetails.generalAccountSectionsProvider = generalAccountProvider
        accountDetails.investmentAccountSectionsProvider = investmentAccountProvider
        accountDetails.loanAccountSectionsProvider = loanAccountsProvider
        accountDetails.savingsAccountSectionsProvider = savingsAccountProvider
        accountDetails.termDepositSectionsProvider = termDepositAccountProvider

        transactions.strings.completedTransactionsHeaderTitle = LocalizedString("accountsAndTransactions.transactions.completedTransactionsHeaderTitle")
        transactions.strings.pendingTransactionsErrorTitle = LocalizedString("accountsAndTransactions.transactions.errors.pending.title")
        transactions.strings.pendingTransactionsErrorSubtitle = LocalizedString("accountsAndTransactions.transactions.errors.pending.subtitle")
        transactions.strings.completedTransactionsErrorTitle = LocalizedString("accountsAndTransactions.transactions.errors.completed.title")
        transactions.strings.completedTransactionsErrorSubtitle = LocalizedString("accountsAndTransactions.transactions.errors.completed.subtitle")

        transactions.showPendingTransactionsOnTop = true
        transactions.showRunningBalance = true
        transactions.accountSummaryProvider = accountSummaryProvider

        transactions.uiDataMapper.sectionHeaderProvider = { date in
            date.formattedPreferred
        }

        transactions.router.didSelectProduct = { navigationController in
            return { [ weak navigationController ] product in
                let rows: [SummaryStackRow] = self.accountStatementSummaryRowsConfiguration(product: product)
                let params = AccountStatementsEntryParams(accountIdentifier: product.account.identifier, summaryStackRows: rows)

                guard let navigationController = navigationController else { return }
                let viewController = RetailAccountStatements.build(navigationController: navigationController, entryParams: params)
                navigationController.pushViewController(viewController, animated: true)
            }
        }

        transactions.creditCardsQuickActionsProvider = creditCardQuickActionsProvider
        transactions.loansQuickActionsProvider = loansQuickActionsProvider
        accountsAndTransactions.transactionDetails.sectionsProvider = transactionDetailSectionProvider
        accountsAndTransactions.transactionDetails.design.styles.headerPillButton = headerPillButtonStyle

        // Apply values back to passed in object
        accountsAndTransactions.transactions = transactions
        accountsAndTransactions.accountDetails = accountDetails
        accountsAndTransactions.accounts = accounts
    }
}

// MARK: Calculated Account List Properties
private extension AccountsAndTransactions {

    static var accountRowProvider: (Product) -> AccountRowItem {
        return { product in
            let account = product.account
            let itemTitle = AccountRowItem.StyleableText.text(account.accountName ?? "") { label in
                label.font = UIFont.overrideSystemFont(ofSize: 14.0, weight: .medium)
                label.textColor = UIColor(light: .dark, dark: .white)
            }
            let itemSubtitle = AccountRowItem.StyleableText.text((account.accountNumber ?? "").masked(uptoLast: 4)) { label in
                label.font = UIFont.overrideSystemFont(ofSize: 12.0, weight: .regular)
                label.textColor = UIColor(light: .greyDark, dark: .greyDark)
            }
            let itemAccessory = AccountRowItem.StyleableText.text(Double.formatAmount(account.currency?.amount ?? "")) { label in
                label.font = UIFont.overrideSystemFont(ofSize: 14.0, weight: .regular)
                label.textColor = UIColor(light: .dark, dark: .white)
            }
            return AccountRowItem(
                icon: nil,
                iconBadge: nil,
                title: itemTitle,
                subtitle: itemSubtitle,
                accessoryText: itemAccessory,
                accessorySubtitle: AccountRowItem.StyleableText.text("", nil),
                caption: nil
            )
        }
    }

    static var creditCardDataProvider: (CreditCard) -> Account {
        { account in
            return Account(
                identifier: account.identifier,
                accountIcon: nil,
                bankName: nil,
                accountName: account.name,
                accountNumber: account.creditCardAccountNumber?.masked(uptoLast: 4, withCharacter: "•"),
                currency: .init(amount: account.bookedBalance ?? "0.00", currencyCode: "USD"),
                type: .creditCard
            )
        }
    }

    /// Order matters
    static var accountsToDisplay: [Accounts.AccountType] {
        return [
            .current,
            .savings,
            .loan,
            .creditCard,
            .termDeposit,
            .investment
        ]
    }
}

// MARK: Calculated Account Details Properties
private extension AccountsAndTransactions {

    static func subtitle(for error: Accounts.Error) -> LocalizedString {
        return LocalizedString("accountsAndTransactions.accounts.errors.noAccounts.subtitle")
    }

    static var accountSummaryProvider: (Product) -> [SummaryStackRow] {
        { product in
            let account = product.account
            let amount = getBalanceAmount(fromProduct: product)
            let options = DesignSystem.Formatting.Options(
                locale: Locale(identifier: "en_US"),
                formattingStyle: .currency,
                showsPlusSign: false,
                enableSignHighlighting: false,
                minFractionDigits: 2,
                maxFractionDigits: 2,
                roundingMode: .down,
                customCode: nil,
                customSymbol: nil,
                abbreviator: nil,
                accessibility: .init(),
                usesGroupingSeparator: true
            )
            let rowAccountName = SummaryStackTextRow(primaryTextRow: account.accountName ?? "")
            let rowAccountNumber = SummaryStackTextRow(secondaryTextRow: account.accountNumber ?? "")
            let rowAmount = SummaryStackTextRow(
                amount: amount,
                amountTextRow: "",
                formattingOptions: options,
                textStyle: DesignSystem.summaryStackViewAmountStyle,
                customSpacingAfter: nil
            )
            return [rowAccountName, rowAccountNumber, rowAmount]
        }
    }

    static func accountStatementSummaryRowsConfiguration(product: Product) -> [SummaryStackRow] {
        let account = product.account
        let amount = getBalanceAmount(fromProduct: product)
        let options = DesignSystem.Formatting.Options(
            locale: Locale(identifier: "en_US"),
            formattingStyle: .currency,
            showsPlusSign: false,
            enableSignHighlighting: false,
            minFractionDigits: 2,
            maxFractionDigits: 2,
            roundingMode: .down,
            customCode: nil,
            customSymbol: nil,
            abbreviator: nil,
            accessibility: .init(),
            usesGroupingSeparator: true
        )
        let rowAccountName = SummaryStackTextRow(primaryTextRow: account.accountName ?? "")
        let rowAccountNumber = SummaryStackTextRow(secondaryTextRow: account.accountNumber ?? "")
        let rowAmount = SummaryStackTextRow(
            amount: amount,
            amountTextRow: "",
            formattingOptions: options,
            textStyle: DesignSystem.summaryStackViewAmountStyle,
            customSpacingAfter: nil
        )
        return [rowAccountName, rowAccountNumber, rowAmount]
    }

    static var headerPillButtonStyle: (Button) -> Void {
        return { button in
            button.normalBackgroundColor = UIColor(light: .aquaLightest, dark: .aquaLightest)
            button.cornerRadius = .medium(roundedCorners: .allCorners)
            button.setTitleColor(UIColor(light: .aquaDarkest, dark: .aquaDarkest), for: .normal)
        }
    }

    static func getBalanceAmount(fromProduct product: Product) -> Decimal {
        var amountString: String?
        switch product {
        case .current(let account):     amountString = account.bookedBalance
        case .savings(let account):     amountString = account.bookedBalance
        case .termDeposit(let account): amountString = account.bookedBalance
        case .loan(let account):        amountString = account.bookedBalance
        case .creditCard(let account):  amountString = account.bookedBalance
        case .general(let account):     amountString = account.bookedBalance
        default:                        amountString = product.account.currency?.amount
        }
        let amount = Decimal(string: amountString ?? "0", locale: Locale(identifier: "en_US"))
        return amount ?? 0
    }

    static var transactionDetailSectionProvider: (Transaction.Item) -> [TransactionDetailsSection] {
        { transaction in
            var transactionDate = transaction.bookingDate
            if let valueDate = transaction.valueDate {
                transactionDate = valueDate
            }
            let sectionRowType = TransactionDetailsTextRow(title: "Type", value: transaction.type)
            let sectionRowDatePosted = TransactionDetailsTextRow(title: "Date Created", value: transactionDate.formattedPreferred)
            let sectionRowDescription = TransactionDetailsTextRow(title: "Description", value: transaction.description)
            let sectionRowStatementDescription = TransactionDetailsTextRow(title: "Statement Description", value: transaction.originalDescription ?? "")
            let sectionRowNotes = TransactionDetailsTextRow(title: "Notes", value: transaction.notes ?? "")
            var rows = [
                sectionRowType,
                sectionRowDatePosted,
                sectionRowDescription,
                sectionRowStatementDescription
            ]
            if transaction.notes != nil {
                rows.append(sectionRowNotes)
            }
            let transactionSection = TransactionDetailsTextSection(
                title: "",
                rows: rows
            )
            return [transactionSection]
        }
    }

    static var quickActionButtonDetails: QuickActionButtonConfiguration {
        QuickActionButtonConfiguration(
            title: "Details",
            icon: UIImage(systemName: "info")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        ) { navigationController in
            return { [ weak navigationController ] product in
                guard let navigationController = navigationController else { return }

                let accountDetailsViewController = AccountDetails.build(
                    navigationController: navigationController,
                    arrangementId: product.account.identifier
                )

                navigationController.pushViewController(accountDetailsViewController, animated: true)
            }
        }
    }

    static var quickActionButtonStatement: QuickActionButtonConfiguration {
        QuickActionButtonConfiguration(
            title: "Statements",
            icon: UIImage(systemName: "doc.text")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        ) { navigationController in
            return { [ weak navigationController ] product in
                let rows: [SummaryStackRow] = self.accountStatementSummaryRowsConfiguration(product: product)
                let params = AccountStatementsEntryParams(accountIdentifier: product.account.identifier, summaryStackRows: rows)

                guard let navigationController = navigationController else { return }

                let accountStatementsViewController = RetailAccountStatements.build(
                    navigationController: navigationController,
                    entryParams: params
                )
                navigationController.pushViewController(accountStatementsViewController, animated: true)
            }
        }
    }

    static func getQuickActionButtonDMIMortgageMakePayment(with loan: Loan) -> QuickActionButtonConfiguration {
        return QuickActionButtonConfiguration(
            title: "Make Payment",
            icon: UIImage(systemName: "dollarsign")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        ) { navigationController in
            return { [ weak navigationController ] _ in
                guard let navigationController = navigationController, let mortgageId = loan.identifier else {
                    return
                }

                DmiMortgageViewModel().initiateDmiMortgageSSO(mortgageId: mortgageId, title: "Make Payment", viewToLoad: .makePayment, on: navigationController)
            }
        }
    }

    static func creditCardQuickActionsProvider(_: CreditCard) -> [QuickActionButtonConfiguration] {
        var quickActionButtonConfiguration = [QuickActionButtonConfiguration]()

        /*let quickActionButtonPay = QuickActionButtonConfiguration(
            title: "Pay",
            icon: UIImage(systemName: "arrow.up.forward")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        ) { navigationController in
            return { [ weak navigationController ] _ in
                guard let navigationController = navigationController else { return }

                let makeATransferViewController = RetailPayment.build(
                    navigationController: navigationController,
                    configuration: RetailPayment.configure()
                )

                navigationController.present(makeATransferViewController, animated: true, completion: nil)
            }
        }*/

        // quickActionButtonConfiguration.append(quickActionButtonPay)
        quickActionButtonConfiguration.append(quickActionButtonDetails)
        quickActionButtonConfiguration.append(quickActionButtonStatement)

        return quickActionButtonConfiguration
    }

    static func loansQuickActionsProvider(loan: Loan) -> [QuickActionButtonConfiguration] {
        var quickActionButtonConfiguration = [QuickActionButtonConfiguration]()

        quickActionButtonConfiguration.append(quickActionButtonDetails)
        quickActionButtonConfiguration.append(quickActionButtonStatement)

        if LoanAccountProvider.isMortgageLoan(loan.productTypeName) {
            quickActionButtonConfiguration.append(getQuickActionButtonDMIMortgageMakePayment(with: loan))
        }

        return quickActionButtonConfiguration
    }

    static var creditCardAccountProvider: (CreditCard) -> [AccountDetailsSection] {
        return { CreditCardProvider.getDetails(for: $0) }
    }
    static var currentAccountProvider: (CurrentAccount) -> [AccountDetailsSection] {
        return { CurrentAccountProvider.getDetails(for: $0) }
    }
    static var generalAccountProvider: (GeneralAccount) -> [AccountDetailsSection] {
        return { GeneralAccountProvider.getDetails(for: $0) }
    }
    static var investmentAccountProvider: (InvestmentAccount) -> [AccountDetailsSection] {
        return { InvestmentAccountProvider.getDetails(for: $0) }
    }
    static var loanAccountsProvider: (Loan) -> [AccountDetailsSection] {
        return { LoanAccountProvider.getDetails(for: $0) }
    }
    static var savingsAccountProvider: (SavingsAccount) -> [AccountDetailsSection] {
        return { SavingsAccountProvider.getDetails(for: $0) }
    }
    static var termDepositAccountProvider: (TermDeposit) -> [AccountDetailsSection] {
        return { TermDepositAccountProvider.getDetails(for: $0) }
    }
}
