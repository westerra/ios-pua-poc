//
//  MockAccountSummaryResponse.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

func mockAccountSummaryResponse() -> AccountSummaryResponse {
    guard let accountSummaryResponse = try? JSONDecoder().decode(AccountSummaryResponse.self, from: jsonString.data(using: .utf8) ?? Data()) else {
        fatalError("Failed to mock data")
    }

    return accountSummaryResponse
}

private let jsonString = """
{
    "currentAccounts": {
        "name": "Current Accounts",
        "aggregatedBalance": {},
        "products": [
            {
                "additions": {
                    "allowFromP2P": "true",
                    "allowTransferTo": "true",
                    "accountCode": "00039236070008",
                    "allowToP2P": "true",
                    "allowTransferFrom": "true",
                    "allowToA2A": "true",
                    "isPrimaryBillpayAccount": "false",
                    "allowFromA2A": "true",
                    "payverisTransferTo": "true",
                    "allowToBILLPAY": "false",
                    "allowFromBILLPAY": "true",
                    "payverisTransferFrom": "true"
                },
                "id": "d3530554-ac1f-4b93-a49f-a84ac7a3c379",
                "name": "SMART MONEY CHECKING",
                "displayName": "SMART MONEY CHECKING",
                "crossCurrencyAllowed": true,
                "productKindName": "Current Account",
                "bankAlias": "SMART MONEY CHECKING",
                "sourceId": "CORE",
                "visible": true,
                "accountOpeningDate": "2022-07-08T18:00:00Z",
                "lastUpdateDate": "2024-04-15T18:00:00Z",
                "userPreferences": {
                    "alias": "",
                    "visible": true,
                    "favorite": false
                },
                "state": {
                    "externalStateId": "Active",
                    "state": "Active"
                },
                "bookedBalance": "1.86000",
                "availableBalance": "1.86000",
                "BBAN": "•••••••••0708",
                "currency": "USD",
                "bankBranchCode": "302075319",
                "accruedInterest": 0,
                "debitCardsItems": [],
                "accountHolderNames": "JANE",
                "minimumRequiredBalance": 0,
                "accountHolderAddressLine1": "3700 ALAMEDA AVE",
                "town": "DENVER",
                "postCode": "80209",
                "creditAccount": true,
                "debitAccount": true,
                "accountHolderCountry": "US",
                "unmaskableAttributes": [
                    "BBAN"
                ]
            }
        ]
    },
    "savingsAccounts": {
        "name": "Savings Accounts",
        "aggregatedBalance": {},
        "products": [
            {
                "additions": {
                    "allowFromP2P": "true",
                    "allowTransferTo": "true",
                    "accountCode": "00039236070000",
                    "allowToP2P": "true",
                    "allowTransferFrom": "true",
                    "allowToA2A": "true",
                    "isPrimaryBillpayAccount": "true",
                    "allowFromA2A": "true",
                    "payverisTransferTo": "true",
                    "allowToBILLPAY": "false",
                    "allowFromBILLPAY": "false",
                    "payverisTransferFrom": "true"
                },
                "id": "5f74f9bc-1999-4d31-ad94-78fb9f0c7e3a",
                "name": "PRIME SHARE",
                "displayName": "PRIME SHARE",
                "crossCurrencyAllowed": true,
                "productKindName": "Savings Account",
                "productTypeName": "Prime Share",
                "bankAlias": "PRIME SHARE",
                "sourceId": "CORE",
                "visible": true,
                "accountOpeningDate": "2022-07-08T18:00:00Z",
                "lastUpdateDate": "2024-04-11T18:00:00Z",
                "userPreferences": {
                    "visible": true,
                    "favorite": false
                },
                "state": {
                    "externalStateId": "Active",
                    "state": "Active"
                },
                "bookedBalance": "5.77000",
                "availableBalance": "0.77000",
                "accruedInterest": 0,
                "BBAN": "•••••••••0700",
                "currency": "USD",
                "bankBranchCode": "302075319",
                "minimumRequiredBalance": 5,
                "accountHolderNames": "JANE",
                "accountHolderAddressLine1": "3700 ALAMEDA AVE",
                "town": "DENVER",
                "postCode": "80209",
                "accountHolderCountry": "US",
                "creditAccount": true,
                "debitAccount": true,
                "unmaskableAttributes": [
                    "BBAN"
                ]
            },
            {
                "additions": {
                    "allowFromP2P": "true",
                    "allowTransferTo": "true",
                    "accountCode": "00039236070016",
                    "allowToP2P": "true",
                    "allowTransferFrom": "true",
                    "allowToA2A": "true",
                    "isPrimaryBillpayAccount": "false",
                    "allowFromA2A": "true",
                    "payverisTransferTo": "true",
                    "allowToBILLPAY": "false",
                    "allowFromBILLPAY": "false",
                    "payverisTransferFrom": "true"
                },
                "id": "c584ec35-bd85-4734-b344-85f5d880ff74",
                "name": "MONEY MARKET ACCOUNT",
                "displayName": "MONEY MARKET ACCOUNT",
                "crossCurrencyAllowed": true,
                "productKindName": "Savings Account",
                "productTypeName": "Preferred Money Market",
                "bankAlias": "MONEY MARKET ACCOUNT",
                "sourceId": "CORE",
                "visible": true,
                "accountOpeningDate": "2022-10-04T18:00:00Z",
                "lastUpdateDate": "2024-04-15T18:00:00Z",
                "state": {
                    "externalStateId": "Active",
                    "state": "Active"
                },
                "bookedBalance": "11.89000",
                "availableBalance": "11.89000",
                "accruedInterest": 0,
                "BBAN": "•••••••••0716",
                "currency": "USD",
                "bankBranchCode": "302075319",
                "minimumRequiredBalance": 0,
                "accountHolderNames": "JANE",
                "accountHolderAddressLine1": "3700 ALAMEDA AVE",
                "town": "DENVER",
                "postCode": "80209",
                "accountHolderCountry": "US",
                "creditAccount": true,
                "debitAccount": true,
                "unmaskableAttributes": [
                    "BBAN"
                ]
            }
        ]
    },
    "termDeposits": {
        "name": "Term Deposits",
        "aggregatedBalance": {},
        "products": []
    },
    "loans": {
        "name": "Loans",
        "aggregatedBalance": {},
        "products": [
            {
                "additions": {
                    "minimumPaymentDueDate": "2024-04-25T00:00:00",
                    "allowTransferTo": "true",
                    "accountCode": "00039236070001",
                    "allowToP2P": "true",
                    "remainingCredit": "500.0",
                    "allowToA2A": "true",
                    "payverisTransferFrom": "true",
                    "allowFromP2P": "true",
                    "allowTransferFrom": "true",
                    "isPrimaryBillpayAccount": "false",
                    "allowFromA2A": "true",
                    "payverisTransferTo": "true",
                    "allowToBILLPAY": "false",
                    "creditLimit": "500.0",
                    "allowFromBILLPAY": "false"
                },
                "id": "5515ef3e-1f50-47b9-9a34-26ee6d8645cb",
                "name": "LINE OF CREDIT",
                "displayName": "Line Of Credit",
                "crossCurrencyAllowed": true,
                "productKindName": "Loan",
                "productTypeName": "Line Of Credit",
                "bankAlias": "Line Of Credit",
                "sourceId": "CORE",
                "visible": true,
                "accountOpeningDate": "2023-02-22T19:00:00Z",
                "lastUpdateDate": "2023-11-28T19:00:00Z",
                "state": {
                    "externalStateId": "Active",
                    "state": "Active"
                },
                "interestDetails": {},
                "bookedBalance": "0.00000",
                "currency": "USD",
                "productNumber": "129",
                "accountInterestRate": 12.95,
                "termUnit": "M",
                "termNumber": 0,
                "monthlyInstalmentAmount": 0,
                "accruedInterest": 0,
                "accountHolderNames": "JANE",
                "creditAccount": true,
                "debitAccount": true,
                "BBAN": "2000392360701",
                "unmaskableAttributes": []
            },
            {
                "additions": {
                    "minimumPaymentDueDate": "2024-04-25T00:00:00",
                    "allowTransferTo": "true",
                    "accountCode": "00039236070003",
                    "allowToP2P": "true",
                    "remainingCredit": "4997.97",
                    "allowToA2A": "true",
                    "payverisTransferFrom": "true",
                    "allowFromP2P": "true",
                    "allowTransferFrom": "true",
                    "isPrimaryBillpayAccount": "false",
                    "allowFromA2A": "true",
                    "payverisTransferTo": "true",
                    "allowToBILLPAY": "false",
                    "creditLimit": "5000.0",
                    "allowFromBILLPAY": "false"
                },
                "id": "8f2f04fa-7747-48ca-bc72-d1d05bf7bef3",
                "name": "HOME EQUITY SELECT LINE",
                "displayName": "HELOC Select",
                "crossCurrencyAllowed": true,
                "productKindName": "Loan",
                "productTypeName": "HELOC Select",
                "bankAlias": "HELOC Select",
                "sourceId": "CORE",
                "visible": true,
                "accountOpeningDate": "2023-02-22T19:00:00Z",
                "lastUpdateDate": "2024-03-22T18:00:00Z",
                "state": {
                    "externalStateId": "Active",
                    "state": "Active"
                },
                "interestDetails": {},
                "bookedBalance": "2.03000",
                "currency": "USD",
                "productNumber": "144",
                "accountInterestRate": 8.99,
                "termUnit": "M",
                "termNumber": 0,
                "monthlyInstalmentAmount": 0.01,
                "accruedInterest": 0,
                "accountHolderNames": "JANE",
                "maturityDate": "2043-02-22T19:00:00Z",
                "creditAccount": true,
                "debitAccount": true,
                "BBAN": "2000392360703",
                "unmaskableAttributes": []
            }
        ]
    },
    "creditCards": {
        "name": "Credit Cards",
        "aggregatedBalance": {},
        "products": [
            {
                "additions": {
                    "minimumPaymentDueDate": "2024-04-25T00:00:00",
                    "allowTransferTo": "true",
                    "accountCode": "00039236070002",
                    "allowToP2P": "true",
                    "remainingCredit": "4999.88",
                    "allowToA2A": "true",
                    "payverisTransferFrom": "true",
                    "allowFromP2P": "true",
                    "allowTransferFrom": "true",
                    "isPrimaryBillpayAccount": "false",
                    "allowFromA2A": "true",
                    "payverisTransferTo": "true",
                    "allowToBILLPAY": "false",
                    "creditLimit": "5000.0",
                    "allowFromBILLPAY": "false"
                },
                "id": "487966ec-b9eb-4ba7-9403-7d6eb61b0fd5",
                "name": "VISA SIGNATURE CREDIT CARD",
                "displayName": "Visa Signature Credit Card",
                "crossCurrencyAllowed": true,
                "productKindName": "Credit Card",
                "productTypeName": "Visa Signature Credit Card",
                "bankAlias": "Visa Signature Credit Card",
                "sourceId": "CORE",
                "visible": true,
                "accountOpeningDate": "2023-02-22T19:00:00Z",
                "lastUpdateDate": "2024-03-20T18:00:00Z",
                "state": {
                    "externalStateId": "Active",
                    "state": "Active"
                },
                "interestDetails": {},
                "bookedBalance": "0.00000",
                "availableBalance": "4999.88000",
                "creditLimit": "5000.00000",
                "number": "•••••••••0702",
                "currency": "USD",
                "creditCardAccountNumber": "2000392360702",
                "remainingCredit": 4999.88,
                "outstandingPayment": 0.12,
                "minimumPayment": 0.12,
                "minimumPaymentDueDate": "2024-04-25T18:00:00Z",
                "accountInterestRate": 15.15,
                "accountHolderNames": "JANE",
                "accruedInterest": 0,
                "unmaskableAttributes": []
            }
        ]
    },
    "debitCards": {
        "name": "Debit Cards",
        "aggregatedBalance": {},
        "products": []
    },
    "investmentAccounts": {
        "name": "Investment Accounts",
        "aggregatedBalance": {},
        "products": []
    },
    "customProductKinds": []
}
"""
