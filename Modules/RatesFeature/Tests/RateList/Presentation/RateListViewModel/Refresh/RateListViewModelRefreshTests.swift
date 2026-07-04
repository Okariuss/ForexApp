//
//  RateListViewModelRefreshTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 4.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain
@testable import RatesFeature
import Testing

@MainActor
struct RateListViewModelRefreshTests {
    private typealias Factory =
        RateListViewModelTestFactory

    @Test func refreshUpdatesContentWithoutLoadingState() async throws {
        let initialRate = try Factory.makeRate(
            quoteCurrency: "EUR",
            value: "0.85"
        )
        let refreshedRate = try Factory.makeRate(
            quoteCurrency: "TRY",
            value: "46.60"
        )
        let repository = RefreshRepositoryStub(
            responses: [
                .success([initialRate]),
                .success([refreshedRate])
            ]
        )
        let subject = try RateListViewModel(
            repository: repository,
            baseCurrency: CurrencyCode("USD"),
            itemFormatter: RateListItemFormatterStub()
        )

        await subject.load()

        var receivedStates: [RateListViewState] = []
        subject.onStateChange = {
            receivedStates.append($0)
        }

        await subject.refresh()

        let expectedContent =
            Factory.makeExpectedContent(
                amountText: "1",
                items: [
                    Factory.makeExpectedItem(
                        currencyCode: "TRY",
                        amountText: "1"
                    )
                ]
            )

        #expect(
            receivedStates == [
                .content(expectedContent)
            ]
        )
    }

    @Test func refreshFailurePreservesContent() async throws {
        let rate = try Factory.makeRate(
            quoteCurrency: "EUR",
            value: "0.85"
        )
        let repository = RefreshRepositoryStub(
            responses: [
                .success([rate]),
                .failure
            ]
        )
        let subject = try RateListViewModel(
            repository: repository,
            baseCurrency: CurrencyCode("USD"),
            itemFormatter: RateListItemFormatterStub()
        )

        await subject.load()
        let stateBeforeRefresh = subject.state

        var receivedStates: [RateListViewState] = []
        subject.onStateChange = {
            receivedStates.append($0)
        }

        await subject.refresh()

        #expect(subject.state == stateBeforeRefresh)
        #expect(receivedStates.isEmpty)
    }
}
