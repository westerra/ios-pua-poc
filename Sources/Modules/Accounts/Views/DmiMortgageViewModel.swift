//
//  DmiMortgageViewModel.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import Foundation
import ProgressHUD

struct DmiMortgageViewModel {

    func initiateDmiMortgageSSO(mortgageId: String, title: String, viewToLoad: DmiMortgageViewType, on navigationController: UINavigationController) {
        let ssoDmiMortgageEndpoint = ServerEndpoint.getDmiMortgageEndpoint(with: mortgageId)

        ProgressHUD.animate()
        ssoDmiMortgageEndpoint.getSSOToken { ssoToken in
            ProgressHUD.dismiss()

            guard !ssoToken.ssourl.isEmpty else {
                return
            }

            DispatchQueue.main.async {
                let dmiMortgageVC = DmiMortgageView(ssoKey: ssoToken.ssourl, title: title, viewToLoad: viewToLoad)
                navigationController.pushViewController(dmiMortgageVC, animated: true)
            }
        }
    }
}
