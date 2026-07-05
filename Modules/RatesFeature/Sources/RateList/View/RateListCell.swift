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
        label.numberOfLines = 0
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
        label.numberOfLines = 0
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

        rateValueLabel.layer.removeAllAnimations()
        currencyCodeLabel.text = nil
        rateValueLabel.text = nil
        accessibilityLabel = nil
        accessibilityValue = nil
    }

    func configure(with item: RateListItem) {
        currencyCodeLabel.text = item.currencyCodeText
        updateRateValue(item.rateValueText)
        accessibilityLabel = item.currencyCodeText
        accessibilityValue = item.rateValueText
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

        isAccessibilityElement = true
        accessibilityTraits = .staticText
        contentView.isAccessibilityElement = false
        currencyCodeLabel.isAccessibilityElement = false
        rateValueLabel.isAccessibilityElement = false

        updateLayoutForContentSizeCategory()

        registerForTraitChanges(
            [UITraitPreferredContentSizeCategory.self]
        ) { (cell: RateListCell, _) in
            cell.updateLayoutForContentSizeCategory()
        }

        rateStackView.addArrangedSubview(currencyCodeLabel)
        rateStackView.addArrangedSubview(rateValueLabel)
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

    func updateLayoutForContentSizeCategory() {
        let usesVerticalLayout =
            traitCollection.preferredContentSizeCategory
                .isAccessibilityCategory

        rateStackView.axis =
            usesVerticalLayout ? .vertical : .horizontal
        rateStackView.alignment =
            usesVerticalLayout ? .leading : .firstBaseline
        rateValueLabel.textAlignment =
            usesVerticalLayout ? .left : .right
    }

    func updateRateValue(_ text: String) {
        guard rateValueLabel.text != text else {
            return
        }

        guard
            rateValueLabel.text != nil,
            !UIAccessibility.isReduceMotionEnabled
        else {
            rateValueLabel.text = text
            return
        }

        UIView.transition(
            with: rateValueLabel,
            duration:
            RateListAnimation.rateValueTransitionDuration,
            options: [
                .transitionCrossDissolve,
                .beginFromCurrentState
            ],
            animations: {
                self.rateValueLabel.text = text
            }
        )
    }
}
