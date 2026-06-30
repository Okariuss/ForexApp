//
//  CurrencyPickerViewModelTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain
@testable import RatesFeature
import Testing

@MainActor
struct CurrencyPickerViewModelTests {
    @Test func createsSortedItemsAndMarksSelection() throws {
        let subject = try makeSubject()

        #expect(
            subject.items.map(\.codeText) ==
                ["EUR", "TRY", "USD"]
        )
        #expect(
            subject.items
                .first { $0.codeText == "TRY" }?
                .isSelected == true
        )
    }

    @Test func searchFiltersCodeAndName() throws {
        let subject = try makeSubject()

        subject.updateSearchText("Euro")

        #expect(subject.items.map(\.codeText) == ["EUR"])

        subject.updateSearchText("usd")

        #expect(subject.items.map(\.codeText) == ["USD"])
    }

    @Test func emptySearchRestoresAllItems() throws {
        let subject = try makeSubject()

        subject.updateSearchText("Euro")
        subject.updateSearchText("")

        #expect(subject.items.count == 3)
    }

    @Test func currencyReturnsSelectedDomainModel() throws {
        let subject = try makeSubject()

        let currency = subject.currency(at: 1)

        #expect(currency?.value == "TRY")
        #expect(subject.currency(at: 99) == nil)
    }

    private func makeSubject() throws -> CurrencyPickerViewModel {
        try CurrencyPickerViewModel(
            currencies: [
                CurrencyCode("USD"),
                CurrencyCode("TRY"),
                CurrencyCode("EUR")
            ],
            selectedCurrency: CurrencyCode("TRY"),
            itemFormatter:
            CurrencyPickerItemFormatterStub()
        )
    }
}

@MainActor
private struct CurrencyPickerItemFormatterStub: CurrencyPickerItemFormatting {
    func makeItem(
        from currency: CurrencyCode,
        isSelected: Bool
    ) -> CurrencyPickerItem {
        let names = [
            "EUR": "Euro",
            "TRY": "Turkish Lira",
            "USD": "US Dollar"
        ]

        return CurrencyPickerItem(
            id: currency.value,
            codeText: currency.value,
            nameText:
            names[currency.value] ?? currency.value,
            isSelected: isSelected
        )
    }
}
