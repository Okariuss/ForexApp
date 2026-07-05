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
    @Test func headerExposesControlsWithoutDuplicateLabels() throws {
        let sut = RateListHeaderView()

        sut.configure(
            baseCurrencyText: "USD",
            amountText: "1",
            updatedAtText: "12:00"
        )

        let button = try #require(
            firstSubview(of: UIButton.self, in: sut)
        )
        let textField = try #require(
            firstSubview(of: UITextField.self, in: sut)
        )
        let labels = subviews(of: UILabel.self, in: sut)

        #expect(button.accessibilityLabel == "Base currency")
        #expect(button.accessibilityValue == "USD")
        #expect(
            button.accessibilityHint == "Opens the currency selection list."
        )
        #expect(textField.accessibilityLabel == "Amount")
        #expect(
            textField.accessibilityHint == "Enter the amount to convert."
        )
        #expect(
            labels
                .first { $0.text == "Base:" }?
                .isAccessibilityElement == false
        )
        #expect(
            labels
                .first { $0.text == "Amount" }?
                .isAccessibilityElement == false
        )
    }
}

@MainActor
private extension RateListHeaderAccessibilityTests {
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
