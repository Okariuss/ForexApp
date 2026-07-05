//
//  CurrencyPickerCoordinatorTests.swift
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
struct CurrencyPickerCoordinatorTests {
    @Test func startPushesCurrencyPicker() throws {
        let navigationController =
            UINavigationController()
        let subject = try makeSubject(
            navigationController:
            navigationController
        )

        subject.start()

        #expect(
            navigationController.topViewController
                is CurrencyPickerViewController
        )
        #expect(
            navigationController
                .topViewController?
                .title == RatesFeatureStrings.currencyPickerTitle
        )
    }

    @Test func selectionNotifiesDelegate() throws {
        let navigationController =
            UINavigationController()
        let delegate =
            CurrencyPickerCoordinatorDelegateSpy()

        let subject = try makeSubject(
            navigationController:
            navigationController
        )
        subject.delegate = delegate
        subject.start()

        let selectedCurrency =
            try CurrencyCode("TRY")

        subject.handle(
            route: .select(selectedCurrency)
        )

        #expect(
            delegate.selectedCurrency ==
                selectedCurrency
        )
    }

    @Test func finishNotifiesDelegate() throws {
        let navigationController =
            UINavigationController()
        let delegate =
            CurrencyPickerCoordinatorDelegateSpy()

        let subject = try makeSubject(
            navigationController:
            navigationController
        )
        subject.delegate = delegate

        subject.handle(route: .finish)

        #expect(delegate.didFinish)
    }

    private func makeSubject(
        navigationController:
        UINavigationController
    ) throws -> CurrencyPickerCoordinator {
        try CurrencyPickerCoordinator(
            navigationController:
            navigationController,
            currencies: [
                CurrencyCode("USD"),
                CurrencyCode("TRY"),
                CurrencyCode("EUR")
            ],
            selectedCurrency:
            CurrencyCode("USD")
        )
    }
}

@MainActor
private final class CurrencyPickerCoordinatorDelegateSpy: CurrencyPickerCoordinatorDelegate {
    private(set) var selectedCurrency:
        CurrencyCode?

    private(set) var didFinish = false

    func currencyPickerCoordinator(
        _: CurrencyPickerCoordinator,
        didSelect currency: CurrencyCode
    ) {
        selectedCurrency = currency
    }

    func currencyPickerCoordinatorDidFinish(
        _: CurrencyPickerCoordinator
    ) {
        didFinish = true
    }
}
