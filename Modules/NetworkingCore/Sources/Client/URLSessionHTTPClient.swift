//
//  URLSessionHTTPClient.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
import OSLog

public final class URLSessionHTTPClient: HTTPClient, Sendable {
    private let baseURL: URL
    private let dataLoader: any HTTPDataLoader
    private let logger: Logger

    public init(
        baseURL: URL,
        dataLoader: any HTTPDataLoader = URLSessionDataLoader()
    ) {
        self.baseURL = baseURL
        self.dataLoader = dataLoader
        logger = Logger(
            subsystem: "com.okarius.forexapp",
            category: "Networking"
        )
    }

    public func send<Response: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as _: Response.Type
    ) async throws -> Response {
        let request = endpoint.makeRequest(baseURL: baseURL)

        logger.debug(
            """
            Sending \(endpoint.method.rawValue, privacy: .public)
            request to \(endpoint.path, privacy: .public)
            """
        )

        do {
            let (data, response) = try await dataLoader.load(request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                throw NetworkError.unacceptableStatusCode(
                    httpResponse.statusCode
                )
            }

            return try JSONDecoder().decode(Response.self, from: data)
        } catch let decodingError as DecodingError {
            logger
                .error(
                    """
                    Response decoding failed:
                    \(decodingError.localizedDescription, privacy: .private)
                    """
                )
            throw NetworkError.decoding
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch let error as NetworkError {
            throw error
        } catch {
            logger.error("Request failed: \(error.localizedDescription, privacy: .private)")
            throw NetworkError.transport
        }
    }
}
