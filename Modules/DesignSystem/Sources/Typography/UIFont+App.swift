//
//  UIFont+App.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

public extension UIFont {
    static func appFont(
        token: TypographyToken,
        weight: UIFont.Weight,
        width: UIFont.Width = .standard,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        let baseFont = UIFont.systemFont(
            ofSize: token.pointSize,
            weight: weight,
            width: width
        )

        return UIFontMetrics(
            forTextStyle: token.textStyle
        ).scaledFont(
            for: baseFont,
            compatibleWith: traitCollection
        )
    }

    static func appMonospacedDigitFont(
        token: TypographyToken,
        weight: UIFont.Weight,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        let baseFont = UIFont.monospacedDigitSystemFont(
            ofSize: token.pointSize,
            weight: weight
        )

        return UIFontMetrics(
            forTextStyle: token.textStyle
        ).scaledFont(
            for: baseFont,
            compatibleWith: traitCollection
        )
    }
}
