//
//  CurrencyPickerViewModel.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain

@MainActor
final class CurrencyPickerViewModel {
    private let selectedCurrency: CurrencyCode
    private let itemFormatter: any CurrencyPickerItemFormatting

    private let currenciesByID: [String: CurrencyCode]

    private let allItems: [CurrencyPickerItem]

    private(set) var items: [CurrencyPickerItem] = [] {
        didSet {
            onItemsChange?(items)
        }
    }

    var onItemsChange: (([CurrencyPickerItem]) -> Void)?

    init(
        currencies: [CurrencyCode],
        selectedCurrency: CurrencyCode,
        itemFormatter:
        any CurrencyPickerItemFormatting = CurrencyPickerItemFormatter()
    ) {
        self.selectedCurrency = selectedCurrency
        self.itemFormatter = itemFormatter

        var currenciesByID: [String: CurrencyCode] = [:]

        for currency in currencies {
            currenciesByID[currency.value] = currency
        }

        currenciesByID[selectedCurrency.value] = selectedCurrency

        self.currenciesByID = currenciesByID

        allItems = currenciesByID.values
            .map {
                itemFormatter.makeItem(
                    from: $0,
                    isSelected: $0 == selectedCurrency
                )
            }
            .sorted {
                $0.codeText < $1.codeText
            }

        items = allItems
    }

    func updateSearchText(_ text: String) {
        let query = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            items = allItems
            return
        }

        items = allItems.filter {
            $0.codeText.localizedCaseInsensitiveContains(
                query
            ) ||
                $0.nameText.localizedCaseInsensitiveContains(
                    query
                )
        }
    }

    func currency(at index: Int) -> CurrencyCode? {
        guard items.indices.contains(index) else {
            return nil
        }

        return currenciesByID[items[index].id]
    }
}
