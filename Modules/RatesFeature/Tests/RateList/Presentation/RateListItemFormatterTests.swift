//
//  RateListItemFormatterTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import AppMacros
import Foundation
import RatesDomain
@testable import RatesFeature
import Testing

@MainActor
struct RateListItemFormatterTests {
    @Test func formatterUsesProvidedLocale() throws {
        let formatter = try RateListItemFormatter(
            locale: Locale(identifier: "tr_TR"),
            timeZone: #require(TimeZone(secondsFromGMT: 0))
        )
        let value = #Decimal("32.25")

        let rate = try ExchangeRate(
            baseCurrency: CurrencyCode("USD"),
            quoteCurrency: CurrencyCode("TRY"),
            value: value,
            updatedAt: Date(
                timeIntervalSince1970: 1_700_000_000
            )
        )

        let sut = formatter.makeItem(
            from: rate,
            amount: 2
        )

        let updatedAtText = formatter.makeUpdatedAtText(
            from: rate.updatedAt
        )

        #expect(sut.id == "TRY")
        #expect(sut.currencyCodeText == "TRY")
        #expect(sut.rateValueText == "64,50")
        #expect(!updatedAtText.isEmpty)
    }
}
