//
//  CurrencyPickerBuilder.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain

@MainActor
enum CurrencyPickerBuilder {
    static func make(
        coordinator: CurrencyPickerCoordinator,
        currencies: [CurrencyCode],
        selectedCurrency: CurrencyCode
    ) -> CurrencyPickerViewController {
        let viewModel = CurrencyPickerViewModel(
            currencies: currencies,
            selectedCurrency: selectedCurrency
        )

        let viewController = CurrencyPickerViewController(
            viewModel: viewModel
        )

        viewController.coordinator = coordinator

        return viewController
    }
}
