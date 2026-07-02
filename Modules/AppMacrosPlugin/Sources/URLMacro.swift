//
//  URLMacro.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in _: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let argument = node.arguments.first?.expression,
            let segments = argument
            .as(StringLiteralExprSyntax.self)?
            .segments,
            segments.count == 1,
            case let .stringSegment(segment)? =
            segments.first
        else {
            throw URLMacroError
                .requiresStaticStringLiteral
        }

        let value = segment.content.text

        guard Foundation.URL(string: value) != nil else {
            throw URLMacroError.malformedURL(
                urlString: value
            )
        }

        return """
        Foundation.URL(string: \(argument))!
        """
    }
}

enum URLMacroError: Error, CustomStringConvertible {
    case requiresStaticStringLiteral
    case malformedURL(urlString: String)

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            "#URL requires a static string literal."

        case let .malformedURL(urlString):
            "The input URL is not valid: \(urlString)"
        }
    }
}
