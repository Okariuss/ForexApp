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

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.font = RateListTypography.amountLabel
        label.textColor = RateListColor.amountLabel
        label.adjustsFontForContentSizeCategory = true
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
        button.accessibilityHint =
            "Opens the currency selection list."
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
        textField.accessibilityLabel = "Amount"
        textField.addTarget(
            self,
            action: #selector(amountDidChange),
            for: .editingChanged
        )
        return textField
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
                baseCurrencyButton,
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
        baseCurrencyButton.configuration?.title =
            "Base: \(baseCurrencyText)"

        if amountTextField.text != amountText {
            amountTextField.text = amountText
        }

        updatedAtLabel.text =
            "Updated: \(updatedAtText)"
    }
}

private extension RateListHeaderView {
    func setupView() {
        addSubview(stackView)
        translatesAutoresizingMaskIntoConstraints = false

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

    @objc func amountDidChange() {
        onAmountChange?(amountTextField.text ?? "")
    }

    @objc func baseCurrencyTapped() {
        onBaseCurrencySelection?()
    }
}
