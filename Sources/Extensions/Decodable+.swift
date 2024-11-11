//
//  Decodable+.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import Foundation

extension Decodable {
    static func parse(jsonFile: String) -> Self? {
        if let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let output = try? JSONDecoder().decode(self, from: data) {
                return output
        }

        return nil
    }
}
