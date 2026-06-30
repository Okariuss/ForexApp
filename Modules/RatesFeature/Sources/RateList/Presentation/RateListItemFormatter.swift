//
//  RateListItemFormatter.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain

@MainActor
protocol RateListItemFormatting {
    func makeItem(
        from rate: ExchangeRate,
        amount: Decimal
    ) -> RateListItem

    func makeUpdatedAtText(
        from date: Date
    ) -> String
}

@MainActor
final class RateListItemFormatter: RateListItemFormatting {
    private let numberFormatter: NumberFormatter
    private let dateFormatter: DateFormatter

    init(
        locale: Locale = .autoupdatingCurrent,
        timeZone: TimeZone = .autoupdatingCurrent
    ) {
        numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 6

        dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }

    func makeItem(
        from rate: ExchangeRate,
        amount: Decimal
    ) -> RateListItem {
        RateListItem(
            id: rate.quoteCurrency.value,
            currencyCodeText: rate.quoteCurrency.value,
            rateValueText: makeRateValueText(
                from: rate.value * amount
            )
        )
    }

    func makeUpdatedAtText(
        from date: Date
    ) -> String {
        dateFormatter.string(from: date)
    }

    private func makeRateValueText(
        from value: Decimal
    ) -> String {
        numberFormatter.string(
            from: NSDecimalNumber(decimal: value)
        ) ?? value.description
    }
}
