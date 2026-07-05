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
        #expect(viewController.title == RatesFeatureStrings.ratesTitle)
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
                .title == RatesFeatureStrings.ratesTitle
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

    @Test func pushToCurrencyPickerUsesForwardAnimator() throws {
        let subject = try makeTransitionSubject()

        let animator = subject.coordinator.navigationController(
            subject.navigationController,
            animationControllerFor: .push,
            from: subject.rateListViewController,
            to: subject.currencyPickerViewController
        )

        let transitionAnimator = try #require(
            animator as? CurrencyPickerTransitionAnimator
        )

        #expect(transitionAnimator.isForward)
    }

    @Test func popFromCurrencyPickerUsesReverseAnimator() throws {
        let subject = try makeTransitionSubject()

        let animator = subject.coordinator.navigationController(
            subject.navigationController,
            animationControllerFor: .pop,
            from: subject.currencyPickerViewController,
            to: subject.rateListViewController
        )

        let transitionAnimator = try #require(
            animator as? CurrencyPickerTransitionAnimator
        )

        #expect(!transitionAnimator.isForward)
    }

    @Test func unrelatedTransitionUsesDefaultAnimator() throws {
        let subject = try makeTransitionSubject()

        let animator = subject.coordinator.navigationController(
            subject.navigationController,
            animationControllerFor: .push,
            from: UIViewController(),
            to: UIViewController()
        )

        #expect(animator == nil)
    }
}

private struct CoordinatorRepositoryStub: RatesRepository {
    func fetchRates(
        baseCurrency _: CurrencyCode
    ) async throws -> [ExchangeRate] {
        []
    }
}

private extension RateListCoordinatorTests {
    struct TransitionSubject {
        let coordinator: RateListCoordinator
        let navigationController: UINavigationController
        let rateListViewController: RateListViewController
        let currencyPickerViewController: CurrencyPickerViewController
    }

    func makeTransitionSubject() throws -> TransitionSubject {
        let navigationController = UINavigationController()
        let repository = CoordinatorRepositoryStub()
        let baseCurrency = try CurrencyCode("USD")

        let coordinator = RateListCoordinator(
            navigationController: navigationController,
            repository: repository,
            baseCurrency: baseCurrency
        )
        let rateListViewController =
            RateListBuilder.make(
                coordinator: coordinator,
                repository: repository,
                baseCurrency: baseCurrency
            )

        let pickerCoordinator =
            CurrencyPickerCoordinator(
                navigationController:
                navigationController,
                currencies: [baseCurrency],
                selectedCurrency: baseCurrency
            )
        let currencyPickerViewController =
            CurrencyPickerBuilder.make(
                coordinator: pickerCoordinator,
                currencies: [baseCurrency],
                selectedCurrency: baseCurrency
            )

        return TransitionSubject(
            coordinator: coordinator,
            navigationController: navigationController,
            rateListViewController: rateListViewController,
            currencyPickerViewController: currencyPickerViewController
        )
    }
}
