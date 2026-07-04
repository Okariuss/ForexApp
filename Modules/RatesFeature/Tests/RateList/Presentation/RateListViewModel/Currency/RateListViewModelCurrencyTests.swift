//
//  RateListViewModelCurrencyTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 4.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain
@testable import RatesFeature
import Testing

@MainActor
struct RateListViewModelCurrencyTests {
    private typealias Factory =
        RateListViewModelTestFactory

    @Test func baseCurrencyChangeReloadsRates() async throws {
        let usdRate = try Factory.makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let tryRate = try Factory.makeRate(
            baseCurrency: "TRY",
            quoteCurrency: "USD",
            value: "0.021457"
        )
        let repository = BaseCurrencyRepositoryStub(
            responses: [
                "USD": [usdRate],
                "TRY": [tryRate]
            ]
        )
        let subject = try RateListViewModel(
            repository: repository,
            baseCurrency: CurrencyCode("USD"),
            itemFormatter: RateListItemFormatterStub()
        )

        await subject.load()
        try await subject.selectBaseCurrency(
            CurrencyCode("TRY")
        )

        let requestedCurrencies =
            await repository.requestedCurrencies()

        #expect(
            requestedCurrencies == ["USD", "TRY"]
        )

        guard case let .content(content) = subject.state else {
            Issue.record("Expected content state.")
            return
        }

        #expect(content.baseCurrencyText == "TRY")
        #expect(content.amountText == "1")
        #expect(content.items.map(\.id) == ["USD"])
    }
}
