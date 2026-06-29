//
//  HTTPClient.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

public protocol HTTPClient: Sendable {
    func send<Response: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as responseType: Response.Type
    ) async throws -> Response
}
