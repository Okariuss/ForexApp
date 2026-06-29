//
//  ExchangeRateAPIResponseTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 29.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation
@testable import RatesData
import Testing

struct ExchangeRateAPIResponseTests {
    @Test func successResponseIsDecoded() throws {
        let data = Data(
            #"""
            {
                "result": "success",
                "base_code": "USD",
                "time_last_update_unix": 1700000000,
                "rates": {
                    "EUR": 0.878247,
                    "TRY": 46.604401
                }
            }
            """#.utf8
        )

        let sut = try JSONDecoder().decode(
            ExchangeRateAPIResponse.self,
            from: data
        )

        #expect(sut.result == "success")
        #expect(sut.baseCode == "USD")
        #expect(sut.timeLastUpdateUnix == 1_700_000_000)
        #expect(sut.rates?["EUR"] == Decimal(string: "0.878247"))
        #expect(sut.rates?["TRY"] == Decimal(string: "46.604401"))
    }

    @Test func errorResponseIsDecoded() throws {
        let data = Data(
            #"""
            {
                "result": "error",
                "error-type": "unsupported-code"
            }
            """#.utf8
        )

        let sut = try JSONDecoder().decode(
            ExchangeRateAPIResponse.self,
            from: data
        )

        #expect(sut.result == "error")
        #expect(sut.errorType == "unsupported-code")
        #expect(sut.baseCode == nil)
        #expect(sut.timeLastUpdateUnix == nil)
        #expect(sut.rates == nil)
    }
}
