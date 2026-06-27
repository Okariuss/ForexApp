//
//  RatesRepository.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

public protocol RatesRepository: Sendable {
    func fetchRates(
        baseCurrency: CurrencyCode
    ) async throws -> [ExchangeRate]
}
