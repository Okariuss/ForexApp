//
//  RateListAmountParser.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

@MainActor
protocol RateListAmountParsing {
    func parse(_ text: String) -> Decimal?
}

@MainActor
final class RateListAmountParser: RateListAmountParsing {
    private let numberFormatter: NumberFormatter

    init(locale: Locale = .current) {
        numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .decimal
        numberFormatter.generatesDecimalNumbers = true
    }

    func parse(_ text: String) -> Decimal? {
        let trimmedText = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedText.isEmpty else {
            return .zero
        }

        guard let number = numberFormatter.number(
            from: trimmedText
        ) else {
            return nil
        }

        return number.decimalValue
    }
}
