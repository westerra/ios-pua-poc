//
//  DmiMortgageView.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import AppCenterAnalytics
import Backbase
import UIKit
import WebKit

enum DmiMortgageViewType {
    case loanDetails
    case makePayment
}

class DmiMortgageView: UIViewController, WKUIDelegate, WKNavigationDelegate {

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

    private var ssoKey: String
    private var viewToLoad: DmiMortgageViewType

    init(ssoKey: String, title: String, viewToLoad: DmiMortgageViewType) {
        self.ssoKey = ssoKey
        self.viewToLoad = viewToLoad

        super.init(nibName: nil, bundle: nil)

        self.title = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        view.addSubview(webView)
        setUpWebViewConstraints()

        loadMakePaymentPage()
    }

    func setUpWebViewConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    func loadMakePaymentPage() {
        let javascript = getJavaScript()

        webView.evaluateJavaScript(javascript) { _, error in
            if let error = error {
                Analytics.trackEvent("Error loading DMI mortgage domain", withProperties: ["Error": error.localizedDescription])
                self.handleError()
            }
        }
    }

    private func getJavaScript() -> String {
        guard let dmiMortgageDomain = Backbase.configuration().custom["dmiMortgageDomain"] as? String else {
            Analytics.trackEvent("Error getting DMI mortgage domain")
            return ""
        }

        return """
        function postDmiForm() {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '\(dmiMortgageDomain)/SSO/X61Login.aspx';
            var params = {
                KEY: '\(ssoKey)',
                \(viewToLoad == .makePayment ? "DisplayPage: 'OneTimeScheduledPayment'," : "")
            };

            for (var i in params) {
                if (params.hasOwnProperty(i)) {
                    var input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = i;
                    input.value = params[i];
                    form.appendChild(input);
                }
            }

            document.body.appendChild(form);
            form.submit();
        }

        postDmiForm();
        """
    }

    private func handleError() {
        let alert = UIAlertController(title: "Network Failure", message: "Oops! Something went wrong. Please try again.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelAction)

        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.loadMakePaymentPage()
        }
        alert.addAction(retryAction)

        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController?.present(alert, animated: true)
        }
    }
}
