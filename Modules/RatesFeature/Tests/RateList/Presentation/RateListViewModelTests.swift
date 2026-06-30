//
//  RateListViewModelTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain
@testable import RatesFeature
import Testing

@MainActor
struct RateListViewModelTests {
    @Test func successCreatesSortedContent() async throws {
        let liraRate = try makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let euroRate = try makeRate(
            quoteCurrency: "EUR",
            value: "0.878247"
        )
        let sut = try makeSubject(
            behavior: .success([liraRate, euroRate])
        )
        var receivedStates: [RateListViewState] = []
        sut.onStateChange = {
            receivedStates.append($0)
        }

        await sut.load()

        let expectedItems = [
            makeExpectedItem(
                currencyCode: "EUR",
                amountText: "1"
            ),
            makeExpectedItem(
                currencyCode: "TRY",
                amountText: "1"
            )
        ]

        let expectedContent = makeExpectedContent(
            amountText: "1",
            items: expectedItems
        )

        #expect(sut.state == .content(expectedContent))
        #expect(
            receivedStates == [
                .loading,
                .content(expectedContent)
            ]
        )
    }

    @Test func amountChangeRecalculatesContent() async throws {
        let rate = try makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let sut = try makeSubject(
            behavior: .success([rate])
        )

        await sut.load()
        sut.updateAmount("2")

        let expectedItem = makeExpectedItem(
            currencyCode: "TRY",
            amountText: "2"
        )

        let expectedContent = makeExpectedContent(
            amountText: "2",
            items: [expectedItem]
        )

        #expect(sut.state == .content(expectedContent))
    }

    @Test func emptyResponseCreatesEmptyState() async throws {
        let sut = try makeSubject(
            behavior: .success([])
        )

        await sut.load()

        #expect(sut.state == .empty)
    }

    @Test func failureCreatesErrorState() async throws {
        let sut = try makeSubject(
            behavior: .failure
        )

        await sut.load()

        #expect(sut.state == .error)
    }

    @Test func cancellationDoesNotPublishTerminalState() async throws {
        let sut = try makeSubject(
            behavior: .cancellation
        )
        var receivedStates: [RateListViewState] = []

        sut.onStateChange = {
            receivedStates.append($0)
        }

        await sut.load()

        #expect(receivedStates == [.loading])
    }

    @Test func invalidAmountPreservesCurrentContent() async throws {
        let rate = try makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let subject = try makeSubject(
            behavior: .success([rate])
        )

        await subject.load()
        let contentBeforeInvalidAmount = subject.state

        subject.updateAmount("invalid")

        #expect(subject.state == contentBeforeInvalidAmount)
    }

    @Test func baseCurrencyChangeReloadsRates() async throws {
        let usdRate = try makeRate(
            quoteCurrency: "TRY",
            value: "46.604401"
        )
        let tryRate = try makeRate(
            baseCurrency: "TRY",
            quoteCurrency: "USD",
            value: "0.021457"
        )

        let repository = BaseCurrencyRepositoryStub(
            responses: [
                "USD": [usdRate],
                "TRY": [tryRate]
            ]
        )

        let subject = try RateListViewModel(
            repository: repository,
            baseCurrency: CurrencyCode("USD"),
            itemFormatter: RateListItemFormatterStub()
        )

        await subject.load()
        try await subject.selectBaseCurrency(
            CurrencyCode("TRY")
        )

        let requestedCurrencies =
            await repository.requestedCurrencies()

        #expect(requestedCurrencies == ["USD", "TRY"])

        guard case let .content(content) = subject.state else {
            Issue.record("Expected content state.")
            return
        }

        #expect(content.baseCurrencyText == "TRY")
        #expect(content.amountText == "1")
        #expect(content.items.map(\.id) == ["USD"])
    }
}

private extension RateListViewModelTests {
    enum RatesRepositoryStubError: Error {
        case failed
    }

    enum Behavior {
        case success([ExchangeRate])
        case failure
        case cancellation
    }

    actor BaseCurrencyRepositoryStub: RatesRepository {
        private let responses: [
            String: [ExchangeRate]
        ]

        private var requests: [String] = []

        init(
            responses: [String: [ExchangeRate]]
        ) {
            self.responses = responses
        }

        func fetchRates(
            baseCurrency: CurrencyCode
        ) async throws -> [ExchangeRate] {
            requests.append(baseCurrency.value)
            return responses[baseCurrency.value] ?? []
        }

        func requestedCurrencies() -> [String] {
            requests
        }
    }

    struct RatesRepositoryStub: RatesRepository {
        let behavior: Behavior

        func fetchRates(
            baseCurrency _: CurrencyCode
        ) async throws -> [ExchangeRate] {
            switch behavior {
            case let .success(rates):
                rates
            case .failure:
                throw RatesRepositoryStubError.failed
            case .cancellation:
                throw CancellationError()
            }
        }
    }

    @MainActor
    struct RateListItemFormatterStub: RateListItemFormatting {
        func makeItem(
            from rate: ExchangeRate,
            amount: Decimal
        ) -> RateListItem {
            let code = rate.quoteCurrency.value

            return RateListItem(
                id: code,
                currencyCodeText: code,
                rateValueText: "formatted-\(code)-\(amount)"
            )
        }

        func makeUpdatedAtText(
            from _: Date
        ) -> String {
            "formatted-date"
        }
    }
}

private extension RateListViewModelTests {
    func makeSubject(
        behavior: Behavior
    ) throws -> RateListViewModel {
        try RateListViewModel(
            repository: RatesRepositoryStub(
                behavior: behavior
            ),
            baseCurrency: CurrencyCode("USD"),
            itemFormatter: RateListItemFormatterStub()
        )
    }

    func makeRate(
        baseCurrency: String = "USD",
        quoteCurrency: String,
        value: String
    ) throws -> ExchangeRate {
        let decimalValue = try #require(
            Decimal(string: value)
        )

        return try ExchangeRate(
            baseCurrency: CurrencyCode(baseCurrency),
            quoteCurrency: CurrencyCode(quoteCurrency),
            value: decimalValue,
            updatedAt: Date(
                timeIntervalSince1970: 1_700_000_000
            )
        )
    }

    func makeExpectedItem(
        currencyCode: String,
        amountText: String
    ) -> RateListItem {
        RateListItem(
            id: currencyCode,
            currencyCodeText: currencyCode,
            rateValueText:
            "formatted-\(currencyCode)-\(amountText)"
        )
    }

    private func makeExpectedContent(
        amountText: String,
        items: [RateListItem]
    ) -> RateListContent {
        RateListContent(
            baseCurrencyText: "USD",
            amountText: amountText,
            updatedAtText: "formatted-date",
            items: items
        )
    }
}
