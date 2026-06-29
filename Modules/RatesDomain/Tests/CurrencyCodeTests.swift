//
//  CurrencyCodeTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import RatesDomain
import Testing

struct CurrencyCodeTests {
    @Test func lowercaseValueIsNormalized() throws {
        let subject = try CurrencyCode("usd")

        #expect(subject.value == "USD")
    }

    @Test(
        arguments: [
            "US",
            "USDD",
            "U1D",
            "€UR"
        ]
    )
    func invalidValueThrowsError(_ value: String) {
        #expect(throws: CurrencyCodeError.self) {
            try CurrencyCode(value)
        }
    }
}
