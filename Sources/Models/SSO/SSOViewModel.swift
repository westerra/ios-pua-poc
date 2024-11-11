//
//  SSOViewModel.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

class SSOViewModel: NSObject {

    var bindToController: () -> Void
    var ssoToken: SSOToken! {
        didSet {
            DispatchQueue.main.sync {
                self.bindToController()
            }
        }
    }

    init(_ bindToController: @escaping () -> Void) {
        self.bindToController = bindToController
    }

    static func create(with endpoint: Endpoint, _ bindToController: @escaping () -> Void) -> SSOViewModelProtocol? {
        switch endpoint.type {
        case .amplifi:
            return SSOAmplifiViewModel(bindToController)
        case .payveris:
            return SSOPayverisViewModel(bindToController)
        case .server:
            return nil
        }
    }
}
