//
//  SSOAmplifiViewModel.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import Foundation

class SSOAmplifiViewModel: SSOViewModel, SSOViewModelProtocol {

    override required init(_ bindToController: @escaping () -> Void) {
        super.init(bindToController)

        ServerEndpoint.ssoAmplifi.getSSOToken { ssoToken in
            self.ssoToken = ssoToken
        }
    }
}
