//
//  ExchangeRateAPIRatesRepository.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import NetworkingCore
import RatesDomain

public enum ExchangeRateAPIError: Error, Equatable, Sendable {
    case invalidResponse
    case providerError(String?)
}

public final class ExchangeRateAPIRatesRepository: RatesRepository {
    private let httpClient: any HTTPClient

    public init(httpClient: any HTTPClient) {
        self.httpClient = httpClient
    }

    public func fetchRates(
        baseCurrency: CurrencyCode
    ) async throws -> [ExchangeRate] {
        let endpoint = ExchangeRateAPIEndpoint
            .latest(baseCurrency: baseCurrency)
            .endpoint
        let response = try await httpClient.send(
            endpoint,
            as: ExchangeRateAPIResponse.self
        )

        guard response.result == "success" else {
            throw ExchangeRateAPIError.providerError(
                response.errorType
            )
        }

        return try Self.makeRates(
            response: response,
            baseCurrency: baseCurrency
        )
    }

    private static func makeRates(
        response: ExchangeRateAPIResponse,
        baseCurrency: CurrencyCode
    ) throws -> [ExchangeRate] {
        guard
            response.baseCode == baseCurrency.value,
            let timestamp = response.timeLastUpdateUnix,
            timestamp > 0,
            let values = response.rates,
            !values.isEmpty
        else {
            throw ExchangeRateAPIError.invalidResponse
        }

        let updatedAt = Date(
            timeIntervalSince1970: TimeInterval(timestamp)
        )

        return try values
            .filter {
                $0.key != baseCurrency.value
            }
            .map { code, value in
                try ExchangeRate(
                    baseCurrency: baseCurrency,
                    quoteCurrency: CurrencyCode(code),
                    value: value,
                    updatedAt: updatedAt
                )
            }
            .sorted {
                $0.quoteCurrency.value <
                    $1.quoteCurrency.value
            }
    }
}
