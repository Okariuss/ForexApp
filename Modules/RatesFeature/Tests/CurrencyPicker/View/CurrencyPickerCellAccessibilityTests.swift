//
//  CurrencyPickerCellAccessibilityTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import RatesFeature
import Testing
import UIKit

@MainActor
struct CurrencyPickerCellAccessibilityTests {
    @Test func configuredCellExposesCurrencyAsSingleButton() {
        let sut = makeSubject(isSelected: false)

        #expect(sut.isAccessibilityElement)
        #expect(
            sut.accessibilityLabel == "USD, US Dollar"
        )
        #expect(
            sut.accessibilityHint == "Sets USD as the base currency."
        )
        #expect(
            sut.accessibilityTraits.contains(.button)
        )
        #expect(
            !sut.accessibilityTraits.contains(.selected)
        )
    }

    @Test func selectedCurrencyExposesSelectedTrait() {
        let sut = makeSubject(isSelected: true)

        #expect(
            sut.accessibilityTraits.contains(.button)
        )
        #expect(
            sut.accessibilityTraits.contains(.selected)
        )
    }

    @Test func reconfigurationRemovesSelectedTrait() {
        let sut = makeSubject(isSelected: true)

        sut.configure(
            with: CurrencyPickerItem(
                id: "USD",
                codeText: "USD",
                nameText: "US Dollar",
                isSelected: false
            )
        )

        #expect(
            !sut.accessibilityTraits.contains(.selected)
        )
    }

    @Test func reuseClearsAccessibilityContent() {
        let sut = makeSubject(isSelected: true)

        sut.prepareForReuse()

        #expect(sut.accessibilityLabel == nil)
        #expect(sut.accessibilityHint == nil)
        #expect(
            !sut.accessibilityTraits.contains(.selected)
        )
    }
}

private extension CurrencyPickerCellAccessibilityTests {
    func makeSubject(
        isSelected: Bool
    ) -> CurrencyPickerCell {
        let sut = CurrencyPickerCell(
            style: .default,
            reuseIdentifier:
            CurrencyPickerCell.reuseIdentifier
        )

        sut.configure(
            with: CurrencyPickerItem(
                id: "USD",
                codeText: "USD",
                nameText: "US Dollar",
                isSelected: isSelected
            )
        )

        return sut
    }
}
