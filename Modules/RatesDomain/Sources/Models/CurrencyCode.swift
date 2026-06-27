//
//  CurrencyCode.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

public enum CurrencyCodeError: Error, Codable {
    case invalidValue
}

public struct CurrencyCode: Hashable, Sendable {
    public let value: String

    public init(_ value: String) throws {
        let normalizedValue = value.uppercased()

        guard Self.isValid(normalizedValue) else {
            throw CurrencyCodeError.invalidValue
        }

        self.value = normalizedValue
    }

    private static func isValid(_ value: String) -> Bool {
        value.count == 3 && value.allSatisfy { character in
            ("A" ... "Z").contains(character)
        }
    }
}
