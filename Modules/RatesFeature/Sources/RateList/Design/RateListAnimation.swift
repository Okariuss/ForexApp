//
//  RateListAnimation.swift
//  ForexApp
//
//  Created by Okan Orkun on 5.07.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import DesignSystem
import Foundation

enum RateListAnimation {
    static let rateValueTransitionDuration =
        AnimationToken.durationShort

    static let screenTransitionDuration =
        AnimationToken.durationLong

    static let reducedMotionDuration =
        AnimationToken.durationShort

    static let springDamping = CGFloat(0.88)
}
