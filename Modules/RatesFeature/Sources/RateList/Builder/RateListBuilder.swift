//
//  RateListBuilder.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import RatesDomain

@MainActor
enum RateListBuilder {
    static func make(
        coordinator: RateListCoordinator,
        repository: any RatesRepository,
        baseCurrency: CurrencyCode
    ) -> RateListViewController {
        let viewModel = RateListViewModel(
            repository: repository,
            baseCurrency: baseCurrency
        )
        let viewController = RateListViewController(
            viewModel: viewModel
        )

        viewController.coordinator = coordinator

        return viewController
    }
}
