//
//  TypographyToken.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

public struct TypographyToken: Sendable {
    let pointSize: CGFloat
    let textStyle: UIFont.TextStyle

    private init(
        pointSize: CGFloat,
        textStyle: UIFont.TextStyle
    ) {
        self.pointSize = pointSize
        self.textStyle = textStyle
    }

    public static let display = TypographyToken(
        pointSize: 34,
        textStyle: .largeTitle
    )

    public static let title = TypographyToken(
        pointSize: 22,
        textStyle: .title2
    )

    public static let headline = TypographyToken(
        pointSize: 17,
        textStyle: .headline
    )

    public static let body = TypographyToken(
        pointSize: 17,
        textStyle: .body
    )

    public static let bodySmall = TypographyToken(
        pointSize: 15,
        textStyle: .subheadline
    )

    public static let caption = TypographyToken(
        pointSize: 12,
        textStyle: .caption1
    )
}
