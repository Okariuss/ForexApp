//
//  DecimalMacro.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DecimalMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in _: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let argument =
            node.arguments.first?.expression,
            let segments = argument
            .as(StringLiteralExprSyntax.self)?
            .segments,
            segments.count == 1,
            case let .stringSegment(segment)? =
            segments.first
        else {
            throw DecimalMacroError
                .requiresStaticStringLiteral
        }

        let value = segment.content.text
        let locale = Locale(
            identifier: "en_US_POSIX"
        )

        guard Decimal(
            string: value,
            locale: locale
        ) != nil else {
            throw DecimalMacroError.malformedDecimal(
                value: value
            )
        }

        return """
        Foundation.Decimal(
            string: \(argument),
            locale: Foundation.Locale(
                identifier: "en_US_POSIX"
            )
        )!
        """
    }
}

enum DecimalMacroError: Error, CustomStringConvertible {
    case requiresStaticStringLiteral
    case malformedDecimal(value: String)

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            "#Decimal requires a static string literal."

        case let .malformedDecimal(value):
            "The input is not a valid decimal: \(value)"
        }
    }
}
