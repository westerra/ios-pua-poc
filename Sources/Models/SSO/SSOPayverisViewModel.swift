//
//  SSOPayverisViewModel.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

class SSOPayverisViewModel: SSOViewModel, SSOViewModelProtocol {

    override required init(_ bindToController: @escaping () -> Void) {
        super.init(bindToController)

        ServerEndpoint.ssoPayveris.getSSOToken { ssoToken in
            self.ssoToken = SSOToken(ssourl: "?artifactId=" + ssoToken.ssourl)
        }
    }
}
