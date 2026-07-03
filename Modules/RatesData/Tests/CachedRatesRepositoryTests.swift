//
//  CachedRatesRepositoryTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import RatesData
import RatesDomain
import Testing

struct CachedRatesRepositoryTests {
    @Test func remoteSuccessReturnsAndCachesRates() async throws {
        let baseCurrency = try CurrencyCode("USD")
        let rates = try [makeRate()]
        let cacheStore = RatesCacheStoreStub(
            loadBehavior: .value(nil)
        )
        let subject = CachedRatesRepository(
            remoteRepository: RatesRemoteRepositoryStub(
                behavior: .success(rates)
            ),
            cacheStore: cacheStore
        )

        let result = try await subject.fetchRates(
            baseCurrency: baseCurrency
        )
        let snapshot = await cacheStore.snapshot()

        #expect(result == rates)
        #expect(snapshot.savedRates == rates)
        #expect(snapshot.savedBaseCurrency == baseCurrency)
        #expect(snapshot.loadCallCount == 0)
    }

    @Test func remoteFailureReturnsCachedRates() async throws {
        let baseCurrency = try CurrencyCode("USD")
        let cachedRates = try [makeRate()]
        let cacheStore = RatesCacheStoreStub(
            loadBehavior: .value(cachedRates)
        )
        let subject = CachedRatesRepository(
            remoteRepository: RatesRemoteRepositoryStub(
                behavior: .failure
            ),
            cacheStore: cacheStore
        )

        let result = try await subject.fetchRates(
            baseCurrency: baseCurrency
        )
        let snapshot = await cacheStore.snapshot()

        #expect(result == cachedRates)
        #expect(snapshot.loadedBaseCurrency == baseCurrency)
        #expect(snapshot.loadCallCount == 1)
    }

    @Test func missingCachePreservesRemoteError() async throws {
        let subject = CachedRatesRepository(
            remoteRepository: RatesRemoteRepositoryStub(
                behavior: .failure
            ),
            cacheStore: RatesCacheStoreStub(
                loadBehavior: .value(nil)
            )
        )

        await #expect(
            throws: RatesRemoteRepositoryStubError.self
        ) {
            try await subject.fetchRates(
                baseCurrency: CurrencyCode("USD")
            )
        }
    }

    @Test func cancellationDoesNotLoadCache() async throws {
        let cacheStore = try RatesCacheStoreStub(
            loadBehavior: .value([makeRate()])
        )
        let subject = CachedRatesRepository(
            remoteRepository: RatesRemoteRepositoryStub(
                behavior: .cancellation
            ),
            cacheStore: cacheStore
        )

        await #expect(throws: CancellationError.self) {
            try await subject.fetchRates(
                baseCurrency: CurrencyCode("USD")
            )
        }

        let snapshot = await cacheStore.snapshot()
        #expect(snapshot.loadCallCount == 0)
    }

    @Test func cacheWriteFailureDoesNotDiscardRemoteRates() async throws {
        let rates = try [makeRate()]
        let subject = CachedRatesRepository(
            remoteRepository: RatesRemoteRepositoryStub(
                behavior: .success(rates)
            ),
            cacheStore: RatesCacheStoreStub(
                loadBehavior: .value(nil),
                saveShouldFail: true
            )
        )

        let result = try await subject.fetchRates(
            baseCurrency: CurrencyCode("USD")
        )

        #expect(result == rates)
    }

    private func makeRate() throws -> ExchangeRate {
        let value = try #require(
            Decimal(string: "0.85")
        )

        return try ExchangeRate(
            baseCurrency: CurrencyCode("USD"),
            quoteCurrency: CurrencyCode("EUR"),
            value: value,
            updatedAt: Date(
                timeIntervalSince1970: 1_700_000_000
            )
        )
    }
}

private enum RatesRemoteRepositoryBehavior {
    case success([ExchangeRate])
    case failure
    case cancellation
}

private enum RatesRemoteRepositoryStubError: Error {
    case failed
}

private struct RatesRemoteRepositoryStub: RatesRepository {
    let behavior: RatesRemoteRepositoryBehavior

    func fetchRates(
        baseCurrency _: CurrencyCode
    ) async throws -> [ExchangeRate] {
        switch behavior {
        case let .success(rates):
            rates
        case .failure:
            throw RatesRemoteRepositoryStubError.failed
        case .cancellation:
            throw CancellationError()
        }
    }
}

private enum RatesCacheLoadBehavior {
    case value([ExchangeRate]?)
    case failure
}

private enum RatesCacheStoreStubError: Error {
    case failed
}

private struct RatesCacheStoreSnapshot {
    let savedRates: [ExchangeRate]?
    let savedBaseCurrency: CurrencyCode?
    let loadedBaseCurrency: CurrencyCode?
    let loadCallCount: Int
}

private actor RatesCacheStoreStub: RatesCacheStoring {
    private let loadBehavior: RatesCacheLoadBehavior
    private let saveShouldFail: Bool

    private var savedRates: [ExchangeRate]?
    private var savedBaseCurrency: CurrencyCode?
    private var loadedBaseCurrency: CurrencyCode?
    private var loadCallCount = 0

    init(
        loadBehavior: RatesCacheLoadBehavior,
        saveShouldFail: Bool = false
    ) {
        self.loadBehavior = loadBehavior
        self.saveShouldFail = saveShouldFail
    }

    func loadRates(
        for baseCurrency: CurrencyCode
    ) throws -> [ExchangeRate]? {
        loadedBaseCurrency = baseCurrency
        loadCallCount += 1

        switch loadBehavior {
        case let .value(rates):
            return rates
        case .failure:
            throw RatesCacheStoreStubError.failed
        }
    }

    func saveRates(
        _ rates: [ExchangeRate],
        for baseCurrency: CurrencyCode
    ) throws {
        guard !saveShouldFail else {
            throw RatesCacheStoreStubError.failed
        }

        savedRates = rates
        savedBaseCurrency = baseCurrency
    }

    func snapshot() -> RatesCacheStoreSnapshot {
        RatesCacheStoreSnapshot(
            savedRates: savedRates,
            savedBaseCurrency: savedBaseCurrency,
            loadedBaseCurrency: loadedBaseCurrency,
            loadCallCount: loadCallCount
        )
    }
}
