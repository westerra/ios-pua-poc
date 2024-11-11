//
//  CreateAccountParams.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

struct CreateAccountParams {
    var selectedProduct: WCUProduct
    var fundingAccount: BBAccount
    var transferAmount: Int
    var transferAmountNote: String
}
