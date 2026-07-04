//
//  RateListViewModelTestStubs.swift
//  ForexApp
//
//  Created by Okan Orkun on 4.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import RatesDomain
@testable import RatesFeature

enum RateListRepositoryStubError: Error {
    case failed
}

enum RateListRepositoryBehavior {
    case success([ExchangeRate])
    case failure
    case cancellation
}

struct RateListRepositoryStub: RatesRepository {
    let behavior: RateListRepositoryBehavior

    func fetchRates(
        baseCurrency _: CurrencyCode
    ) async throws -> [ExchangeRate] {
        switch behavior {
        case let .success(rates):
            rates
        case .failure:
            throw RateListRepositoryStubError.failed
        case .cancellation:
            throw CancellationError()
        }
    }
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

enum RefreshRepositoryResponse {
    case success([ExchangeRate])
    case failure
}

actor RefreshRepositoryStub: RatesRepository {
    private var responses: [RefreshRepositoryResponse]

    init(
        responses: [RefreshRepositoryResponse]
    ) {
        self.responses = responses
    }

    func fetchRates(
        baseCurrency _: CurrencyCode
    ) async throws -> [ExchangeRate] {
        guard !responses.isEmpty else {
            throw RateListRepositoryStubError.failed
        }

        let response = responses.removeFirst()

        switch response {
        case let .success(rates):
            return rates
        case .failure:
            throw RateListRepositoryStubError.failed
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
