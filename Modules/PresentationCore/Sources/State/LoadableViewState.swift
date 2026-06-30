//
//  LoadableViewState.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

public enum LoadableViewState<Content: Equatable & Sendable>: Equatable, Sendable {
    case idle
    case loading
    case content(Content)
    case empty
    case error
}
