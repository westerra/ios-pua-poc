//
//  MockProfileResponse.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

func mockProfileResponse() -> ProfileResponse {
    guard let profileResponse = try? JSONDecoder().decode(ProfileResponse.self, from: jsonString.data(using: .utf8) ?? Data()) else {
        fatalError("Failed to mock data")
    }

    return profileResponse
}

private let jsonString = """
 {
   "fullName": "JANE DOE TEST",
   "phone-addresses": [
     {
       "key": "Home",
       "type": "Home",
       "primary": true,
       "number": "8883334444"
     },
     {
       "key": "Mobile",
       "type": "Mobile",
       "primary": false,
       "number": "8883334444"
     }
   ],
   "electronic-addresses": [
     {
       "key": "Email",
       "type": "Email",
       "primary": true,
       "address": "test@westerracu.com"
     }
   ],
   "postal-addresses": [
     {
       "key": "RESIDENTIAL",
       "type": "RESIDENTIAL",
       "primary": true,
       "buildingNumber": "3700 E ALAMEDA AVE",
       "townName": "DENVER",
       "postalCode": "80209-3100",
       "countrySubDivision": "CO",
       "country": "US"
     }
   ],
   "additions": {
     "customerCode": "3923607",
     "SSN": "999224444"
   }
 }
"""
