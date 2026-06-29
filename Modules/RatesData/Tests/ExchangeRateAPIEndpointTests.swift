//
//  ExchangeRateAPIEndpointTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import NetworkingCore
@testable import RatesData
import RatesDomain
import Testing

struct ExchangeRateAPIEndpointTests {
    @Test func latestEndpointIncludesBaseCurrency() throws {
        let baseCurrency = try CurrencyCode("usd")

        let sut = ExchangeRateAPIEndpoint
            .latest(baseCurrency: baseCurrency)
            .endpoint

        #expect(sut.path == "v6/latest/USD")
        #expect(sut.method == .get)
        #expect(sut.queryItems.isEmpty)
        #expect(sut.headers.isEmpty)
    }
}
