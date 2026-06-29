//
//  AppDependencies.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import NetworkingCore
import RatesData
import RatesDomain

struct AppDependencies {
    let ratesRepository: any RatesRepository

    init(configuration: AppConfiguration) {
        let httpClient = URLSessionHTTPClient(
            baseURL: configuration.exchangeRateAPIBaseURL
        )

        ratesRepository = ExchangeRateAPIRatesRepository(
            httpClient: httpClient
        )
    }
}
