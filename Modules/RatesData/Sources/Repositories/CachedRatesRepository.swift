//
//  CachedRatesRepository.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain

public final class CachedRatesRepository: RatesRepository {
    private let remoteRepository: any RatesRepository
    private let cacheStore: any RatesCacheStoring

    public init(
        remoteRepository: any RatesRepository,
        cacheStore: any RatesCacheStoring
    ) {
        self.remoteRepository = remoteRepository
        self.cacheStore = cacheStore
    }

    public func fetchRates(
        baseCurrency: CurrencyCode
    ) async throws -> [ExchangeRate] {
        do {
            let rates = try await remoteRepository.fetchRates(
                baseCurrency: baseCurrency
            )

            try? await cacheStore.saveRates(
                rates,
                for: baseCurrency
            )

            return rates
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            if let cachedRates = try? await cacheStore.loadRates(
                for: baseCurrency
            ) {
                return cachedRates
            }

            throw error
        }
    }
}
