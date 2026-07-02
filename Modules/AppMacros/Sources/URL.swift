//
//  URL.swift
//  ForexApp
//
//  Created by Okan Orkun on 2.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

/// Creates a URL from a validated string literal.
///
///     let url = #URL("https://example.com")
@freestanding(expression)
public macro URL(
    _ stringLiteral: String
) -> URL = #externalMacro(
    module: "AppMacrosPlugin",
    type: "URLMacro"
)
