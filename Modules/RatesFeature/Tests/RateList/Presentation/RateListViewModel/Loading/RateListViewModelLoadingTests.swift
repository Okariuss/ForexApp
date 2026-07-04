//
//  RateListViewModelLoadingTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 4.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import RatesFeature
import Testing

@MainActor
struct RateListViewModelLoadingTests {
    private typealias Factory =
        RateListViewModelTestFactory

    @Test func successCreatesSortedContent() async throws {
        let liraRate = try Factory.makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let euroRate = try Factory.makeRate(
            quoteCurrency: "EUR",
            value: "0.878247"
        )
        let subject = try Factory.makeSubject(
            behavior: .success([liraRate, euroRate])
        )
        var receivedStates: [RateListViewState] = []

        subject.onStateChange = {
            receivedStates.append($0)
        }

        await subject.load()

        let expectedItems = [
            Factory.makeExpectedItem(
                currencyCode: "EUR",
                amountText: "1"
            ),
            Factory.makeExpectedItem(
                currencyCode: "TRY",
                amountText: "1"
            )
        ]
        let expectedContent =
            Factory.makeExpectedContent(
                amountText: "1",
                items: expectedItems
            )

        #expect(
            subject.state == .content(expectedContent)
        )
        #expect(
            receivedStates == [
                .loading,
                .content(expectedContent)
            ]
        )
    }

    @Test func emptyResponseCreatesEmptyState() async throws {
        let subject = try Factory.makeSubject(
            behavior: .success([])
        )

        await subject.load()

        #expect(subject.state == .empty)
    }

    @Test func failureCreatesErrorState() async throws {
        let subject = try Factory.makeSubject(
            behavior: .failure
        )

        await subject.load()

        #expect(subject.state == .error)
    }

    @Test func cancellationDoesNotPublishTerminalState() async throws {
        let subject = try Factory.makeSubject(
            behavior: .cancellation
        )
        var receivedStates: [RateListViewState] = []

        subject.onStateChange = {
            receivedStates.append($0)
        }

        await subject.load()

        #expect(receivedStates == [.loading])
    }
}
