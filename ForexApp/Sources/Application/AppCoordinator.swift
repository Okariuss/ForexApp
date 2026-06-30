//
//  AppCoordinator.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import PresentationCore
import RatesDomain
import RatesFeature
import UIKit

@MainActor
final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let dependencies: AppDependencies
    private let navigationController: UINavigationController

    private var rateListCoordinator: RateListCoordinator?

    init(
        window: UIWindow,
        dependencies: AppDependencies
    ) {
        self.window = window
        self.dependencies = dependencies
        navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController

        startRateList()

        window.makeKeyAndVisible()
    }

    private func startRateList() {
        let baseCurrency = makeInitialBaseCurrency()
        let preferenceStore = dependencies.baseCurrencyPreferenceStore

        let coordinator = RateListCoordinator(
            navigationController: navigationController,
            repository: dependencies.ratesRepository,
            baseCurrency: baseCurrency,
            onBaseCurrencyChange: { currency in
                preferenceStore.baseCurrencyCode =
                    currency.value
            }
        )

        rateListCoordinator = coordinator
        coordinator.start()
    }

    private func makeInitialBaseCurrency() -> CurrencyCode {
        let candidates = [
            dependencies
                .baseCurrencyPreferenceStore
                .baseCurrencyCode,
            Locale.current.currency?.identifier
        ]

        for candidate in candidates.compactMap(\.self) {
            if let currency = try? CurrencyCode(candidate) {
                return currency
            }
        }

        preconditionFailure(
            "A valid base currency is required."
        )
    }
}
