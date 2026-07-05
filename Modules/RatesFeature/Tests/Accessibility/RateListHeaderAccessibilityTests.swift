//
//  RateListHeaderAccessibilityTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import RatesFeature
import Testing
import UIKit

@MainActor
struct RateListHeaderAccessibilityTests {
    @Test func headerExposesLocalizedControlMetadata() throws {
        let sut = makeSubject()

        let button = try #require(
            firstSubview(of: UIButton.self, in: sut)
        )
        let textField = try #require(
            firstSubview(of: UITextField.self, in: sut)
        )

        #expect(
            button.accessibilityLabel ==
                RatesFeatureStrings.baseCurrencyAccessibilityLabel
        )
        #expect(button.accessibilityValue == "USD")
        #expect(
            button.accessibilityHint ==
                RatesFeatureStrings.baseCurrencyAccessibilityHint
        )
        #expect(
            textField.accessibilityLabel ==
                RatesFeatureStrings.amountAccessibilityLabel
        )
        #expect(
            textField.accessibilityHint ==
                RatesFeatureStrings.amountAccessibilityHint
        )
    }

    @Test func visualLabelsAreNotAccessibilityElements() {
        let sut = makeSubject()
        let labels = subviews(of: UILabel.self, in: sut)

        #expect(
            labels
                .first {
                    $0.text == RatesFeatureStrings.baseLabel
                }?
                .isAccessibilityElement == false
        )
        #expect(
            labels
                .first {
                    $0.text == RatesFeatureStrings.amountLabel
                }?
                .isAccessibilityElement == false
        )
    }
}

@MainActor
private extension RateListHeaderAccessibilityTests {
    func makeSubject() -> RateListHeaderView {
        let sut = RateListHeaderView()

        sut.configure(
            baseCurrencyText: "USD",
            amountText: "1",
            updatedAtText: "12:00"
        )

        return sut
    }

    func firstSubview<T: UIView>(
        of type: T.Type,
        in view: UIView
    ) -> T? {
        subviews(
            of: type,
            in: view
        ).first
    }

    func subviews<T: UIView>(
        of type: T.Type,
        in view: UIView
    ) -> [T] {
        view.subviews.flatMap { subview in
            let match = subview as? T

            return [match].compactMap(\.self) +
                subviews(
                    of: type,
                    in: subview
                )
        }
    }
}
