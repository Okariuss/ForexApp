//
//  RateListCoordinatorTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain
@testable import RatesFeature
import Testing
import UIKit

@MainActor
struct RateListCoordinatorTests {
    @Test func builderConnectsViewControllerToCoordinator() throws {
        let repository = CoordinatorRepositoryStub()
        let navigationController =
            UINavigationController()
        let baseCurrency = try CurrencyCode("USD")

        let coordinator = RateListCoordinator(
            navigationController: navigationController,
            repository: repository,
            baseCurrency: baseCurrency
        )

        let viewController = RateListBuilder.make(
            coordinator: coordinator,
            repository: repository,
            baseCurrency: baseCurrency
        )

        #expect(
            viewController.coordinator === coordinator
        )
        #expect(viewController.title == "Rates")
    }

    @Test func startSetsRateListAsRoot() throws {
        let navigationController =
            UINavigationController()
        let baseCurrency = try CurrencyCode("USD")

        let coordinator = RateListCoordinator(
            navigationController: navigationController,
            repository: CoordinatorRepositoryStub(),
            baseCurrency: baseCurrency
        )

        coordinator.start()

        #expect(
            navigationController.viewControllers.count == 1
        )
        #expect(
            navigationController
                .topViewController?
                .title == "Rates"
        )
    }

    @Test func currencySelectionRouteStartsPicker() throws {
        let navigationController =
            UINavigationController()

        let baseCurrency = try CurrencyCode("USD")

        let subject = RateListCoordinator(
            navigationController:
            navigationController,
            repository: CoordinatorRepositoryStub(),
            baseCurrency: baseCurrency
        )

        subject.start()

        try subject.handle(
            route: .selectBaseCurrency(
                currencies: [
                    baseCurrency,
                    CurrencyCode("TRY")
                ],
                selectedCurrency: baseCurrency
            )
        )

        #expect(
            navigationController.topViewController
                is CurrencyPickerViewController
        )
    }
}

private struct CoordinatorRepositoryStub: RatesRepository {
    func fetchRates(
        baseCurrency _: CurrencyCode
    ) async throws -> [ExchangeRate] {
        []
    }
}
