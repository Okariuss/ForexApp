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

        configuration.text = "Loading Rates"
        configuration.textProperties.font = RateListTypography.stateTitle
        configuration.textProperties.color = RateListColor.stateTitle

        return configuration
    }

    static func makeEmpty() -> UIContentUnavailableConfiguration {
        var configuration = UIContentUnavailableConfiguration.empty()

        configuration.image = UIImage(systemName: "list.bullet")
        configuration.text = "No Rates"
        configuration.secondaryText = "No exchange rates are available"

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

        configuration.text = "Could Not Load Rates"
        configuration.secondaryText = "Check your connection and try again."

        configuration.button = .filled()
        configuration.button.title = "Try Again"
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
