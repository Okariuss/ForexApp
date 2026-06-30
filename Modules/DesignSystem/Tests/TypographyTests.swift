//
//  TypographyTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct TypographyTests {
    @Test func fontGrowsForAccessibilityCategory() {
        let standardTraits = UITraitCollection(
            preferredContentSizeCategory: .large
        )
        let accessibilityTraits = UITraitCollection(
            preferredContentSizeCategory:
            .accessibilityExtraExtraExtraLarge
        )

        let standardFont = UIFont.appFont(
            token: .body,
            weight: .regular,
            compatibleWith: standardTraits
        )
        let accessibilityFont = UIFont.appFont(
            token: .body,
            weight: .regular,
            compatibleWith: accessibilityTraits
        )

        #expect(
            accessibilityFont.pointSize >
                standardFont.pointSize
        )
    }
}
