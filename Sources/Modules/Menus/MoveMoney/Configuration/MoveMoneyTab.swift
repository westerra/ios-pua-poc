//
//  MoveMoneyTab.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import Resolver
import RetailJourneyCommon
import RetailMoreJourney
import RetailPaymentJourney
import RetailUpcomingPaymentsJourney

struct MoveMoneyTab {
    let retailPaymentConfig: RetailPayment.Configuration

    // Configure Move Money Tab
    func configure() {
        var paymentHubConfiguration = More.Configuration()
        paymentHubConfiguration.strings.navigationTitle = LocalizedString("move.money.title")
        paymentHubConfiguration.tabItem = getTabItem()
        paymentHubConfiguration.menu = getMenuItems()
        Resolver.register(name: "payment-hub-menu") { paymentHubConfiguration }
    }
}

private extension MoveMoneyTab {
    func getTabItem() -> RetailJourneyCommon.TabItem {
        return RetailJourneyCommon.TabItem(
            title: LocalizedString("move.money"),
            image: UIImage.moveMoney,
            selectedImage: UIImage.moveMoney
        )
    }

    func getMenuItems() -> More.Menu {
        return More.Menu(
            showIcons: true,
            sections: [
                More.MenuSection(items: [makeATransferMenuItem]),
                More.MenuSection(items: [transferToMemberMenuItem]),
                More.MenuSection(items: [scheduledPaymentMenuItem]),
                More.MenuSection(items: [billPayDashboardItem]),
                More.MenuSection(items: [paymentActivityItem]),
                More.MenuSection(items: [p2pItem])
            ]
        )
    }

    var makeATransferMenuItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("make.a.transfer.title"),
            icon: .makeATransfer,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in

                let makeATransferViewController = RetailPayment.build(
                    navigationController: navigationController,
                    configuration: RetailPayment.configure(self.retailPaymentConfig)
                )

                navigationController.pushViewController(makeATransferViewController, animated: true)
            }
        )
    }

    var transferToMemberMenuItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("transfer.to.member.title"),
            icon: .makeATransfer,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                let transferToContactViewController = RetailPayment.build(
                    navigationController: navigationController,
                    configuration: RetailPayment.configure(self.retailPaymentConfig, isP2P: true)
                )

                navigationController.pushViewController(transferToContactViewController, animated: true)
            }
        )
    }

    var scheduledPaymentMenuItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("scheduled.transfers.title"),
            icon: .scheduledTransfers,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: { navigationController in
                let scheduledPaymentsVC = UpcomingPayments.build(navigationController: navigationController)
                navigationController.pushViewController(scheduledPaymentsVC, animated: true)
            }
        )
    }

    var billPayDashboardItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("billpaydashboard.title"),
            icon: .payBills,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: SSOView.view(for: PayverisEndpoint.showDashboard, with: LocalizedString("billpaydashboard.title").value)
        )
    }

    var payBillsItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("paybills.title"),
            icon: .payBills,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: SSOView.view(for: PayverisEndpoint.oneTimePayment, with: LocalizedString("paybills.title").value)
        )
    }

    var paymentActivityItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("payactivity.title"),
            icon: .paymentActivity,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: SSOView.view(for: PayverisEndpoint.viewPaymentHistory, with: LocalizedString("payactivity.title").value)
        )
    }

    var p2pItem: More.MenuItem {
        return More.MenuItem(
            title: LocalizedString("p2p.title"),
            icon: .p2p,
            iconBackgroundColor: .clear,
            iconTintColor: .clear,
            action: SSOView.view(for: PayverisEndpoint.sendMoney, with: LocalizedString("p2p.title").value)
        )
    }
}
