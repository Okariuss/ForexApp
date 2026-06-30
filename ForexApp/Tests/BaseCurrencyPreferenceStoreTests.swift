//
//  BaseCurrencyPreferenceStoreTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import ForexApp
import Foundation
import Testing

@MainActor
struct BaseCurrencyPreferenceStoreTests {
    @Test func savesAndReadsCurrencyCode() throws {
        let suiteName = UUID().uuidString
        let userDefaults = try #require(
            UserDefaults(suiteName: suiteName)
        )

        defer {
            userDefaults.removePersistentDomain(
                forName: suiteName
            )
        }

        let subject = BaseCurrencyPreferenceStore(
            userDefaults: userDefaults
        )

        #expect(subject.baseCurrencyCode == nil)

        subject.baseCurrencyCode = "TRY"

        #expect(subject.baseCurrencyCode == "TRY")
    }

    @Test func nilRemovesSavedCurrencyCode() throws {
        let suiteName = UUID().uuidString
        let userDefaults = try #require(
            UserDefaults(suiteName: suiteName)
        )

        defer {
            userDefaults.removePersistentDomain(
                forName: suiteName
            )
        }

        let subject = BaseCurrencyPreferenceStore(
            userDefaults: userDefaults
        )

        subject.baseCurrencyCode = "USD"
        subject.baseCurrencyCode = nil

        #expect(subject.baseCurrencyCode == nil)
    }
}
