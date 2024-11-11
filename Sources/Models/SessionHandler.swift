//
//  SessionHandler.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseIdentity
import FirebaseAnalytics
import Foundation
import IdentityAuthenticationJourney
import Resolver

class SessionHandler: NSObject, UIGestureRecognizerDelegate {
    var completion: () -> Void = {}
    private let logEventName = "session_handler_error"

    static var shared: SessionHandler = SessionHandler()
    var shared: SessionHandler {
        Self.shared
    }

    static var hasUserTappedTheApp = false
    var hasUserTappedTheApp: Bool {
        Self.hasUserTappedTheApp
    }

    func resetInteractions() {
        Self.hasUserTappedTheApp = false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        Self.hasUserTappedTheApp = true
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SessionHandler: AuthClientDelegate {
    func sessionState(_ newSessionState: SessionState, withError error: Error!) {
        if let error = error {
            Analytics.logEvent(logEventName, parameters: [
                "error": error.localizedDescription
            ])
        }

        switch newSessionState {
        case .none:  handleSessionExpired()
        case .valid: return
        default:     return
        }
    }

    func handleSessionExpired(completion: @escaping () -> Void = {}) {
        self.completion = completion

        guard self.hasUserTappedTheApp, let authClient = Backbase.authClient() as? BBIDAuthClient
        else { return }

        authClient.refreshAccessToken(with: self, headers: nil, scope: nil)
    }
}

extension SessionHandler: OAuth2AuthClientDelegate {
    func oAuth2AuthClientTokensDidInvalidate() {
        DispatchQueue.main.async {
            let useCase: AuthenticationUseCase = Resolver.resolve()
            useCase.endSession(callback: nil)
            Analytics.logEvent(self.logEventName, parameters: [
                "reason": "oAuth2AuthClientTokensDidInvalidate"
            ])
        }
    }

    func oAuth2AuthClientAccessTokenDidRefresh(with headers: [String: String]) {
        DispatchQueue.main.async {
            self.resetInteractions()
            self.completion()
            self.completion = {}
        }
    }

    func oAuth2AuthClientAccessTokenDidFailToRefresh(with error: Error) {
        DispatchQueue.main.async {
            let useCase: AuthenticationUseCase = Resolver.resolve()
            useCase.endSession(callback: nil)
            Analytics.logEvent(self.logEventName, parameters: [
                "reason": "oAuth2AuthClientAccessTokenDidFailToRefresh",
                "error": error.localizedDescription
            ])
        }
    }
}
