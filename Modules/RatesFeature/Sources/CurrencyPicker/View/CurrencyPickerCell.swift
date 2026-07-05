//
//  CurrencyPickerCell.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

@MainActor
final class CurrencyPickerCell: UITableViewCell {
    static let reuseIdentifier =
        String(describing: CurrencyPickerCell.self)

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font =
            CurrencyPickerTypography.currencyCode
        label.textColor =
            CurrencyPickerColor.currencyCode
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(
            .required,
            for: .horizontal
        )
        label.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )
        return label
    }()

    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font =
            CurrencyPickerTypography.currencyName
        label.textColor =
            CurrencyPickerColor.currencyName
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                currencyCodeLabel,
                currencyNameLabel
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing =
            CurrencyPickerMetrics.cellContentSpacing
        stackView.translatesAutoresizingMaskIntoConstraints =
            false
        return stackView
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        currencyCodeLabel.text = nil
        currencyCodeLabel.alpha = 1
        currencyNameLabel.text = nil
        accessoryType = .none
    }

    func configure(with item: CurrencyPickerItem) {
        currencyCodeLabel.text = item.codeText
        currencyNameLabel.text = item.nameText
        accessoryType =
            item.isSelected ? .checkmark : .none
        accessibilityLabel =
            "\(item.codeText), \(item.nameText)"
    }

    func currencyCodeFrame(
        in containerView: UIView
    ) -> CGRect {
        layoutIfNeeded()

        return currencyCodeLabel.convert(
            currencyCodeLabel.bounds,
            to: containerView
        )
    }

    func currencyCodeSnapshot() -> UIView {
        layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(
            bounds: currencyCodeLabel.bounds
        )

        let image = renderer.image { context in
            currencyCodeLabel.layer.render(
                in: context.cgContext
            )
        }

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func setCurrencyCodeAlpha(_ alpha: CGFloat) {
        currencyCodeLabel.alpha = alpha
    }
}

private extension CurrencyPickerCell {
    func setupView() {
        tintColor =
            CurrencyPickerColor.selection

        contentView.directionalLayoutMargins =
            NSDirectionalEdgeInsets(
                top: CurrencyPickerMetrics.cellVerticalInset,
                leading: CurrencyPickerMetrics.cellHorizontalInset,
                bottom: CurrencyPickerMetrics.cellVerticalInset,
                trailing: CurrencyPickerMetrics.cellHorizontalInset
            )

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo:
                contentView.layoutMarginsGuide.topAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo:
                contentView.layoutMarginsGuide.leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo:
                contentView.layoutMarginsGuide.trailingAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo:
                contentView.layoutMarginsGuide.bottomAnchor
            )
        ])
    }
}
