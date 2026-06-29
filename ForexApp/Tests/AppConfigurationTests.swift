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
                    "https://open.er-api.com"
            ]
        )

        #expect(
            sut.exchangeRateAPIBaseURL.absoluteString ==
                "https://open.er-api.com"
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
                    "ExchangeRateAPIBaseURL": value
                ]
            )
        }
    }
}
