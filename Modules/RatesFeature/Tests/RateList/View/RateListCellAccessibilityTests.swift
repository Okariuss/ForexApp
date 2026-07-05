//
//  RateListCellAccessibilityTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import RatesFeature
import Testing
import UIKit

@MainActor
struct RateListCellAccessibilityTests {
    @Test func configuredCellExposesRateAsSingleElement() {
        let sut = RateListCell(frame: .zero)

        sut.configure(
            with: RateListItem(
                id: "EUR",
                currencyCodeText: "EUR",
                rateValueText: "0.85"
            )
        )

        #expect(sut.isAccessibilityElement)
        #expect(sut.accessibilityLabel == "EUR")
        #expect(sut.accessibilityValue == "0.85")
        #expect(sut.accessibilityTraits.contains(.staticText))
    }

    @Test func reuseClearsAccessibilityContent() {
        let sut = RateListCell(frame: .zero)

        sut.configure(
            with: RateListItem(
                id: "EUR",
                currencyCodeText: "EUR",
                rateValueText: "0.85"
            )
        )

        sut.prepareForReuse()

        #expect(sut.accessibilityLabel == nil)
        #expect(sut.accessibilityValue == nil)
    }
}
