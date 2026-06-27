//
//  ExchangeRate.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

public enum ExchangeRateError: Error, Equatable {
    case invalidValue
}

public struct ExchangeRate: Equatable, Sendable {
    public let baseCurrency: CurrencyCode
    public let quoteCurrency: CurrencyCode
    public let value: Decimal
    public let updatedAt: Date

    public init(
        baseCurrency: CurrencyCode,
        quoteCurrency: CurrencyCode,
        value: Decimal,
        updatedAt: Date
    ) throws {
        guard value > .zero else {
            throw ExchangeRateError.invalidValue
        }

        self.baseCurrency = baseCurrency
        self.quoteCurrency = quoteCurrency
        self.value = value
        self.updatedAt = updatedAt
    }
}
