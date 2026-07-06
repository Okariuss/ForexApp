//
//  RateListHeaderSnapshotTests.swift
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
struct RateListHeaderSnapshotTests {
    @Test func displaysHeaderInLightMode() {
        let subject = makeSubject()

        assertSnapshot(
            of: subject,
            as: .image(
                size: RateListHeaderSnapshotSize.regular,
                traits: makeTraits(style: .light)
            )
        )
    }

    @Test func displaysHeaderInDarkMode() {
        let subject = makeSubject()

        assertSnapshot(
            of: subject,
            as: .image(
                size: RateListHeaderSnapshotSize.regular,
                traits: makeTraits(style: .dark)
            )
        )
    }

    private func makeSubject() -> RateListHeaderView {
        let headerView = RateListHeaderView()
        headerView.backgroundColor = .systemBackground
        headerView.configure(
            baseCurrencyText: "USD",
            amountText: "1,000.50",
            updatedAtText: "Jul 5, 2026 at 12:34 PM"
        )

        return headerView
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

private enum RateListHeaderSnapshotSize {
    static let regular = CGSize(
        width: 358,
        height: 100
    )
}
