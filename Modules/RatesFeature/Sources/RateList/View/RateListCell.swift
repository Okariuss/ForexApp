//
//  RateListCell.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

@MainActor
final class RateListCell: UICollectionViewCell {
    private let rateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing =
            RateListMetrics.cellContentSpacing
        stackView.translatesAutoresizingMaskIntoConstraints =
            false
        return stackView
    }()

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = RateListTypography.currencyCode
        label.textColor = RateListColor.currencyCode
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(
            .required,
            for: .horizontal
        )
        return label
    }()

    private let rateValueLabel: UILabel = {
        let label = UILabel()
        label.font = RateListTypography.rateValue
        label.textColor = RateListColor.rateValue
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        currencyCodeLabel.text = nil
        rateValueLabel.text = nil
    }

    func configure(with item: RateListItem) {
        currencyCodeLabel.text = item.currencyCodeText
        rateValueLabel.text = item.rateValueText
    }
}

private extension RateListCell {
    func setupView() {
        contentView.backgroundColor =
            RateListColor.cellBackground
        contentView.directionalLayoutMargins =
            NSDirectionalEdgeInsets(
                top: RateListMetrics.cellVerticalInset,
                leading: RateListMetrics.cellHorizontalInset,
                bottom: RateListMetrics.cellVerticalInset,
                trailing: RateListMetrics.cellHorizontalInset
            )

        rateStackView.addArrangedSubview(
            currencyCodeLabel
        )
        rateStackView.addArrangedSubview(
            rateValueLabel
        )
        contentView.addSubview(rateStackView)

        NSLayoutConstraint.activate([
            rateStackView.topAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.topAnchor
            ),
            rateStackView.leadingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.leadingAnchor
            ),
            rateStackView.trailingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.trailingAnchor
            ),
            rateStackView.bottomAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.bottomAnchor
            )
        ])
    }
}
