//
//  RateListColor.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import DesignSystem
import UIKit

@MainActor
enum RateListColor {
    static let background =
        ColorToken.systemBackground

    static let cellBackground =
        ColorToken.secondarySystemBackground

    static let currencyCode =
        ColorToken.primaryLabel

    static let rateValue =
        ColorToken.primaryLabel

    static let headerBaseCurrency =
        ColorToken.primaryLabel

    static let headerUpdatedAt =
        ColorToken.secondaryLabel

    static let stateTitle =
        ColorToken.primaryLabel

    static let stateMessage =
        ColorToken.secondaryLabel

    static let error =
        ColorToken.negative

    static let action =
        ColorToken.accent

    static let amountLabel =
        ColorToken.secondaryLabel

    static let amountValue =
        ColorToken.primaryLabel
}
