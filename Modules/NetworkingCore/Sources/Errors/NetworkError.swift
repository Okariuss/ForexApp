//
//  NetworkError.swift
//  ForexApp
//
//  Created by Okan Orkun on 27.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

public enum NetworkError: Error, Equatable {
    case invalidResponse
    case unacceptableStatusCode(Int)
    case transport
    case decoding
}
