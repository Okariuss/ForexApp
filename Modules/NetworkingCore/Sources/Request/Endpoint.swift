//
//  Endpoint.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let queryItems: [URLQueryItem]
    public let headers: [String: String]

    public init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:]
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
    }

    public func makeRequest(baseURL: URL) -> URLRequest {
        var url = baseURL.appending(path: path)

        if !queryItems.isEmpty {
            url = url.appending(queryItems: queryItems)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
