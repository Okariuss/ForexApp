//
//  LoadableViewStateTests.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

@testable import PresentationCore
import Testing

struct LoadableViewStateTests {
    private typealias State = LoadableViewState<String>

    @Test func contentPreservesValue() {
        let subject = State.content("content")

        guard case let .content(value) = subject else {
            Issue.record("Expected content state.")
            return
        }

        #expect(value == "content")
    }

    @Test func statesHaveDistinctValues() {
        #expect(State.idle != State.loading)
        #expect(State.loading != State.empty)
        #expect(State.empty != State.error)
        #expect(State.error != State.content("content"))
    }
}
