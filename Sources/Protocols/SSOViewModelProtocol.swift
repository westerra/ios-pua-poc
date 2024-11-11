//
//  SSOViewModelProtocol.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation

protocol SSOViewModelProtocol {
    var bindToController: () -> Void { get set }
    var ssoToken: SSOToken! { get set }

    init(_ bindToController: @escaping () -> Void)
}
