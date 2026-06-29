//
//  HTTPDataLoader.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

public protocol HTTPDataLoader: Sendable {
    func load(
        _ request: URLRequest
    ) async throws -> (Data, URLResponse)
}

public struct URLSessionDataLoader: HTTPDataLoader {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func load(
        _ request: URLRequest
    ) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
