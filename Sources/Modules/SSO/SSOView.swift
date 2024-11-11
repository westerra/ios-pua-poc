//
//  SSOView.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Backbase
import Foundation
import UIKit
import WebKit

class SSOView: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var endpoint: Endpoint

    private var ssoViewModel: SSOViewModelProtocol?
    lazy var progressCircle = SSOActivityIndicator(style: .large)

    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        return webView
    }()

    /// Get a instance of SSOView attached to a navigation controller
    /// - Parameter endpoint: Endpoint to load after retrieving SSOToken
    /// - Returns: Closure attaching the SSOView pointed at the specified endpoint to the active navigation
    static func view(for endpoint: Endpoint, with title: String) -> (UINavigationController) -> Void {
        return { navigationController in
            SessionHandler.shared.handleSessionExpired {
                let ssoView = SSOView(for: endpoint)
                ssoView.title = title
                navigationController.pushViewController(ssoView, animated: true)
            }
        }
    }

    private init(for endpoint: Endpoint) {
        self.endpoint = endpoint
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
        setupUI()
    }

    func callToViewModelForUIUpdate() {
        ssoViewModel = SSOViewModel.create(with: self.endpoint) {
            self.updateDataSource()
        }
    }

    func setupUI() {
        view.backgroundColor = .white

        progressCircle.center = self.view.center

        view.addSubview(webView)
        view.addSubview(progressCircle)

        progressCircle.startAnimating()
        setUpProgressCircleConstraints()

        setUpWebViewConstraints()
    }

    func setUpProgressCircleConstraints() {
        NSLayoutConstraint.activate([
            progressCircle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressCircle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            progressCircle.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            progressCircle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    func setUpWebViewConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    func updateDataSource() {
        guard let token = ssoViewModel?.ssoToken.ssourl else {
            return
        }

        // IMPORTANT: Request guard cannot be combined with the above token guard,
        // as we need to wait for the SSO URL to be retrieved first from the API.
        guard let request = endpoint.authenticate(with: token).request else {
            return
        }

        webView.load(request)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressCircle.stopAnimating()
    }
}
