//
//  RatesFeatureLocalizationTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import RatesFeature
import Testing

struct RatesFeatureLocalizationTests {
    @Test func englishCatalogContainsAllKeys() throws {
        let bundle = try localizedBundle(
            language: "en"
        )

        try expectAllKeys(in: bundle)
        #expect(
            localized(
                "rates.title",
                in: bundle
            ) == "Rates"
        )
    }

    @Test func turkishCatalogContainsAllKeys() throws {
        let bundle = try localizedBundle(
            language: "tr"
        )

        try expectAllKeys(in: bundle)
        #expect(
            localized(
                "rates.title",
                in: bundle
            ) == "Kurlar"
        )
    }

    @Test func localizedFormatsPreserveArguments() throws {
        let englishBundle = try localizedBundle(
            language: "en"
        )
        let turkishBundle = try localizedBundle(
            language: "tr"
        )

        let englishFormat = localized(
            "rates.header.updated",
            in: englishBundle
        )
        let turkishFormat = localized(
            "rates.header.updated",
            in: turkishBundle
        )

        #expect(
            String(
                format: englishFormat,
                "12:00"
            ) == "Updated: 12:00"
        )
        #expect(
            String(
                format: turkishFormat,
                "12:00"
            ) == "Güncellendi: 12:00"
        )
    }
}

private extension RatesFeatureLocalizationTests {
    var keys: [String] {
        [
            "currency_picker.cell.accessibility.hint",
            "currency_picker.cell.accessibility.label",
            "currency_picker.search.placeholder",
            "currency_picker.title",
            "rates.attribution.title",
            "rates.empty.message",
            "rates.empty.title",
            "rates.error.message",
            "rates.error.retry",
            "rates.error.title",
            "rates.header.amount.accessibility.hint",
            "rates.header.amount.accessibility.label",
            "rates.header.amount.label",
            "rates.header.base.accessibility.hint",
            "rates.header.base.accessibility.label",
            "rates.header.base.label",
            "rates.header.updated",
            "rates.loading.title",
            "rates.title"
        ]
    }

    func localizedBundle(
        language: String
    ) throws -> Bundle {
        let path = try #require(
            Bundle.ratesFeature.path(
                forResource: language,
                ofType: "lproj"
            )
        )

        return try #require(
            Bundle(path: path)
        )
    }

    func expectAllKeys(
        in bundle: Bundle
    ) throws {
        for key in keys {
            let value = localized(
                key,
                in: bundle
            )

            #expect(value != key)
            #expect(!value.isEmpty)
        }
    }

    func localized(
        _ key: String,
        in bundle: Bundle
    ) -> String {
        bundle.localizedString(
            forKey: key,
            value: nil,
            table: nil
        )
    }
}
