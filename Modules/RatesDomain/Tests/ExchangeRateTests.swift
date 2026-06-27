//
//  ExchangeRateTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import RatesDomain
import Testing

struct ExchangeRateTests {
    @Test func validValueCreatesExchangeRates() throws {
        let baseCurrency = try CurrencyCode("USD")
        let quoteCurrency = try CurrencyCode("TRY")
        let updatedAt = Date(timeIntervalSince1970: 1_700_000_000)
        let value = try #require(Decimal(string: "50.50"))

        let sut = try ExchangeRate(
            baseCurrency: baseCurrency,
            quoteCurrency: quoteCurrency,
            value: value,
            updatedAt: updatedAt
        )

        #expect(sut.baseCurrency == baseCurrency)
        #expect(sut.quoteCurrency == quoteCurrency)
        #expect(sut.value == value)
        #expect(sut.updatedAt == updatedAt)
    }

    @Test(
        arguments: [
            Decimal.zero,
            Decimal(-1),
        ]
    )
    func nonPositiveValueThrowsError(_ value: Decimal) throws {
        let baseCurrency = try CurrencyCode("USD")
        let quoteCurrency = try CurrencyCode("TRY")

        #expect(throws: ExchangeRateError.self) {
            try ExchangeRate(
                baseCurrency: baseCurrency,
                quoteCurrency: quoteCurrency,
                value: value,
                updatedAt: .now
            )
        }
    }
}
