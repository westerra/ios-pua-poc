//
//  SSOActivityIndicator.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import UIKit

class SSOActivityIndicator: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        hidesWhenStopped = true
        color = .dark
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
