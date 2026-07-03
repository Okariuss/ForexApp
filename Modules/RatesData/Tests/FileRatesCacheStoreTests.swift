//
//  FileRatesCacheStoreTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 3.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import RatesData
import RatesDomain
import Testing

struct FileRatesCacheStoreTests {
    @Test func savedRatesCanBeLoaded() async throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer {
            try? FileManager.default.removeItem(
                at: directoryURL
            )
        }

        let subject = FileRatesCacheStore(
            directoryURL: directoryURL
        )
        let baseCurrency = try CurrencyCode("USD")
        let rates = try [makeRate(value: "0.85")]

        try await subject.saveRates(
            rates,
            for: baseCurrency
        )
        let loadedRates = try await subject.loadRates(
            for: baseCurrency
        )

        #expect(loadedRates == rates)
    }

    @Test func missingCacheReturnsNil() async throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer {
            try? FileManager.default.removeItem(
                at: directoryURL
            )
        }

        let subject = FileRatesCacheStore(
            directoryURL: directoryURL
        )

        let loadedRates = try await subject.loadRates(
            for: CurrencyCode("USD")
        )

        #expect(loadedRates == nil)
    }

    @Test func savingAgainReplacesPreviousRates() async throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer {
            try? FileManager.default.removeItem(
                at: directoryURL
            )
        }

        let subject = FileRatesCacheStore(
            directoryURL: directoryURL
        )
        let baseCurrency = try CurrencyCode("USD")
        let initialRates = try [makeRate(value: "0.85")]
        let updatedRates = try [makeRate(value: "0.90")]

        try await subject.saveRates(
            initialRates,
            for: baseCurrency
        )
        try await subject.saveRates(
            updatedRates,
            for: baseCurrency
        )

        let loadedRates = try await subject.loadRates(
            for: baseCurrency
        )

        #expect(loadedRates == updatedRates)
    }

    @Test func corruptedCacheThrowsError() async throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer {
            try? FileManager.default.removeItem(
                at: directoryURL
            )
        }

        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        let fileURL = directoryURL.appendingPathComponent(
            "rates-USD.json"
        )

        try Data("invalid-json".utf8).write(
            to: fileURL
        )

        let subject = FileRatesCacheStore(
            directoryURL: directoryURL
        )

        await #expect(throws: DecodingError.self) {
            try await subject.loadRates(
                for: CurrencyCode("USD")
            )
        }
    }

    private func makeTemporaryDirectoryURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(
                UUID().uuidString,
                isDirectory: true
            )
    }

    private func makeRate(
        value: String
    ) throws -> ExchangeRate {
        let decimalValue = try #require(
            Decimal(string: value)
        )

        return try ExchangeRate(
            baseCurrency: CurrencyCode("USD"),
            quoteCurrency: CurrencyCode("EUR"),
            value: decimalValue,
            updatedAt: Date(
                timeIntervalSince1970: 1_700_000_000
            )
        )
    }
}
