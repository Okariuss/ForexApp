//
//  AppConfiguration.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

enum AppConfigurationError: Error, Equatable {
    case missingValue(String)
    case invalidURL(String)
}

struct AppConfiguration {
    private enum Key {
        static let exchangeRateAPIBaseURL =
            "ExchangeRateAPIBaseURL"
    }

    let exchangeRateAPIBaseURL: URL

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

        exchangeRateAPIBaseURL = url
    }
}
