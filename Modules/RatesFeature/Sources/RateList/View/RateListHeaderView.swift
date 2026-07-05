//
//  RateListHeaderView.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

@MainActor
final class RateListHeaderView: UIView {
    var onAmountChange: ((String) -> Void)?
    var onBaseCurrencySelection: (() -> Void)?

    private let baseLabel: UILabel = {
        let label = UILabel()
        label.text = RatesFeatureStrings.baseLabel
        label.font = RateListTypography.headerBaseCurrency
        label.textColor = RateListColor.headerBaseCurrency
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = RatesFeatureStrings.amountLabel
        label.font = RateListTypography.amountLabel
        label.textColor = RateListColor.amountLabel
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()

    private let updatedAtLabel: UILabel = {
        let label = UILabel()
        label.font =
            RateListTypography.headerUpdatedAt
        label.textColor =
            RateListColor.headerUpdatedAt
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let baseCurrencySpacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(
            .defaultLow,
            for: .horizontal
        )
        view.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )
        return view
    }()

    private lazy var baseCurrencyButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(
            systemName: "chevron.down"
        )
        configuration.imagePlacement = .trailing
        configuration.imagePadding =
            RateListMetrics.headerContentSpacing
        configuration.contentInsets = .zero
        configuration.baseForegroundColor =
            RateListColor.headerBaseCurrency

        configuration.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { attributes in
                var attributes = attributes
                attributes.font =
                    RateListTypography.headerBaseCurrency
                return attributes
            }

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.setContentHuggingPriority(
            .required,
            for: .horizontal
        )
        button.accessibilityHint =
            RatesFeatureStrings.baseCurrencyAccessibilityHint
        button.addTarget(
            self,
            action: #selector(baseCurrencyTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.font = RateListTypography.amountValue
        textField.textColor = RateListColor.amountValue
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontForContentSizeCategory = true
        textField.accessibilityLabel = RatesFeatureStrings.amountAccessibilityLabel
        textField.accessibilityHint = RatesFeatureStrings.amountAccessibilityHint
        textField.addTarget(
            self,
            action: #selector(amountDidChange),
            for: .editingChanged
        )
        return textField
    }()

    private lazy var baseCurrencyStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                baseLabel,
                baseCurrencySpacerView,
                baseCurrencyButton
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing =
            RateListMetrics.headerContentSpacing
        return stackView
    }()

    private lazy var amountStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                amountLabel,
                amountTextField
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing =
            RateListMetrics.headerContentSpacing
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                baseCurrencyStackView,
                amountStackView,
                updatedAtLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing =
            RateListMetrics.headerContentSpacing
        stackView.translatesAutoresizingMaskIntoConstraints =
            false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder _: NSCoder) {
        nil
    }

    func configure(
        baseCurrencyText: String,
        amountText: String,
        updatedAtText: String
    ) {
        updateBaseCurrency(baseCurrencyText)

        if amountTextField.text != amountText {
            amountTextField.text = amountText
        }

        updatedAtLabel.text =
            RatesFeatureStrings.updatedAt(updatedAtText)
    }

    func currencyCodeFrame(
        in containerView: UIView
    ) -> CGRect {
        layoutIfNeeded()

        let transitionView =
            baseCurrencyButton.titleLabel ??
            baseCurrencyButton

        return transitionView.convert(
            transitionView.bounds,
            to: containerView
        )
    }

    func currencyCodeSnapshot() -> UIView? {
        layoutIfNeeded()

        let transitionView =
            baseCurrencyButton.titleLabel ??
            baseCurrencyButton

        return transitionView.snapshotView(
            afterScreenUpdates: false
        )
    }

    func setCurrencyCodeAlpha(_ alpha: CGFloat) {
        baseCurrencyButton.titleLabel?.alpha = alpha
    }

    func updateBaseCurrency(_ text: String) {
        baseCurrencyButton.configuration?.title = text
        baseCurrencyButton.accessibilityLabel = RatesFeatureStrings.baseCurrencyAccessibilityLabel
        baseCurrencyButton.accessibilityValue = text
    }
}

private extension RateListHeaderView {
    func setupView() {
        addSubview(stackView)
        translatesAutoresizingMaskIntoConstraints = false

        updateLayoutForContentSizeCategory()

        registerForTraitChanges(
            [UITraitPreferredContentSizeCategory.self]
        ) { (headerView: RateListHeaderView, _) in
            UIView.performWithoutAnimation {
                headerView.updateLayoutForContentSizeCategory()
                headerView.superview?.layoutIfNeeded()
            }
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
    }

    func updateLayoutForContentSizeCategory() {
        let usesVerticalLayout =
            traitCollection.preferredContentSizeCategory
                .isAccessibilityCategory

        baseCurrencySpacerView.isHidden = usesVerticalLayout

        baseCurrencyStackView.axis =
            usesVerticalLayout ? .vertical : .horizontal
        baseCurrencyStackView.alignment =
            usesVerticalLayout ? .leading : .firstBaseline

        amountStackView.axis =
            usesVerticalLayout ? .vertical : .horizontal
        amountStackView.alignment =
            usesVerticalLayout ? .fill : .center

        amountTextField.textAlignment =
            usesVerticalLayout ? .left : .right
    }

    @objc func amountDidChange() {
        onAmountChange?(amountTextField.text ?? "")
    }

    @objc func baseCurrencyTapped() {
        onBaseCurrencySelection?()
    }
}
