//
//  RateListRoute.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain

enum RateListRoute {
    case selectBaseCurrency(
        currencies: [CurrencyCode],
        selectedCurrency: CurrencyCode
    )
    case openProvider(URL)
}
