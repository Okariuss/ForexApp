//
//  FileRatesCacheStore.swift
//  ForexApp
//
//  Created by Okan Orkun on 3.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain

public actor FileRatesCacheStore: RatesCacheStoring {
    private let directoryURL: URL
    private let fileManager: FileManager

    public init(
        directoryURL: URL,
        fileManager: FileManager = .default
    ) {
        self.directoryURL = directoryURL
        self.fileManager = fileManager
    }

    public func loadRates(
        for baseCurrency: CurrencyCode
    ) async throws -> [ExchangeRate]? {
        let fileURL = makeFileURL(
            for: baseCurrency
        )

        guard fileManager.fileExists(
            atPath: fileURL.path
        ) else {
            return nil
        }

        let data = try Data(contentsOf: fileURL)
        let payload = try makeDecoder().decode(
            RatesCachePayload.self,
            from: data
        )

        return try payload.makeRates(
            for: baseCurrency
        )
    }

    public func saveRates(
        _ rates: [ExchangeRate],
        for baseCurrency: CurrencyCode
    ) async throws {
        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        let payload = RatesCachePayload(
            baseCurrency: baseCurrency,
            rates: rates
        )
        let data = try makeEncoder().encode(payload)

        try data.write(
            to: makeFileURL(for: baseCurrency),
            options: .atomic
        )
    }
}

private extension FileRatesCacheStore {
    func makeFileURL(
        for baseCurrency: CurrencyCode
    ) -> URL {
        directoryURL.appendingPathComponent(
            "rates-\(baseCurrency.value).json",
            isDirectory: false
        )
    }

    func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }

    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
}
