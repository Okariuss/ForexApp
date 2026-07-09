//
//  RateListViewModel.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import AppMacros
import Foundation
import RatesDomain

@MainActor
final class RateListViewModel {
    private let repository: any RatesRepository
    private let amountParser: any RateListAmountParsing
    private let itemFormatter: any RateListItemFormatting

    private(set) var baseCurrency: CurrencyCode
    private var rates: [ExchangeRate] = []
    private var amount = #Decimal("1")
    private var amountText = "1"

    var availableCurrencies: [CurrencyCode] {
        var currenciesByCode: [String: CurrencyCode] = [
            baseCurrency.value: baseCurrency
        ]

        for rate in rates {
            currenciesByCode[rate.quoteCurrency.value] = rate.quoteCurrency
        }

        return currenciesByCode.values.sorted {
            $0.value < $1.value
        }
    }

    private(set) var state: RateListViewState = .idle {
        didSet {
            onStateChange?(state)
        }
    }

    var onStateChange: ((RateListViewState) -> Void)?

    init(
        repository: any RatesRepository,
        baseCurrency: CurrencyCode,
        amountParser: any RateListAmountParsing =
            RateListAmountParser(),
        itemFormatter: any RateListItemFormatting =
            RateListItemFormatter()
    ) {
        self.repository = repository
        self.baseCurrency = baseCurrency
        self.amountParser = amountParser
        self.itemFormatter = itemFormatter
    }

    func load() async {
        await fetchRates(displaysLoading: true)
    }

    func refresh() async {
        await fetchRates(displaysLoading: false)
    }

    func updateAmount(_ text: String) {
        guard let amount = amountParser.parse(text),
              amount >= .zero
        else {
            return
        }

        self.amount = amount
        amountText = text

        renderContent()
    }

    func selectBaseCurrency(_ currency: CurrencyCode) async {
        guard currency != baseCurrency else {
            return
        }

        baseCurrency = currency
        rates = []

        await load()
    }
}

private extension RateListViewModel {
    private func renderContent() {
        guard !rates.isEmpty else {
            return
        }

        let items = rates
            .map {
                itemFormatter.makeItem(
                    from: $0,
                    amount: amount
                )
            }
            .sorted {
                $0.currencyCodeText <
                    $1.currencyCodeText
            }

        guard let updatedAt = rates
            .map(\.updatedAt)
            .max()
        else {
            state = .empty
            return
        }

        state = .content(
            RateListContent(
                baseCurrencyText: baseCurrency.value,
                amountText: amountText,
                updatedAtText:
                itemFormatter.makeUpdatedAtText(
                    from: updatedAt
                ),
                items: items
            )
        )
    }

    private func fetchRates(
        displaysLoading: Bool
    ) async {
        if displaysLoading {
            state = .loading
        }

        do {
            let rates = try await repository.fetchRates(
                baseCurrency: baseCurrency
            )
            try Task.checkCancellation()

            guard !rates.isEmpty else {
                state = .empty
                return
            }

            self.rates = rates
            renderContent()
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else {
                return
            }

            if displaysLoading {
                state = .error
            }
        }
    }
}
