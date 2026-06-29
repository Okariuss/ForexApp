//
//  ExchangeRateAPIResponse.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

struct ExchangeRateAPIResponse: Decodable, Equatable {
    let result: String
    let baseCode: String?
    let timeLastUpdateUnix: Int?
    let rates: [String: Decimal]?
    let errorType: String?

    private enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case timeLastUpdateUnix = "time_last_update_unix"
        case rates
        case errorType = "error-type"
    }
}
