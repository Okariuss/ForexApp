//
//  AppConfiguration.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain

enum AppConfigurationError: Error, Equatable {
    case missingValue(String)
    case invalidURL(String)
    case invalidCurrencyCode(String)
}

struct AppConfiguration {
    private enum Key {
        static let exchangeRateAPIBaseURL =
            "ExchangeRateAPIBaseURL"
        static let defaultBaseCurrencyCode =
            "DefaultBaseCurrencyCode"
    }

    let exchangeRateAPIBaseURL: URL
    let defaultBaseCurrency: CurrencyCode

    init(bundle: Bundle = .main) throws {
        try self.init(
            values: bundle.infoDictionary ?? [:]
        )
    }

    init(values: [String: Any]) throws {
        guard let value = values[
            Key.exchangeRateAPIBaseURL
        ] as? String else {
            throw AppConfigurationError.missingValue(
                Key.exchangeRateAPIBaseURL
            )
        }

        guard
            let url = URL(string: value),
            url.scheme == "https",
            url.host != nil
        else {
            throw AppConfigurationError.invalidURL(value)
        }

        guard let currencyCode = values[
            Key.defaultBaseCurrencyCode
        ] as? String else {
            throw AppConfigurationError.missingValue(
                Key.defaultBaseCurrencyCode
            )
        }

        guard let defaultBaseCurrency =
            try? CurrencyCode(currencyCode)
        else {
            throw AppConfigurationError
                .invalidCurrencyCode(currencyCode)
        }

        exchangeRateAPIBaseURL = url
        self.defaultBaseCurrency = defaultBaseCurrency
    }
}
