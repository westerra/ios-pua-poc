//
//  WCUWebView.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WCUWebView: UIViewController {

    var urlToLoad: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false

        let webview = WKWebView()
        if #available(iOS 16.4, *) {
            webview.isInspectable = true
        }
        webview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        webview.load(URLRequest(url: urlToLoad) as URLRequest)

        self.view.addSubview(webview)
    }
}
