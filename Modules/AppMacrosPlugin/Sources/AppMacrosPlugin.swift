//
//  AppMacrosPlugin.swift
//  ForexApp
//
//  Created by Okan Orkun on 1.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AppMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
        DecimalMacro.self
    ]
}
