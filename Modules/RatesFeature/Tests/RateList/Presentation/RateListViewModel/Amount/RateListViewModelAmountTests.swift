//
//  RateListViewModelAmountTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 4.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import RatesFeature
import Testing

@MainActor
struct RateListViewModelAmountTests {
    private typealias Factory =
        RateListViewModelTestFactory

    @Test func amountChangeRecalculatesContent() async throws {
        let rate = try Factory.makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let subject = try Factory.makeSubject(
            behavior: .success([rate])
        )

        await subject.load()
        subject.updateAmount("2")

        let expectedItem =
            Factory.makeExpectedItem(
                currencyCode: "TRY",
                amountText: "2"
            )
        let expectedContent =
            Factory.makeExpectedContent(
                amountText: "2",
                items: [expectedItem]
            )

        #expect(
            subject.state == .content(expectedContent)
        )
    }

    @Test func invalidAmountPreservesCurrentContent() async throws {
        let rate = try Factory.makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let subject = try Factory.makeSubject(
            behavior: .success([rate])
        )

        await subject.load()
        let contentBeforeInvalidAmount = subject.state

        subject.updateAmount("invalid")

        #expect(
            subject.state == contentBeforeInvalidAmount
        )
    }
}
