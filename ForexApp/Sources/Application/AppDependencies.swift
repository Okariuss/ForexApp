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

@MainActor
struct AppDependencies {
    let ratesRepository: any RatesRepository
    let baseCurrencyPreferenceStore: any BaseCurrencyPreferenceStoring
    let defaultBaseCurrency: CurrencyCode

    init(configuration: AppConfiguration) {
        let httpClient = URLSessionHTTPClient(
            baseURL: configuration.exchangeRateAPIBaseURL
        )

        ratesRepository = ExchangeRateAPIRatesRepository(
            httpClient: httpClient
        )

        baseCurrencyPreferenceStore = BaseCurrencyPreferenceStore()

        defaultBaseCurrency =
            configuration.defaultBaseCurrency
    }

    init(
        ratesRepository: any RatesRepository,
        baseCurrencyPreferenceStore: any BaseCurrencyPreferenceStoring,
        defaultBaseCurrency: CurrencyCode
    ) {
        self.ratesRepository = ratesRepository
        self.baseCurrencyPreferenceStore = baseCurrencyPreferenceStore
        self.defaultBaseCurrency = defaultBaseCurrency
    }
}
