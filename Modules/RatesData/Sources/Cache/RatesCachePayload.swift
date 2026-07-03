//
//  RatesCachePayload.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain

struct RatesCachePayload: Codable {
    static let currentVersion = 1

    let version: Int
    let baseCurrency: String
    let rates: [CachedExchangeRate]

    init(
        baseCurrency: CurrencyCode,
        rates: [ExchangeRate]
    ) {
        version = Self.currentVersion
        self.baseCurrency = baseCurrency.value
        self.rates = rates.map(CachedExchangeRate.init)
    }

    func makeRates(
        for requestedBaseCurrency: CurrencyCode
    ) throws -> [ExchangeRate] {
        guard
            version == Self.currentVersion,
            baseCurrency == requestedBaseCurrency.value,
            !rates.isEmpty
        else {
            throw RatesCachePayloadError.invalidPayload
        }

        return try rates.map {
            try $0.makeExchangeRate(
                baseCurrency: requestedBaseCurrency
            )
        }
    }
}

struct CachedExchangeRate: Codable {
    let quoteCurrency: String
    let value: Decimal
    let updatedAt: Date

    init(rate: ExchangeRate) {
        quoteCurrency = rate.quoteCurrency.value
        value = rate.value
        updatedAt = rate.updatedAt
    }

    func makeExchangeRate(
        baseCurrency: CurrencyCode
    ) throws -> ExchangeRate {
        try ExchangeRate(
            baseCurrency: baseCurrency,
            quoteCurrency: CurrencyCode(quoteCurrency),
            value: value,
            updatedAt: updatedAt
        )
    }
}

enum RatesCachePayloadError: Error {
    case invalidPayload
}
