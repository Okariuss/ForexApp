//
//  RateListViewModelTestFactory.swift
//  ForexApp
//
//  Created by Okan Orkun on 4.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain
@testable import RatesFeature
import Testing

@MainActor
enum RateListViewModelTestFactory {
    static func makeSubject(
        behavior: RateListRepositoryBehavior
    ) throws -> RateListViewModel {
        try RateListViewModel(
            repository: RateListRepositoryStub(
                behavior: behavior
            ),
            baseCurrency: CurrencyCode("USD"),
            itemFormatter: RateListItemFormatterStub()
        )
    }

    static func makeRate(
        baseCurrency: String = "USD",
        quoteCurrency: String,
        value: String
    ) throws -> ExchangeRate {
        let decimalValue = try #require(
            Decimal(string: value)
        )

        return try ExchangeRate(
            baseCurrency: CurrencyCode(baseCurrency),
            quoteCurrency: CurrencyCode(quoteCurrency),
            value: decimalValue,
            updatedAt: Date(
                timeIntervalSince1970: 1_700_000_000
            )
        )
    }

    static func makeExpectedItem(
        currencyCode: String,
        amountText: String
    ) -> RateListItem {
        RateListItem(
            id: currencyCode,
            currencyCodeText: currencyCode,
            rateValueText:
            "formatted-\(currencyCode)-\(amountText)"
        )
    }

    static func makeExpectedContent(
        baseCurrencyText: String = "USD",
        amountText: String,
        items: [RateListItem]
    ) -> RateListContent {
        RateListContent(
            baseCurrencyText: baseCurrencyText,
            amountText: amountText,
            updatedAtText: "formatted-date",
            items: items
        )
    }
}
