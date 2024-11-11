//
//  MockBehindThePinCoordinator.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

final class MockBehindThePinCoordinator: BehindThePinCoordinator {
    private(set) var currentScreen: BehindThePinScreen?
    private(set) var popIsCalled = false
    private(set) var dismissSheetIsCalled = false
    private(set) var popToHostViewControllerIsCalled = false

    func push(to screen: BehindThePinScreen) {
        currentScreen = screen
    }

    func pop() {
        popIsCalled = true
    }

    func presentSheet(_ screen: BehindThePinScreen) {
        currentScreen = screen
    }
    
    func dismissSheet() {
        dismissSheetIsCalled = true
    }
    
    func popToHostViewController() {
        popToHostViewControllerIsCalled = true
    }
}
