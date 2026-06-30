//
//  RateListItem.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

struct RateListItem: Equatable {
    typealias ItemID = String

    let id: ItemID
    let currencyCodeText: String
    let rateValueText: String
}

struct RateListContent: Equatable {
    let baseCurrencyText: String
    let amountText: String
    let updatedAtText: String
    let items: [RateListItem]
}
