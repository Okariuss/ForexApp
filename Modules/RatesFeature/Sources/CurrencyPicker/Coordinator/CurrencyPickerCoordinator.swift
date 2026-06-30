//
//  CurrencyPickerCoordinator.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import PresentationCore
import RatesDomain
import UIKit

@MainActor
protocol CurrencyPickerCoordinatorDelegate: AnyObject {
    func currencyPickerCoordinator(
        _ coordinator: CurrencyPickerCoordinator,
        didSelect currency: CurrencyCode
    )

    func currencyPickerCoordinatorDidFinish(
        _ coordinator: CurrencyPickerCoordinator
    )
}

@MainActor
final class CurrencyPickerCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?

    private let currencies: [CurrencyCode]
    private let selectedCurrency: CurrencyCode

    weak var delegate: (any CurrencyPickerCoordinatorDelegate)?

    init(
        navigationController: UINavigationController,
        currencies: [CurrencyCode],
        selectedCurrency: CurrencyCode
    ) {
        self.navigationController = navigationController
        self.currencies = currencies
        self.selectedCurrency = selectedCurrency
    }

    func start() {
        guard let navigationController else {
            return
        }

        let viewController = CurrencyPickerBuilder.make(
            coordinator: self,
            currencies: currencies,
            selectedCurrency: selectedCurrency
        )

        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }

    func handle(route: CurrencyPickerRoute) {
        switch route {
        case let .select(currencyCode):
            delegate?.currencyPickerCoordinator(
                self,
                didSelect: currencyCode
            )
            navigationController?.popViewController(
                animated: true
            )
        case .finish:
            delegate?.currencyPickerCoordinatorDidFinish(self)
        }
    }
}
