//
//  RateListAmountParserTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import RatesFeature
import Testing

@MainActor
struct RateListAmountParserTests {
    @Test func parsesTurkishDecimalSeparator() {
        let subject = RateListAmountParser(
            locale: Locale(identifier: "tr_TR")
        )

        let result = subject.parse("1,5")

        #expect(result == Decimal(string: "1.5"))
    }

    @Test func parsesEnglishDecimalSeparator() {
        let subject = RateListAmountParser(
            locale: Locale(identifier: "en_US")
        )

        let result = subject.parse("1.5")

        #expect(result == Decimal(string: "1.5"))
    }

    @Test func invalidTextReturnsNil() {
        let subject = RateListAmountParser(
            locale: Locale(identifier: "en_US")
        )

        #expect(subject.parse("invalid") == nil)
    }

    @Test func emptyTextReturnsZero() {
        let subject = RateListAmountParser(
            locale: Locale(identifier: "en_US")
        )

        #expect(subject.parse("") == .zero)
        #expect(subject.parse("   ") == .zero)
    }
}
