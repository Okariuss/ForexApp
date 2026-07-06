//
//  RateListCellSnapshotTests.swift
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
struct RateListCellSnapshotTests {
    @Test func displaysRateInLightMode() {
        let subject = makeSubject()

        assertSnapshot(
            of: subject,
            as: .image(
                size: SnapshotCellSize.rateList,
                traits: makeTraits(style: .light)
            )
        )
    }

    @Test func displaysRateInDarkMode() {
        let subject = makeSubject()

        assertSnapshot(
            of: subject,
            as: .image(
                size: SnapshotCellSize.rateList,
                traits: makeTraits(style: .dark)
            )
        )
    }

    @Test func displaysRateWithAccessibilityTextSizeInLightMode() {
        let subject = makeSubject()

        assertSnapshot(
            of: subject,
            as: .image(
                size:
                SnapshotCellSize.accessibilityRateList,
                traits: makeTraits(
                    style: .light,
                    contentSizeCategory:
                    .accessibilityExtraExtraExtraLarge
                )
            )
        )
    }

    @Test func displaysRateWithAccessibilityTextSizeInDarkMode() {
        let subject = makeSubject()

        assertSnapshot(
            of: subject,
            as: .image(
                size:
                SnapshotCellSize.accessibilityRateList,
                traits: makeTraits(
                    style: .dark,
                    contentSizeCategory:
                    .accessibilityExtraExtraExtraLarge
                )
            )
        )
    }

    private func makeSubject() -> RateListCell {
        let cell = RateListCell(frame: .zero)

        cell.configure(
            with: RateListItem(
                id: "TRY",
                currencyCodeText: "TRY",
                rateValueText: "32.2500"
            )
        )

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
    static let rateList = CGSize(
        width: 390,
        height: 64
    )

    static let accessibilityRateList = CGSize(
        width: 390,
        height: 200
    )
}
