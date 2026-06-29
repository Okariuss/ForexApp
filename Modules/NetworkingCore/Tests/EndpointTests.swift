//
//  EndpointTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import NetworkingCore
import Testing

struct EndpointTests {
    @Test func makeRequestIncludesEndpointValues() throws {
        let baseURL = try #require(
            URL(string: "https://api.example.com/v1")
        )

        let queryItems = [
            URLQueryItem(name: "base", value: "USD"),
            URLQueryItem(name: "symbols", value: "TRY,EUR")
        ]

        let sut = Endpoint(
            path: "latest",
            method: .get,
            queryItems: queryItems,
            headers: ["Accept": "application/json"]
        )

        let request = sut.makeRequest(baseURL: baseURL)
        let requestURL = try #require(request.url)
        let components = try #require(
            URLComponents(
                url: requestURL,
                resolvingAgainstBaseURL: false
            )
        )

        #expect(components.scheme == "https")
        #expect(components.host == "api.example.com")
        #expect(components.path == "/v1/latest")
        #expect(components.queryItems == queryItems)
        #expect(request.httpMethod == "GET")
        #expect(
            request.value(forHTTPHeaderField: "Accept") ==
                "application/json"
        )
    }

    @Test func defaultValuesCreateGetRequest() throws {
        let baseURL = try #require(
            URL(string: "https://api.example.com")
        )
        let subject = Endpoint(path: "health")

        let request = subject.makeRequest(baseURL: baseURL)

        #expect(request.httpMethod == "GET")
        #expect(request.url?.path == "/health")
        #expect(request.url?.query == nil)
        #expect(request.allHTTPHeaderFields?.isEmpty != false)
    }
}
