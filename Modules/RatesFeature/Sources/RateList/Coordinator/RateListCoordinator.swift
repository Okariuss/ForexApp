//
//  RateListCoordinator.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import PresentationCore
import RatesDomain
import UIKit

@MainActor
public final class RateListCoordinator: NSObject, Coordinator {
    private weak var navigationController: UINavigationController?
    private weak var mainViewController: RateListViewController?

    private var currencyPickerCoordinator: CurrencyPickerCoordinator?

    private let repository: any RatesRepository
    private let baseCurrency: CurrencyCode
    private let onBaseCurrencyChange: (CurrencyCode) -> Void
    private let currencyPickerAnimator = CurrencyPickerTransitionAnimator()

    public init(
        navigationController: UINavigationController,
        repository: any RatesRepository,
        baseCurrency: CurrencyCode,
        onBaseCurrencyChange: @escaping (CurrencyCode) -> Void = { _ in }
    ) {
        self.navigationController = navigationController
        self.repository = repository
        self.baseCurrency = baseCurrency
        self.onBaseCurrencyChange = onBaseCurrencyChange

        super.init()

        navigationController.delegate = self
    }

    public func start() {
        guard let navigationController else {
            return
        }

        let viewController = RateListBuilder.make(
            coordinator: self,
            repository: repository,
            baseCurrency: baseCurrency
        )

        mainViewController = viewController

        if navigationController.viewControllers.isEmpty {
            navigationController.setViewControllers(
                [viewController],
                animated: false
            )
        } else {
            navigationController.pushViewController(
                viewController,
                animated: true
            )
        }
    }

    func handle(route: RateListRoute) {
        switch route {
        case let .openProvider(url):
            UIApplication.shared.open(url)
        case let .selectBaseCurrency(
            currencies: currencies,
            selectedCurrency: selectedCurrency
        ):
            startCurrencyPicker(
                currencies: currencies,
                selectedCurrency: selectedCurrency
            )
        }
    }
}

extension RateListCoordinator: CurrencyPickerCoordinatorDelegate {
    func currencyPickerCoordinator(
        _: CurrencyPickerCoordinator,
        didSelect currency: RatesDomain.CurrencyCode
    ) {
        onBaseCurrencyChange(currency)

        mainViewController?.selectBaseCurrency(currency)
    }

    func currencyPickerCoordinatorDidFinish(
        _: CurrencyPickerCoordinator
    ) {
        currencyPickerCoordinator = nil
    }

    private func startCurrencyPicker(
        currencies: [CurrencyCode],
        selectedCurrency: CurrencyCode
    ) {
        guard let navigationController else {
            return
        }

        let coordinator = CurrencyPickerCoordinator(
            navigationController: navigationController,
            currencies: currencies,
            selectedCurrency: selectedCurrency
        )

        coordinator.delegate = self
        currencyPickerCoordinator = coordinator
        coordinator.start()
    }
}

extension RateListCoordinator: UINavigationControllerDelegate {
    public func navigationController(
        _: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        let isCurrencyPickerPush =
            operation == .push &&
            fromVC is RateListViewController &&
            toVC is CurrencyPickerViewController

        let isCurrencyPickerPop =
            operation == .pop &&
            fromVC is CurrencyPickerViewController &&
            toVC is RateListViewController

        if isCurrencyPickerPush {
            currencyPickerAnimator.isForward = true
            return currencyPickerAnimator
        }

        if isCurrencyPickerPop {
            currencyPickerAnimator.isForward = false
            return currencyPickerAnimator
        }

        return nil
    }
}
