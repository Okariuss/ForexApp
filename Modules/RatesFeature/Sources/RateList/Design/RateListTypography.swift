//
//  RateListTypography.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import DesignSystem
import UIKit

@MainActor
enum RateListTypography {
    static var currencyCode: UIFont {
        UIFont.appFont(
            token: .headline,
            weight: .semibold
        )
    }

    static var rateValue: UIFont {
        UIFont.appMonospacedDigitFont(
            token: .body,
            weight: .regular
        )
    }

    static var headerBaseCurrency: UIFont {
        UIFont.appFont(
            token: .headline,
            weight: .semibold
        )
    }

    static var headerUpdatedAt: UIFont {
        UIFont.appFont(
            token: .caption,
            weight: .regular
        )
    }

    static var stateTitle: UIFont {
        UIFont.appFont(
            token: .title,
            weight: .semibold
        )
    }

    static var stateMessage: UIFont {
        UIFont.appFont(
            token: .body,
            weight: .regular
        )
    }

    static var attribution: UIFont {
        UIFont.appFont(
            token: .caption,
            weight: .regular
        )
    }

    static var amountLabel: UIFont {
        UIFont.appFont(
            token: .body,
            weight: .regular
        )
    }

    static var amountValue: UIFont {
        UIFont.appMonospacedDigitFont(
            token: .body,
            weight: .medium
        )
    }
}
