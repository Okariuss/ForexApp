//
//  ExchangeRateAPIRatesRepositoryTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import NetworkingCore
@testable import RatesData
import RatesDomain
import Testing

private enum HTTPClientStubError: Error {
    case unexpectedResponseType
}

private struct HTTPClientStub: HTTPClient {
    let response: ExchangeRateAPIResponse

    func send<Response: Decodable & Sendable>(
        _: Endpoint,
        as _: Response.Type
    ) async throws -> Response {
        guard let typedResponse = response as? Response else {
            throw HTTPClientStubError.unexpectedResponseType
        }

        return typedResponse
    }
}

struct ExchangeRateAPIRatesRepositoryTests {
    @Test func successResponseCreatesSortedRates() async throws {
        let baseCurrency = try CurrencyCode("USD")
        let euroValue = try #require(
            Decimal(string: "0.92")
        )
        let liraValue = try #require(
            Decimal(string: "32.50")
        )
        let response = ExchangeRateAPIResponse(
            result: "success",
            baseCode: "USD",
            timeLastUpdateUnix: 1_700_000_000,
            rates: [
                "TRY": liraValue,
                "USD": 1,
                "EUR": euroValue
            ],
            errorType: nil
        )
        let sut = ExchangeRateAPIRatesRepository(
            httpClient: HTTPClientStub(response: response)
        )

        let rates = try await sut.fetchRates(
            baseCurrency: baseCurrency
        )

        #expect(rates.count == 2)
        #expect(rates[0].quoteCurrency.value == "EUR")
        #expect(rates[0].value == euroValue)
        #expect(rates[1].quoteCurrency.value == "TRY")
        #expect(rates[1].value == liraValue)
        #expect(
            rates.allSatisfy {
                $0.baseCurrency == baseCurrency
            }
        )
        #expect(
            rates.allSatisfy {
                $0.updatedAt.timeIntervalSince1970 ==
                    1_700_000_000
            }
        )
    }

    @Test func providerErrorIsPreserved() async throws {
        let response = ExchangeRateAPIResponse(
            result: "error",
            baseCode: nil,
            timeLastUpdateUnix: nil,
            rates: nil,
            errorType: "unsupported-code"
        )
        let sut = ExchangeRateAPIRatesRepository(
            httpClient: HTTPClientStub(response: response)
        )
        let baseCurrency = try CurrencyCode("USD")

        do {
            _ = try await sut.fetchRates(
                baseCurrency: baseCurrency
            )
            Issue.record("Expected a provider error.")
        } catch let error as ExchangeRateAPIError {
            #expect(
                error == .providerError("unsupported-code")
            )
        }
    }

    @Test func missingValuesThrowInvalidResponse() async throws {
        let response = ExchangeRateAPIResponse(
            result: "success",
            baseCode: "USD",
            timeLastUpdateUnix: nil,
            rates: nil,
            errorType: nil
        )
        let sut = ExchangeRateAPIRatesRepository(
            httpClient: HTTPClientStub(response: response)
        )
        let baseCurrency = try CurrencyCode("USD")

        do {
            _ = try await sut.fetchRates(
                baseCurrency: baseCurrency
            )
            Issue.record("Expected an invalid response error.")
        } catch let error as ExchangeRateAPIError {
            #expect(error == .invalidResponse)
        }
    }
}
