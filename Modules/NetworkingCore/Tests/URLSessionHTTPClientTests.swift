//
//  URLSessionHTTPClientTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import NetworkingCore
import Testing

struct URLSessionHTTPClientTests {
    @Test func successResponseIsDecoded() async throws {
        let data = Data(
            #"{"message":"Success"}"#.utf8
        )
        let sut = try makeSubject(
            data: data,
            statusCode: 200
        )

        let response = try await sut.send(
            Endpoint(path: "status"),
            as: MessageResponse.self
        )

        #expect(response.message == "Success")
    }

    @Test func errorStatusThrowsNetworkError() async throws {
        let sut = try makeSubject(
            data: Data(),
            statusCode: 500
        )

        do {
            let _: MessageResponse = try await sut.send(
                Endpoint(path: "status"),
                as: MessageResponse.self
            )
            Issue.record("Expected a network error.")
        } catch let error as NetworkError {
            #expect(
                error == .unacceptableStatusCode(500)
            )
        }
    }

    @Test func invalidDataThrowsDecodingError() async throws {
        let sut = try makeSubject(
            data: Data("Invalid JSON".utf8),
            statusCode: 200
        )

        do {
            let _: MessageResponse = try await sut.send(
                Endpoint(path: "status"),
                as: MessageResponse.self
            )
            Issue.record("Expected a decoding error.")
        } catch let error as NetworkError {
            #expect(error == .decoding)
        }
    }

    @Test func loaderErrorBecomesTransportError() async throws {
        let sut = try makeSubject(
            dataLoader: FailingHTTPDataLoaderStub(
                failure: .transport
            )
        )

        do {
            let _: MessageResponse = try await sut.send(
                Endpoint(path: "status"),
                as: MessageResponse.self
            )
            Issue.record("Expected a transport error.")
        } catch let error as NetworkError {
            #expect(error == .transport)
        }
    }

    @Test func cancellationStaysCancellationError() async throws {
        let sut = try makeSubject(
            dataLoader: FailingHTTPDataLoaderStub(
                failure: .cancellation
            )
        )

        do {
            let _: MessageResponse = try await sut.send(
                Endpoint(path: "status"),
                as: MessageResponse.self
            )
            Issue.record("Expected a cancellation error.")
        } catch is CancellationError {
            // The expected error was received.
        } catch {
            Issue.record("Received an unexpected error.")
        }
    }

    private func makeSubject(
        data: Data,
        statusCode: Int
    ) throws -> URLSessionHTTPClient {
        let baseURL = try #require(
            URL(string: "https://api.example.com")
        )
        let response = try #require(
            HTTPURLResponse(
                url: baseURL,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
        )
        let dataLoader = HTTPDataLoaderStub(
            data: data,
            response: response
        )

        return URLSessionHTTPClient(
            baseURL: baseURL,
            dataLoader: dataLoader
        )
    }

    private func makeSubject(
        dataLoader: any HTTPDataLoader
    ) throws -> URLSessionHTTPClient {
        let baseURL = try #require(
            URL(string: "https://api.example.com")
        )

        return URLSessionHTTPClient(
            baseURL: baseURL,
            dataLoader: dataLoader
        )
    }
}

private struct HTTPDataLoaderStub: HTTPDataLoader, @unchecked Sendable {
    let data: Data
    let response: URLResponse

    func load(
        _: URLRequest
    ) async throws -> (Data, URLResponse) {
        (data, response)
    }
}

private struct MessageResponse: Decodable {
    let message: String
}

private struct FailingHTTPDataLoaderStub: HTTPDataLoader {
    enum Failure {
        case transport
        case cancellation
    }

    let failure: Failure

    func load(
        _: URLRequest
    ) async throws -> (Data, URLResponse) {
        switch failure {
        case .transport:
            throw URLError(.notConnectedToInternet)
        case .cancellation:
            throw CancellationError()
        }
    }
}
