//
//  BaseCurrencyPreferenceStore.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

@MainActor
protocol BaseCurrencyPreferenceStoring: AnyObject {
    var baseCurrencyCode: String? { get set }
}

@MainActor
final class BaseCurrencyPreferenceStore: BaseCurrencyPreferenceStoring {
    private let userDefaults: UserDefaults
    private let key = "preferredBaseCurrencyCode"

    init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults
    }

    var baseCurrencyCode: String? {
        get {
            userDefaults.string(forKey: key)
        }
        set {
            if let newValue {
                userDefaults.set(
                    newValue,
                    forKey: key
                )
            } else {
                userDefaults.removeObject(
                    forKey: key
                )
            }
        }
    }
}
