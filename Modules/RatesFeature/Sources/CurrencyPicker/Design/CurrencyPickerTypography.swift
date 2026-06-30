//
//  CurrencyPickerTypography.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import DesignSystem
import UIKit

@MainActor
enum CurrencyPickerTypography {
    static var currencyCode: UIFont {
        UIFont.appFont(
            token: .headline,
            weight: .semibold
        )
    }

    static var currencyName: UIFont {
        UIFont.appFont(
            token: .body,
            weight: .regular
        )
    }
}
