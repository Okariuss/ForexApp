//
//  ExchangeRateAPIEndpoint.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import NetworkingCore
import RatesDomain

enum ExchangeRateAPIEndpoint {
    case latest(baseCurrency: CurrencyCode)

    var endpoint: Endpoint {
        switch self {
        case let .latest(baseCurrency):
            Endpoint(path: "v6/latest/\(baseCurrency.value)")
        }
    }
}
