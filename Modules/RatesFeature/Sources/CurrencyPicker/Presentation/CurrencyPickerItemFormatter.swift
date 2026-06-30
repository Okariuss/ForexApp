//
//  CurrencyPickerItemFormatter.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain

@MainActor
protocol CurrencyPickerItemFormatting {
    func makeItem(
        from currency: CurrencyCode,
        isSelected: Bool
    ) -> CurrencyPickerItem
}

@MainActor
final class CurrencyPickerItemFormatter: CurrencyPickerItemFormatting {
    private let locale: Locale

    init(locale: Locale = .current) {
        self.locale = locale
    }

    func makeItem(
        from currency: CurrencyCode,
        isSelected: Bool
    ) -> CurrencyPickerItem {
        let code = currency.value
        let name = locale.localizedString(
            forCurrencyCode: code
        ) ?? code

        return CurrencyPickerItem(
            id: code,
            codeText: code,
            nameText: name,
            isSelected: isSelected
        )
    }
}
