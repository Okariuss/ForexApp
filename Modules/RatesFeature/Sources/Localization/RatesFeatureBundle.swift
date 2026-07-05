//
//  RatesFeatureBundle.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import Foundation

private final class RatesFeatureBundleToken {}

extension Bundle {
    static let ratesFeature = Bundle(for: RatesFeatureBundleToken.self)
}
