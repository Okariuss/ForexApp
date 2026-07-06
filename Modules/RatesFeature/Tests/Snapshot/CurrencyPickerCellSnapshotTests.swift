//
//  CurrencyPickerCellSnapshotTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 6.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import RatesFeature
import SnapshotTesting
import Testing
import UIKit

@MainActor
@Suite(.serialized)
struct CurrencyPickerCellSnapshotTests {
    @Test func displaysSelectedCurrencyInLightMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "TRY",
                codeText: "TRY",
                nameText: "Turkish Lira",
                isSelected: true
            )
        )

        assertSnapshot(
            of: subject,
            as: .image(
                size: SnapshotCellSize.currencyPicker,
                traits: makeTraits(style: .light)
            )
        )
    }

    @Test func displaysSelectedCurrencyInDarkMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "TRY",
                codeText: "TRY",
                nameText: "Turkish Lira",
                isSelected: true
            )
        )

        assertSnapshot(
            of: subject,
            as: .image(
                size: SnapshotCellSize.currencyPicker,
                traits: makeTraits(style: .dark)
            )
        )
    }

    @Test func displaysUnselectedCurrencyInLightMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "EUR",
                codeText: "EUR",
                nameText: "Euro",
                isSelected: false
            )
        )

        assertSnapshot(
            of: subject,
            as: .image(
                size: SnapshotCellSize.currencyPicker,
                traits: makeTraits(style: .light)
            )
        )
    }

    @Test func displaysUnselectedCurrencyInDarkMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "EUR",
                codeText: "EUR",
                nameText: "Euro",
                isSelected: false
            )
        )

        assertSnapshot(
            of: subject,
            as: .image(
                size: SnapshotCellSize.currencyPicker,
                traits: makeTraits(style: .dark)
            )
        )
    }

    @Test func displaysSelectedCurrencyWithAccessibilityTextSizeInLightMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "USD",
                codeText: "USD",
                nameText: "United States Dollar",
                isSelected: true
            )
        )

        let traits = UITraitCollection { traits in
            traits.userInterfaceStyle = .light
            traits.preferredContentSizeCategory =
                .accessibilityExtraExtraExtraLarge
        }

        assertSnapshot(
            of: subject,
            as: .image(
                size:
                SnapshotCellSize.accessibilityCurrencyPicker,
                traits: traits
            )
        )
    }

    @Test func displaysSelectedCurrencyWithAccessibilityTextSizeInDarkMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "USD",
                codeText: "USD",
                nameText: "United States Dollar",
                isSelected: true
            )
        )

        let traits = UITraitCollection { traits in
            traits.userInterfaceStyle = .dark
            traits.preferredContentSizeCategory =
                .accessibilityExtraExtraExtraLarge
        }

        assertSnapshot(
            of: subject,
            as: .image(
                size:
                SnapshotCellSize.accessibilityCurrencyPicker,
                traits: traits
            )
        )
    }

    @Test func displaysUnselectedCurrencyWithAccessibilityTextSizeInLightMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "USD",
                codeText: "USD",
                nameText: "United States Dollar",
                isSelected: false
            )
        )

        let traits = UITraitCollection { traits in
            traits.userInterfaceStyle = .light
            traits.preferredContentSizeCategory =
                .accessibilityExtraExtraExtraLarge
        }

        assertSnapshot(
            of: subject,
            as: .image(
                size:
                SnapshotCellSize.accessibilityCurrencyPicker,
                traits: traits
            )
        )
    }

    @Test func displaysUnselectedCurrencyWithAccessibilityTextSizeInDarkMode() {
        let subject = makeSubject(
            item: CurrencyPickerItem(
                id: "USD",
                codeText: "USD",
                nameText: "United States Dollar",
                isSelected: false
            )
        )

        let traits = UITraitCollection { traits in
            traits.userInterfaceStyle = .dark
            traits.preferredContentSizeCategory =
                .accessibilityExtraExtraExtraLarge
        }

        assertSnapshot(
            of: subject,
            as: .image(
                size:
                SnapshotCellSize.accessibilityCurrencyPicker,
                traits: traits
            )
        )
    }

    private func makeSubject(
        item: CurrencyPickerItem
    ) -> CurrencyPickerCell {
        let cell = CurrencyPickerCell(
            style: .default,
            reuseIdentifier:
            CurrencyPickerCell.reuseIdentifier
        )
        cell.backgroundColor = .systemBackground
        cell.configure(with: item)

        return cell
    }

    private func makeTraits(
        style: UIUserInterfaceStyle,
        contentSizeCategory:
        UIContentSizeCategory = .large
    ) -> UITraitCollection {
        UITraitCollection { traits in
            traits.userInterfaceStyle = style
            traits.preferredContentSizeCategory =
                contentSizeCategory
        }
    }
}

private enum SnapshotCellSize {
    static let currencyPicker = CGSize(
        width: 390,
        height: 64
    )

    static let accessibilityCurrencyPicker = CGSize(
        width: 390,
        height: 240
    )
}
