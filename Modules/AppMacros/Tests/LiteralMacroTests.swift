//
//  LiteralMacroTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import AppMacros
import Foundation
import Testing

struct LiteralMacroTests {
    @Test func urlCreatesExpectedValue() {
        let subject = #URL(
            "https://example.com"
        )

        #expect(
            subject.absoluteString ==
                "https://example.com"
        )
    }

    @Test func decimalCreatesExpectedValue() {
        let subject = #Decimal("32.25")

        #expect(
            subject ==
                Foundation.Decimal(
                    string: "32.25"
                )
        )
    }
}
