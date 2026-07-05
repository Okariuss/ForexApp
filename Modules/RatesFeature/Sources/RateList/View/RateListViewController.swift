//
//  RateListViewController.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import AppMacros
import RatesDomain
import UIKit

@MainActor
final class RateListViewController: UIViewController {
    private enum Section {
        case main
    }

    private typealias DataSource =
        UICollectionViewDiffableDataSource<
            Section,
            RateListItem.ItemID
        >

    private typealias CellRegistration =
        UICollectionView.CellRegistration<
            RateListCell,
            RateListItem.ItemID
        >

    private let viewModel: RateListViewModel
    private var dataSource: DataSource?
    private var loadTask: Task<Void, Never>?

    private var itemsByID: [
        RateListItem.ItemID: RateListItem
    ] = [:]

    weak var coordinator: RateListCoordinator?

    private let headerView: RateListHeaderView = {
        let view = RateListHeaderView()
        view.isHidden = true
        return view
    }()

    private let collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(
            using: config
        )
        let uiCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        uiCollectionView.backgroundColor = RateListColor.background
        uiCollectionView.keyboardDismissMode = .interactive
        uiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return uiCollectionView
    }()

    private lazy var attributionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "Rates By Exchange Rate API",
            for: .normal
        )
        button.setTitleColor(
            RateListColor.action,
            for: .normal
        )
        button.titleLabel?.font =
            RateListTypography.attribution
        button.titleLabel?
            .adjustsFontForContentSizeCategory = true
        button.accessibilityTraits.insert(.link)
        button.translatesAutoresizingMaskIntoConstraints =
            false
        button.addTarget(
            self,
            action: #selector(attributionTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = RateListColor.action
        refreshControl.addTarget(
            self,
            action: #selector(refreshRates),
            for: .valueChanged
        )
        return refreshControl
    }()

    init(viewModel: RateListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Rates"
    }

    required init?(coder _: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupDataSource()
        bindViewModel()
        render(viewModel.state)
        loadRates()
    }

    func selectBaseCurrency(_ currency: CurrencyCode) {
        headerView.updateBaseCurrency(currency.value)

        loadTask?.cancel()

        loadTask = Task { [weak self] in
            await self?.viewModel.selectBaseCurrency(currency)
        }
    }
}

extension RateListViewController {
    func currencyCodeFrame(
        in containerView: UIView
    ) -> CGRect {
        headerView.currencyCodeFrame(
            in: containerView
        )
    }

    func currencyCodeSnapshot() -> UIView? {
        headerView.currencyCodeSnapshot()
    }

    func setCurrencyCodeAlpha(_ alpha: CGFloat) {
        headerView.setCurrencyCodeAlpha(alpha)
    }
}

private extension RateListViewController {
    func setupView() {
        view.backgroundColor = RateListColor.background

        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(attributionButton)

        setupRefreshToCollectionView()
        setupContentLayout()
        setupAttributionLayout()
    }

    func setupRefreshToCollectionView() {
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = false
    }

    func setupContentLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: RateListMetrics.headerVerticalInset
            ),
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: RateListMetrics.contentHorizontalInset
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -RateListMetrics.contentHorizontalInset
            ),
            collectionView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: RateListMetrics.headerVerticalInset
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: attributionButton.topAnchor
            )
        ])
    }

    func setupAttributionLayout() {
        NSLayoutConstraint.activate([
            attributionButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            attributionButton.leadingAnchor.constraint(
                greaterThanOrEqualTo:
                view.layoutMarginsGuide.leadingAnchor
            ),
            attributionButton.trailingAnchor.constraint(
                lessThanOrEqualTo:
                view.layoutMarginsGuide.trailingAnchor
            ),
            attributionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -RateListMetrics.cellContentSpacing
            )
        ])
    }

    func setupDataSource() {
        let registration = CellRegistration { [weak self] cell, _, itemID in
            guard let item = self?.itemsByID[itemID] else {
                return
            }

            cell.configure(with: item)
        }

        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemID in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: itemID
            )
        }
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }

        headerView.onAmountChange = { [weak self] text in
            self?.viewModel.updateAmount(text)
        }

        headerView.onBaseCurrencySelection = { [weak self] in
            guard let self else {
                return
            }

            coordinator?.handle(
                route: .selectBaseCurrency(
                    currencies: viewModel.availableCurrencies,
                    selectedCurrency: viewModel.baseCurrency
                )
            )
        }
    }

    func loadRates() {
        loadTask?.cancel()
        loadTask = Task { @MainActor [weak self] in
            await self?.viewModel.load()
        }
    }

    func render(_ state: RateListViewState) {
        switch state {
        case .idle:
            headerView.isHidden = true
            apply(items: [])
            contentUnavailableConfiguration = nil

        case .loading:
            headerView.isHidden = true
            collectionView.isHidden = true
            contentUnavailableConfiguration =
                RateListStateConfigurationFactory.makeLoading()

        case let .content(content):
            headerView.configure(
                baseCurrencyText: content.baseCurrencyText,
                amountText: content.amountText,
                updatedAtText: content.updatedAtText
            )
            headerView.isHidden = false
            contentUnavailableConfiguration = nil
            collectionView.isHidden = false
            apply(items: content.items)

        case .empty:
            headerView.isHidden = true
            collectionView.isHidden = true
            contentUnavailableConfiguration =
                RateListStateConfigurationFactory.makeEmpty()

        case .error:
            headerView.isHidden = true
            collectionView.isHidden = true
            contentUnavailableConfiguration =
                RateListStateConfigurationFactory.makeError { [weak self] in
                    self?.loadRates()
                }
        }
    }

    func apply(items: [RateListItem]) {
        var updatedItemsByID: [
            RateListItem.ItemID: RateListItem
        ] = [:]
        var itemIDs: [RateListItem.ItemID] = []

        for item in items {
            if updatedItemsByID[item.id] == nil {
                itemIDs.append(item.id)
            }

            updatedItemsByID[item.id] = item
        }

        let changedItemIDs = itemIDs.filter {
            guard let previousItem = itemsByID[$0],
                  let updatedItem = updatedItemsByID[$0]
            else {
                return false
            }

            return previousItem != updatedItem
        }

        itemsByID = updatedItemsByID

        var snapshot =
            NSDiffableDataSourceSnapshot<
                Section,
                RateListItem.ItemID
            >()

        snapshot.appendSections([.main])
        snapshot.appendItems(itemIDs)
        snapshot.reconfigureItems(changedItemIDs)

        dataSource?.apply(
            snapshot,
            animatingDifferences: true
        )
    }

    @objc func attributionTapped() {
        let url = #URL("https://www.exchangerate-api.com")

        coordinator?.handle(
            route: .openProvider(url)
        )
    }

    @objc func refreshRates() {
        loadTask?.cancel()

        loadTask = Task { @MainActor [weak self] in
            guard let self else {
                return
            }

            defer {
                refreshControl.endRefreshing()
            }

            await viewModel.refresh()
        }
    }
}
