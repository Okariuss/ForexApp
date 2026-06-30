//
//  AppConfigurationTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import ForexApp
import Testing

struct AppConfigurationTests {
    @Test func validValueCreatesConfiguration() throws {
        let sut = try AppConfiguration(
            values: [
                "ExchangeRateAPIBaseURL":
                    "https://open.er-api.com",
                "DefaultBaseCurrencyCode": "USD"
            ]
        )

        #expect(
            sut.exchangeRateAPIBaseURL.absoluteString ==
                "https://open.er-api.com"
        )

        #expect(
            sut.defaultBaseCurrency.value == "USD"
        )
    }

    @Test func missingValueThrowsError() {
        #expect(
            throws: AppConfigurationError.missingValue(
                "ExchangeRateAPIBaseURL"
            )
        ) {
            try AppConfiguration(values: [:])
        }
    }

    @Test func insecureURLThrowsError() {
        let value = "http://open.er-api.com"

        #expect(
            throws: AppConfigurationError.invalidURL(value)
        ) {
            try AppConfiguration(
                values: [
                    "ExchangeRateAPIBaseURL": value,
                    "DefaultBaseCurrencyCode": "USD"
                ]
            )
        }
    }

    @Test func invalidCurrencyCodeThrowsError() {
        let currencyCode = "INVALID"

        #expect(
            throws:
            AppConfigurationError
                .invalidCurrencyCode(currencyCode)
        ) {
            try AppConfiguration(
                values: [
                    "ExchangeRateAPIBaseURL":
                        "https://open.er-api.com",
                    "DefaultBaseCurrencyCode":
                        currencyCode
                ]
            )
        }
    }
}
