//
//  CurrencyPickerViewController.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

final class CurrencyPickerViewController: UIViewController {
    private typealias DataSource =
        UITableViewDiffableDataSource<Int, String>

    private let viewModel: CurrencyPickerViewModel

    private var dataSource: DataSource?
    private var transitionCurrencyID: String

    private weak var transitionCell: CurrencyPickerCell?

    private var itemsByID: [
        String: CurrencyPickerItem
    ] = [:]

    weak var coordinator: CurrencyPickerCoordinator?

    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        tableView.backgroundColor = CurrencyPickerColor.background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()

    private let searchController = UISearchController(
        searchResultsController: nil
    )

    init(viewModel: CurrencyPickerViewModel) {
        self.viewModel = viewModel
        transitionCurrencyID = viewModel.selectedCurrencyID
        super.init(nibName: nil, bundle: nil)
        title = RatesFeatureStrings.currencyPickerTitle
    }

    required init?(coder _: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSearchController()
        setupDataSource()
        bindViewModel()
        apply(items: viewModel.items)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            coordinator?.handle(route: .finish)
        }
    }
}

extension CurrencyPickerViewController {
    func prepareCurrencyTransition() {
        loadViewIfNeeded()
        view.layoutIfNeeded()
        tableView.layoutIfNeeded()

        guard let indexPath = dataSource?.indexPath(
            for: transitionCurrencyID
        ) else {
            return
        }

        if tableView.cellForRow(at: indexPath) == nil {
            tableView.scrollToRow(
                at: indexPath,
                at: .middle,
                animated: false
            )
        }

        view.layoutIfNeeded()
        tableView.layoutIfNeeded()
    }

    func selectedCurrencyCell() -> CurrencyPickerCell? {
        if let transitionCell {
            return transitionCell
        }

        guard let indexPath = dataSource?.indexPath(
            for: transitionCurrencyID
        ) else {
            return nil
        }

        return tableView.cellForRow(
            at: indexPath
        ) as? CurrencyPickerCell
    }
}

extension CurrencyPickerViewController: UITableViewDelegate {
    func tableView(
        _: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let currency = viewModel.currency(
            at: indexPath.row
        ) else {
            return
        }

        transitionCell = tableView.cellForRow(
            at: indexPath
        ) as? CurrencyPickerCell

        transitionCurrencyID = currency.value
        coordinator?.handle(route: .select(currency))
    }
}

extension CurrencyPickerViewController: UISearchResultsUpdating {
    func updateSearchResults(
        for searchController: UISearchController
    ) {
        viewModel.updateSearchText(
            searchController.searchBar.text ?? ""
        )
    }
}

private extension CurrencyPickerViewController {
    func setupView() {
        view.backgroundColor = CurrencyPickerColor.background
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(
            CurrencyPickerCell.self,
            forCellReuseIdentifier:
            CurrencyPickerCell.reuseIdentifier
        )

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = RatesFeatureStrings.currencyPickerSearchPlaceholder

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    func setupDataSource() {
        dataSource = DataSource(
            tableView: tableView
        ) { [weak self] tableView, _, itemID in
            guard
                let item = self?.itemsByID[itemID],
                let cell = tableView.dequeueReusableCell(
                    withIdentifier:
                    CurrencyPickerCell.reuseIdentifier
                ) as? CurrencyPickerCell
            else {
                return UITableViewCell()
            }

            cell.configure(with: item)
            return cell
        }
    }

    func bindViewModel() {
        viewModel.onItemsChange = { [weak self] items in
            self?.apply(items: items)
        }
    }

    func apply(items: [CurrencyPickerItem]) {
        itemsByID = Dictionary(
            uniqueKeysWithValues: items.map {
                ($0.id, $0)
            }
        )

        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()

        snapshot.appendSections([0])
        snapshot.appendItems(items.map(\.id))

        dataSource?.apply(
            snapshot,
            animatingDifferences: true
        )
    }
}
