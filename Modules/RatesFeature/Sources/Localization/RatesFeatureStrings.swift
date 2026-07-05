//
//  RatesFeatureStrings.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

enum RatesFeatureStrings {
    static var ratesTitle: String {
        localized(
            "rates.title",
            defaultValue: "Rates"
        )
    }

    static var attributionTitle: String {
        localized(
            "rates.attribution.title",
            defaultValue: "Rates By Exchange Rate API"
        )
    }

    static var loadingTitle: String {
        localized(
            "rates.loading.title",
            defaultValue: "Loading Rates"
        )
    }

    static var emptyTitle: String {
        localized(
            "rates.empty.title",
            defaultValue: "No Rates"
        )
    }

    static var emptyMessage: String {
        localized(
            "rates.empty.message",
            defaultValue: "No exchange rates are available"
        )
    }

    static var errorTitle: String {
        localized(
            "rates.error.title",
            defaultValue: "Could Not Load Rates"
        )
    }

    static var errorMessage: String {
        localized(
            "rates.error.message",
            defaultValue: "Check your connection and try again."
        )
    }

    static var retryTitle: String {
        localized(
            "rates.error.retry",
            defaultValue: "Try Again"
        )
    }

    static var baseLabel: String {
        localized(
            "rates.header.base.label",
            defaultValue: "Base:"
        )
    }

    static var amountLabel: String {
        localized(
            "rates.header.amount.label",
            defaultValue: "Amount"
        )
    }

    static var baseCurrencyAccessibilityLabel: String {
        localized(
            "rates.header.base.accessibility.label",
            defaultValue: "Base currency"
        )
    }

    static var baseCurrencyAccessibilityHint: String {
        localized(
            "rates.header.base.accessibility.hint",
            defaultValue:
            "Opens the currency selection list."
        )
    }

    static var amountAccessibilityLabel: String {
        localized(
            "rates.header.amount.accessibility.label",
            defaultValue: "Amount"
        )
    }

    static var amountAccessibilityHint: String {
        localized(
            "rates.header.amount.accessibility.hint",
            defaultValue:
            "Enter the amount to convert."
        )
    }

    static var currencyPickerTitle: String {
        localized(
            "currency_picker.title",
            defaultValue: "Select Currency"
        )
    }

    static var currencyPickerSearchPlaceholder: String {
        localized(
            "currency_picker.search.placeholder",
            defaultValue: "Search Currency"
        )
    }

    static func updatedAt(_ text: String) -> String {
        formatted(
            "rates.header.updated",
            defaultValue: "Updated: %@",
            arguments: [text]
        )
    }

    static func currencyAccessibilityLabel(
        code: String,
        name: String
    ) -> String {
        formatted(
            "currency_picker.cell.accessibility.label",
            defaultValue: "%1$@, %2$@",
            arguments: [
                code,
                name
            ]
        )
    }

    static func currencyAccessibilityHint(
        code: String
    ) -> String {
        formatted(
            "currency_picker.cell.accessibility.hint",
            defaultValue:
            "Sets %@ as the base currency.",
            arguments: [code]
        )
    }
}

private extension RatesFeatureStrings {
    static func localized(
        _ key: String,
        defaultValue: String
    ) -> String {
        Bundle.ratesFeature.localizedString(
            forKey: key,
            value: defaultValue,
            table: nil
        )
    }

    static func formatted(
        _ key: String,
        defaultValue: String,
        arguments: [CVarArg]
    ) -> String {
        String(
            format: localized(
                key,
                defaultValue: defaultValue
            ),
            locale: Locale.current,
            arguments: arguments
        )
    }
}
