//
//  RateListStateConfigurationFactory.swift
//  ForexApp
//
//  Created by Okan Orkun on 30.06.2026.
//  Copyright © 2026 Okarius. All rights reserved.
//

import UIKit

@MainActor
enum RateListStateConfigurationFactory {
    static func makeLoading() -> UIContentUnavailableConfiguration {
        var configuration = UIContentUnavailableConfiguration.loading()

        configuration.text = RatesFeatureStrings.loadingTitle
        configuration.textProperties.font = RateListTypography.stateTitle
        configuration.textProperties.color = RateListColor.stateTitle

        return configuration
    }

    static func makeEmpty() -> UIContentUnavailableConfiguration {
        var configuration = UIContentUnavailableConfiguration.empty()

        configuration.image = UIImage(systemName: "list.bullet")
        configuration.text = RatesFeatureStrings.emptyTitle
        configuration.secondaryText = RatesFeatureStrings.emptyMessage

        applyStyle(to: &configuration)

        return configuration
    }

    static func makeError(
        retryAction: @escaping () -> Void
    ) -> UIContentUnavailableConfiguration {
        var configuration =
            UIContentUnavailableConfiguration.empty()

        configuration.image = UIImage(
            systemName: "exclamationmark.triangle"
        )
        configuration.imageProperties.tintColor = RateListColor.error

        configuration.text = RatesFeatureStrings.errorTitle
        configuration.secondaryText = RatesFeatureStrings.errorMessage

        configuration.button = .filled()
        configuration.button.title = RatesFeatureStrings.retryTitle
        configuration.buttonProperties.primaryAction = UIAction { _ in
            retryAction()
        }

        applyStyle(to: &configuration)

        return configuration
    }
}

private extension RateListStateConfigurationFactory {
    static func applyStyle(
        to configuration: inout UIContentUnavailableConfiguration
    ) {
        configuration.textProperties.font =
            RateListTypography.stateTitle
        configuration.textProperties.color =
            RateListColor.stateTitle
        configuration.secondaryTextProperties.font =
            RateListTypography.stateMessage
        configuration.secondaryTextProperties.color =
            RateListColor.stateMessage
    }
}
