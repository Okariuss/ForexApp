//
//  RatesCacheStoring.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain

public protocol RatesCacheStoring: Sendable {
    func loadRates(
        for baseCurrency: CurrencyCode
    ) async throws -> [ExchangeRate]?

    func saveRates(
        _ rates: [ExchangeRate],
        for baseCurrency: CurrencyCode
    ) async throws
}
