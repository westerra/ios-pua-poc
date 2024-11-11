//
//  MockAccountService.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

class MockAccountService: BTPServiceProtocol {
    private let mockProfile = mockProfileResponse()
    private let mockCurrentAccounts = mockAccountSummaryResponse().currentAccounts?.products ?? []

    func fetchProfile() async throws -> ProfileResponse {
        return try await withCheckedThrowingContinuation { continuation in
            continuation.resume(with: .success(mockProfile))
        }
    }

    func fetchAccounts() async throws -> [BBAccount] {
        return try await withCheckedThrowingContinuation { continuation in
            continuation.resume(with: .success(mockCurrentAccounts))
        }
    }

    func createAccount(with params: CreateAccountParams) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            continuation.resume(with: .success(()))
        }
    }
}
