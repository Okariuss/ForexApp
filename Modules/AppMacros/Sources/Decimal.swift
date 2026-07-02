//
//  Decimal.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

/// Creates a Decimal from a validated string literal.
///
///     let amount = #Decimal("32.25")
@freestanding(expression)
public macro Decimal(
    _ stringLiteral: String
) -> Decimal = #externalMacro(
    module: "AppMacrosPlugin",
    type: "DecimalMacro"
)
