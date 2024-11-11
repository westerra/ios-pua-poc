//
//  BehindThePinCoordinatorViewModel.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import FlowStacks
import Foundation

@MainActor
protocol BehindThePinCoordinator: ObservableObject {
    func push(to screen: BehindThePinScreen)
    func pop()
    func presentSheet(_ screen: BehindThePinScreen)
    func dismissSheet()
    func popToHostViewController()
}

final class BehindThePinCoordinatorViewModel: BehindThePinCoordinator {
    @Published var routes: Routes<BehindThePinScreen>

    private weak var hostViewController: UIViewController?

    init(
        routes: Routes<BehindThePinScreen> = [.root(.exploreWesterraProducts)],
        hostViewController: UIViewController? = nil
    ) {
        self.routes = routes
        self.hostViewController = hostViewController
    }

    func push(to screen: BehindThePinScreen) {
        routes.push(screen)
    }

    func pop() {
        _ = routes.popLast()
    }

    func presentSheet(_ screen: BehindThePinScreen) {
        routes.presentSheet(screen)
    }

    func dismissSheet() {
        routes.dismiss()
    }

    func popToHostViewController() {
        guard let hostViewController else { return }
        hostViewController.navigationController?.popToViewController(hostViewController, animated: true)
    }
}
